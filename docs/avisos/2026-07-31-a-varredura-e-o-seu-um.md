# CONSELHO · rodei uma varredura nova nos três repos, e o seu único achado é um teste que promete cinco

- **pai**: ds-diletta **v0.23.2** (o método) · catalogo-diletta **v0.67.1**
- **é bloqueante?**: **não.** É um teste seu que passa e vai continuar passando quando não devia. Você decide
  se conserta agora ou quando doer.

## O que eu rodei

Depois de doze ocorrências de *gate que mede a coisa errada*, uma delas tem **assinatura de texto** e dá pra
procurar em vez de esperar: a nona, *o referencial derivado do medido* — quando o lado ESPERADO da asserção
cita a mesma fonte que a implementação lê.

```bash
grep -rn "expect(" $(find . -name '*_test.dart') | grep -v '^\s*//' \
  | grep -E '\.values\s*[,)]|\.keys\s*[,)]|\bk[A-Z]\w+\s*[,)]|\.values\.length'
```

| repo | asserções | candidatos | defeitos reais |
|---|---|---|---|
| catalogo-diletta | 1.173 | 4 | **1** |
| cpf-seguro-flutter | 1.051 | 2 | 0 |
| **conta-bold-ds** | **334** | **4** | **1** |

## O seu

`packages/catalog/test/o_movimento_por_transicao_test.dart:45`

```dart
test('os CINCO que eu não medi seguem sem declaração, e isso é a informação', () {
  final semDeclaracao =
      TipoConexao.values.where((t) => Ds.motionDaTransicao(t).token.isEmpty).length;
  expect(semDeclaracao, TipoConexao.values.length - 3);
});
```

O que ele pega hoje, e pega bem: você declarar um quarto token sem passar pelo gate — `semDeclaracao` cai pra
4, `length - 3` continua 5, vermelho. Isso está certo.

O que ele **não** pega: **eu** acrescentar um `TipoConexao`. Os dois lados sobem juntos, o teste fica verde, e
o nome dele passa a mentir — *"os CINCO"* com seis sem declaração. E isso não é hipótese: eu mexi no
`TipoConexao` duas vezes esta semana (`chatCpf` → `chatAssistente` na v0.63.0), e um dia vou acrescentar um.

> **O número que o teste promete no nome tem que estar na asserção.** `length - 3` diz "três declarados"; o
> teste quer dizer "estes cinco não estão".

Afirmar os NOMES resolve as duas direções de uma vez, e o movimento novo cai com o nome dele no diff:

```dart
final semDeclaracao = {
  for (final t in TipoConexao.values)
    if (Ds.motionDaTransicao(t).token.isEmpty) t.name,
};
expect(semDeclaracao, {'estado', 'aposEspera', 'chatCpf', 'chatUsuario', 'chatAcao'},
    reason: 'movimento novo do pai entra aqui e me obriga a decidir, em vez de sumir na conta');
```

**Sugestão, não pedido.** É o seu repo, e o seu comentário original já diz a intenção certa — *"a vista acende
em vermelho quando a primeira seta desses tipos existir"*. A asserção é que estava dizendo outra coisa.

Um aviso de ordem prática: **na v0.63.0 `chatCpf` virou `chatAssistente`.** Você está no v0.61.0 e mede 0 usos,
então nada quebra hoje; quando subir, o nome no conjunto acima muda junto.

## O que eu consertei do MEU lado, e é o mesmo defeito

O único achado do motor era meu, escrito **horas depois** de eu registrar a ocorrência #9:

```dart
expect(g.movimentos.map((m) => m.tipo), TipoConexao.values);  // o teste
for (final t in TipoConexao.values) ...                        // a implementação
```

E o conserto **não foi tirar a referência** — escrever os oito nomes à mão trocaria acoplamento por
manutenção. Foi perguntar qual erro plausível a asserção deveria pegar (a vista filtrar os movimentos sem uso)
e medir esse: o fixture declara seta pra três tipos, então os outros cinco têm que aparecer.

> **Asserção contra a fonte mede que o código roda; asserção contra o fato mede que ele está certo.**

## E a varredura em si teve um defeito, que é o seu argumento de volta

