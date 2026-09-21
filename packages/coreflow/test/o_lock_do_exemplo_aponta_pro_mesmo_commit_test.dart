// O LOCK DO EXEMPLO É O ÚNICO ARQUIVO DO FILHO GERADO QUE NINGUÉM CONFERIA.
//
// O gate ao lado (`o_gerador_de_filho_tem_saida_conferida_test.dart`) compara SETE arquivos do
// exemplo byte a byte com o que o gerador produz. O `web/package-lock.json` não é um deles, e não
// pode ser: o gerador não sabe escrevê-lo — o que está lá dentro é o COMMIT que o `npm` resolveu, e
// isso só existe depois de uma instalação de verdade.
//
// O buraco cobrou em 21/09/2026, subindo o avô da `v0.204.0` para a `v0.207.0`. O `package.json` do
// exemplo passou a dizer `web-v0.207.0` e o lock continuou apontando para o commit da `v0.204.0`.
// Os 108 gates do pai ficaram verdes, e o exemplo versionado — que é o que um filho novo copia —
// nasceria com uma tag no papel e outra no disco.
//
// É a QUARTA aparição desta armadilha nesta família, e ela tem sempre a mesma cara: `npm install`
// responde «up to date» e não troca nada, porque o lock guarda o commit JÁ RESOLVIDO e renomear a
// tag não o invalida. Quem sobe o pino, lê «up to date» e segue, publica a versão velha.
//
// ## Por que a comparação é com o lock DESTE repo, e não com o remoto
//
// Saber qual commit a tag `web-v0.207.0` aponta exige rede, e gate que depende de rede é gate que
// falha por motivo errado num sábado. O que este repo tem no disco é um segundo lock, o do
// `coreflow_design_system_web`, pinado na MESMA tag.
//
// **Duas tags iguais que resolvem commits diferentes é contradição, e contradição não precisa de
// rede pra ser vista.** É isso, e só isso, que este gate prova.
//
// E o que ancora o nosso lock no remoto é o `o_que_esta_instalado_e_o_que_o_pino_diz_test.dart`,
// que abre a pasta de dependências e cobra que a versão INSTALADA seja a da tag. **A âncora é
// condicional, e vale dizer em vez de deixar entender demais**: ela só puxa depois de uma
// instalação — lock velho no disco, sem ninguém rodar `npm install`, não acende luz nenhuma lá.
// O que este par de gates fecha é o caso real, que é o pino subir num lugar e não no outro. O caso
// de os DOIS ficarem velhos juntos passa por aqui, e quem o pega é a instalação seguinte.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _pacoteDoAvo = 'diletta-design-system-web';
final _exemplo = Directory('../../exemplos/filho_do_coreflow/web');
final _nosso = Directory('../coreflow_design_system_web');

Map<String, dynamic> _json(String caminho) =>
    jsonDecode(File(caminho).readAsStringSync()) as Map<String, dynamic>;

/// O que o `package.json` PEDE — `bitbucket:diletta/ds-diletta#web-vX.Y.Z`.
String _pedido(Directory d) {
  final deps = _json('${d.path}/package.json')['dependencies'] as Map<String, dynamic>;
  return deps[_pacoteDoAvo] as String;
}

/// O que o lock diz que o `package.json` pede — ele guarda a própria cópia, e as duas podem divergir.
String _pedidoNoLock(Directory d) {
  final pacotes = _json('${d.path}/package-lock.json')['packages'] as Map<String, dynamic>;
  final raiz = pacotes[''] as Map<String, dynamic>;
  return (raiz['dependencies'] as Map<String, dynamic>)[_pacoteDoAvo] as String;
}

/// O COMMIT que o `npm` resolveu — o que decide o que desce no disco.
String _commitNoLock(Directory d) {
  final pacotes = _json('${d.path}/package-lock.json')['packages'] as Map<String, dynamic>;
  final entrada = pacotes.entries.firstWhere((e) => e.key.endsWith(_pacoteDoAvo));
  final resolvido = (entrada.value as Map<String, dynamic>)['resolved'] as String;
  return resolvido.split('#').last;
}

void main() {
  test('o lock do exemplo pede a MESMA tag que o `package.json` dele', () {
    expect(_pedidoNoLock(_exemplo), _pedido(_exemplo),
        reason: 'o `package.json` do exemplo e o lock dele pedem tags diferentes. O lock manda: '
            'refaça-o com o endereço EXPLÍCITO (`npm install <pacote>@<tag> --package-lock-only`), '
            'porque `npm install` seco responde «up to date» e não troca nada.');
  });

  test('o exemplo e este repo pinam a mesma tag do avô', () {
    expect(_pedido(_exemplo), _pedido(_nosso),
        reason: 'o exemplo versionado é o que um filho novo copia. Duas tags na mesma casa são duas '
            'versões da linguagem no mesmo produto.');
  });

  test('e, pinando a mesma tag, os dois locks resolvem o MESMO commit', () {
    // Aqui é onde a armadilha do lock aparece: a tag pode estar certa no papel e o commit velho.
    expect(_commitNoLock(_exemplo), _commitNoLock(_nosso),
        reason: 'os dois pedem ${_pedido(_exemplo)} e resolvem commits DIFERENTES. Renomear a tag '
            'no `package.json` não invalida o commit que o lock guarda — o `npm install` responde '
            '«up to date» e o disco continua na versão velha. Refaça o lock do exemplo com o '
            'endereço explícito.');
  });

  test('a varredura lê os arquivos de verdade — senão o gate aprova por cegueira', () {
    expect(File('${_exemplo.path}/package-lock.json').existsSync(), isTrue,
        reason: 'o lock do exemplo sumiu, e sem ele este gate não guarda nada');
    expect(File('${_nosso.path}/package-lock.json').existsSync(), isTrue);
    // um commit é um sha de 40, e não uma tag ou um caminho
    expect(_commitNoLock(_exemplo), matches(RegExp(r'^[0-9a-f]{40}$')));
    expect(_pedido(_exemplo), contains('#web-v'));
  });
}
