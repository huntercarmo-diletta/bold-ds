# Como nasce um filho do Coreflow

Um produto novo desta família nasce com **uma decisão de cor** e três arquivos. Este documento é a
receita inteira: o comando, o que você decide depois, o que você **não** decide, e como o app recebe
o produto como um flavor de marca.

> A árvore: **Diletta** (a linguagem) → **Coreflow** (a base, este pacote — a camada visual) →
> **os produtos**. O Conta BOLD é o primeiro deles, e não é dono de nada que os outros usem.

## 1 · Em um comando

```sh
dart run coreflow_design_system:novo_filho \
  --id meuBanco --nome "Meu Banco" --cor '#1B5E20' --saida ../meu_banco_coreflow
```

Escreve um pacote com três arquivos: o `pubspec`, a declaração do produto e um LEIAME. **Não escreve
tela, não escreve rota e não escreve app** — gerador que faz isso vira andaime que ninguém apaga.

A saída dele é conferida: `exemplos/filho_do_coreflow/` é a saída versionada, e o gate
`o_gerador_de_filho_tem_saida_conferida` regenera e compara byte a byte. **Gerador sem saída
conferida é template com esperança** — envelhece calado e o primeiro produto novo descobre.

## 2 · O que a cor faz sozinha

A rampa de marca inteira deriva dela, em OKLCH:

- **nove degraus**, com o `L` de cada um medido nas duas rampas reais desta família — elas foram
  desenhadas à mão, por pessoas diferentes, e concordam;
- **o croma é fração do máximo que cabe** naquele `L` naquele matiz, e não do croma da sua marca:
  perto do branco quase não cabe croma, e pedir uma fração da marca devolve cor estourada;
- **a sua cor entra intocada, no degrau que a claridade dela pede.** Um verde escuro é o 03; um
  amarelo é o 07. `DilettaRampa.degrauDe(suaCor)` responde isso antes da primeira tela.

E vem junto a **gramática do material** do Coreflow — card de vidro, botão de canto 16, folha de
canto 22, blur 15, superfície elevada e pressionada. É o que faz o produto parecer Coreflow em vez de
Material puro pintado de outra cor.

## 3 · O que você decide depois, e onde

| decisão | onde | quando |
|---|---|---|
| **o logo e o mapa da arte** | `marcaVisual:` no arquivo do produto | antes da loja. O default é o do Conta BOLD e existe pra a primeira tela desenhar — produto que publica com o logo do vizinho é produto que não declarou a marca |
| discordar de um degrau derivado | `.comMaterial(...)` sobre a paleta | quando o olho discordar da conta. Derivação é ponto de partida com régua, não decreto |
| um papel que só este produto tem | `papeisExtras` da paleta | quando a linguagem não tiver a palavra (ex.: o `vinho` do Bold) |
| **um componente que só este produto tem** | nasce no produto | e **sobe pra base quando um SEGUNDO produto pedir o mesmo** — o protocolo é o de `docs/PEDIDOS.md`, um nível abaixo |

## 4 · O que você NÃO decide

**Erro, aviso, sucesso, cofre e a rampa neutra.** Cor semântica é invariante nesta linguagem — está
escrito em três lugares. Vermelho de erro derivado de uma marca vermelha daria um produto que não
sabe dizer que algo deu errado.

## 5 · Como o APP recebe o filho — a dimensão de marca

O app é um só; os produtos são **flavors**. Hoje ele tem uma dimensão (`environment`: `hml`/`prod`);
o filho entra numa segunda (`marca`), e as duas se cruzam.

### Android — `android/app/build.gradle.kts`

```kotlin
flavorDimensions += listOf("marca", "environment")
productFlavors {
    create("bold")     { dimension = "marca"; applicationId = "com.contabold" }
    create("meuBanco") { dimension = "marca"; applicationId = "com.meubanco" }
    create("prod")     { dimension = "environment" }
    create("hml")      { dimension = "environment"; applicationIdSuffix = ".hml" }
}
```

As variantes viram `boldProd`, `boldHml`, `meuBancoProd`, `meuBancoHml`. O `google-services.json` de
cada uma mora em `android/app/src/<variante>/` — o Gradle escolhe pelo *source set*, sem script.

### iOS — a armadilha que já custou um dia aqui

O `project.pbxproj` deste app escolhe o `GoogleService-Info.plist` **pelo nome da CONFIGURATION**, e
hoje o nome só diz o ambiente (`Debug-prod`). Com marca no meio ele para de servir: as configurations
passam a ser `Debug-bold-prod`, `Release-meuBanco-prod` e assim por diante, e o `shellScript` tem que
ler os dois pedaços. **Quem esquecer isso recebe `Could not get GOOGLE_APP_ID`, que parece
credencial faltando e é flag faltando.**

Cada marca precisa de: um scheme, um `.xcconfig` por configuration, um `GoogleService-Info.plist` em
`ios/Runner/Firebase/<marca>/<ambiente>/`, ícone e `CFBundleDisplayName` próprios.

### O entrypoint

Um por marca, fino, no molde dos que já existem:

```dart
// lib/main_meu_banco_prod.dart
import 'package:meu_banco_coreflow/meu_banco.dart';
void main() => bootstrap(produto: meuBanco, ambiente: Ambiente.prod);
```

```sh
flutter run --flavor meuBancoProd -t lib/main_meu_banco_prod.dart
```

## 6 · A régua — o que prova que nasceu certo

| gate | onde | o que ele mede |
|---|---|---|
| `um_filho_nasce_com_uma_cor` | este pacote | a marca entra intocada, nenhum degrau do Bold sobra, a gramática é herdada, o semântico não deriva, e uma peça do DS desenha com ele |
| `a_rampa_derivada_alcanca_os_pisos` | `ds-diletta` | 8 marcas de prova — amarelo, ciano, quase-preto e quase-branco inclusive — com escada monotônica e os pisos de contraste de cada degrau |
| `o_neto_monta_o_tema_inteiro` | este pacote | o `ThemeData` inteiro sai do produto, sem rosa do Bold em nenhum sítio |
| `o_gerador_de_filho_tem_saida_conferida` | este pacote | o exemplo versionado é a saída do gerador, byte a byte |

**Nenhum deles mede beleza.** O retrato é passo de bancada: renderize a primeira tela e abra a
imagem antes de dizer que está pronto — três defeitos desta casa passaram por gate verde e foram
achados olhando.