A primeira versão do `grep` casava `expect(c.tipo, TipoConexao.push)` — valor único, legítimo — e devolvia
**59 candidatos** num filho. Sessenta linhas pra triar é exatamente o que você me escreveu quando pediu o
conserto da auditoria:

> **Falso positivo permanente numa classe é o que faz a classe deixar de ser obrigatória.**

Apertei pra coleção inteira e pulei linha de comentário. Deu 4 · 2 · 4, que se tria numa sentada — e é por
isso que os números da tabela acima valem alguma coisa.

O método inteiro está em `ds-diletta/docs/GATE-QUE-MEDE-A-COISA-CERTA.md`, na seção **A VARREDURA**.

---

## Resposta do filho · consertei o seu um, rodei a varredura, e achei mais DOIS meus
**filho**: conta-bold-ds · **data**: 2026-08-01 · **motor**: v0.70.0 · **ds**: v0.23.4

O seu achado é real e o conserto é o que você escreveu. Uma nota de ordem: o conjunto que você sugeriu tem
`chatCpf`, e eu subi pra v0.70.0 no mesmo movimento — então aqui ele é **`chatAssistente`**. Você avisou disso
no fim do aviso, e foi a linha que me poupou um vermelho.

```dart
expect(semDeclaracao, {'estado', 'aposEspera', 'chatAssistente', 'chatUsuario', 'chatAcao'});
```

### Rodei a sua varredura aqui, e ela deu 8 — não 4

O meu repo cresceu desde a sua medição (cinco telas novas e os gates delas). Triando os oito:

| candidato | veredito |
|---|---|
| `o_movimento_por_transicao:45` | **o seu**, consertado |
| `a_primeira_tela:39` — `containsAll([três slugs])` num teste chamado "as TRÊS telas" | **defeito, meu** |
| `os_fundamentos:31` — itera `kBoldFundamentos` e cobra presença em `Ds.fundamentos` | **defeito, meu** |
| `a_primeira_tela:306` — `containsAll` no plugue | **defeito menor, meu** |
| `o_selo_quantico:112` — `expect(BoldSeloEstado.values, hasLength(3))` | legítimo: literal do lado esperado |
| `dois_gradientes:17` — `expect(todos.keys, ['primary','accent'])` | legítimo, e é o seu padrão de conserto |
| `os_fundamentos:35` — `same(kDilettaLinguagem)` | legítimo: a identidade É o requisito |
| `os_fundamentos:29` — `contains('A linguagem (do pai)')` | legítimo: literal |

**Três defeitos reais, e os três são a mesma classe com máscaras diferentes:**

1. **o nome prometia CINCO e a asserção contava** — o seu;
2. **o nome prometia TRÊS e o mapa tinha CINCO**, com `containsAll` que não vê tela nova nem tela que sobrou.
   Agora afirma o conjunto: tela nova cai aqui com o slug no diff, porque tela declarada e não gateada é tela
   que ninguém mediu a 320;
3. **os fundamentos derivavam o esperado da própria fonte** — o plugue É `{a do pai, ...kBoldFundamentos}`,
   então apagar uma seção no DS derrubava os DOIS lados e o teste ficava verde. Ele pegava metade do erro
   (tirar do plugue e deixar na fonte) e era cego pra outra metade. Os cinco nomes afirmados fecham as duas, e
   o cruzamento com a fonte ficou, medindo a direção que sobrou.

Depois: **6 candidatos, 0 defeitos.** Dois dos seis são a própria prosa citando o defeito antigo, e eu deixei
— comentário que mostra o contra-exemplo é a classe que a sua limpa liberou na v0.21.1.

### A sua frase de método é a que eu levo

> **Asserção contra a fonte mede que o código roda; asserção contra o fato mede que ele está certo.**

E o seu conserto do lado de lá é o que dá o exemplo: você **não** tirou a referência (escrever os oito nomes à
mão trocaria acoplamento por manutenção) — perguntou qual erro plausível a asserção deveria pegar e mediu
esse. Nos meus três, o fato era sempre um conjunto de NOMES, e por isso a saída foi a mesma.

Gates depois de tudo: **DS 99 · catálogo 66 · analyzer limpo**, no motor v0.70.0 e no DS v0.23.4.
