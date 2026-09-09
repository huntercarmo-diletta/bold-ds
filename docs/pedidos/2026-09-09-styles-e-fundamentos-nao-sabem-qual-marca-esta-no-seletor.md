# PEDIDO · Styles e Fundamentos não sabem qual marca está no seletor — e o filho replugue o DS inteiro pra elas saberem

- **de**: conta-bold-ds (filho B) · **para**: catalogo-diletta (o motor)
- **consome**: motor `v0.116.0` (é a última tag) · ds-diletta `v0.180.0`
- **bloqueante?**: não. As duas abas mostram a marca certa hoje, do meu lado, pelo caminho descrito em «Já tentei». O que se pede é que o motor faça o que o filho está fazendo por ele.

## O que a dona pediu, na palavra dela

*"faz o Styles/fundamentos do catálogo seguirem a marca também"* — depois de ver, no seletor de marca da
`v0.116.0`, a mesma peça na marca do Conta BOLD e na da Diletta, e as duas abas de referência
continuando a mostrar só a paleta do primeiro produto.

## Falta

O seletor de marca é do motor (decisão 3 do ADR-005 do avô): `PlugueDoDs.marcas` diz quais existem,
`temaDaMarca` constrói o tema de cada uma e `CC.marca` guarda a escolhida. **As prévias assinam o
notificador e trocam.** Styles e Fundamentos não: elas leem `Ds.estilos` e `Ds.fundamentos`, que são dois
campos FINAIS do plugue — um `InventarioDeEstilo` e um `Map<String, String>` — e não recebem marca.

Um catálogo com duas marcas mostra o botão na segunda e a paleta da primeira, na aba ao lado.

## Número

Medido no motor `v0.116.0`, por `grep` no pacote em `~/.pub-cache`:

| o que | onde | quanto |
|---|---|---|
| campos do plugue que a marca deveria alcançar e não alcança | `PlugueDoDs.estilos`, `PlugueDoDs.fundamentos` (`ds.dart`) | **2**, ambos `final` |
| quem lê os dois | `aba_de_styles.dart` (3), `aba_de_fundamentos.dart` (5), `conformidade.dart` (2), `camadas_da_linguagem.dart` (2) | **12 sítios**, todos por `Ds.estilos`/`Ds.fundamentos`/`Ds.atual.estilos` |
| quem assina `CC.marca` | `board/bloco.dart` (as prévias) | **1 arquivo** — nenhuma aba |
| quem escreve `CC.marca` | `board/board.dart:924` (o seletor) | 1 |
| o que muda com a marca no meu inventário | `cores` (31 entradas) e `papeis` (21) | 2 famílias de 8 |
| o que NÃO muda | `tipos`, `raios`, `movimentos`, `gruposDeToken`, `descricoesDeToken`, `amostraDePapeis` | 6 famílias — é linguagem |

O último par é a informação: **o white label promete o mesmo inventário com outra cor**, e o
inventário de hoje não tem onde dizer "esta parte é da marca, esta é da língua".

## Já tentei

Fiz funcionar do meu lado, e é isso que está no ar (`packages/catalog`, 09/09):

1. **O plugue virou função da marca.** `configurarDsDoBold({marca})` monta `estilos: _estilosDe(produto)`
   e `fundamentos: _fundamentosDe(produto)`, e assina `CC.marca` uma vez: cada troca no seletor chama
   `Ds.configurar(...)` de novo, com o inventário e a prosa da marca escolhida.
2. **As duas abas, no meu `main.dart`, embrulham a do motor** num `ValueListenableBuilder<String?>(CC.marca)`
   com `KeyedSubtree(key: ValueKey(marca))` — porque `AbaDeFundamentos` guarda a seção selecionada em
   estado e os títulos mudam de nome entre marcas.

Funciona, está medido (gate `a_troca_de_marca_test`: inventário e prosa por marca, volta byte a byte,
conformidade sem violação nova, a aba de Styles troca de hex sem sair dela), e tem dois problemas que
só o motor resolve:

- **Replugar o DS inteiro pra trocar duas famílias.** Os 96 blocos, os grupos, os contratos, o leitor de
  código — tudo é reconstruído a cada clique no seletor pra mudar `cores`, `papeis` e um mapa de prosa.
  Não custa tempo perceptível; custa clareza: o filho está mexendo no estado global do motor de dentro de
  um listener, que é a classe de coisa que o `///` do `previaDeComponente` já ensinou a evitar.
- **A conformidade mede o que está plugado, não o que está na tela.** `_oAliasBateComOInventario` e
  `_oAjusteDeclaradoSeExplica` leem `Ds.atual.estilos`; com o replugue elas medem a marca escolhida por
  acidente do meu listener, e não por desenho do motor. Quem só tem `marcas` e `temaDaMarca`, sem o meu
  truque, tem conformidade da marca default e prévia da outra.

## Conferi no pai

- **`CC.marca` é um `ValueNotifier` público** (`chrome.dart:184`) e o `///` dele diz a regra: *"quem
  assina o notificador reconstrói sozinho"* — foi escrito pra as prévias, e vale igual pras abas.
- **`Ds.estilos` e `Ds.fundamentos` já são getters estáticos** (`ds.dart:689`, `:693`), com um `??`
  pro caso vazio. Resolver a marca ali dentro é uma linha a mais em cada um, e os 12 sítios não mudam.
- **`temaDaMarca` é opcional e recebe `marca` por parâmetro.** É a forma que se pede aqui, pras duas
  famílias que faltam.
- **`AbaDeFundamentos` é `StatefulWidget`** com `_sel` decidido no `initState` a partir dos títulos: se os
  títulos mudarem por baixo sem a aba ser recriada, `_sel` aponta pra uma seção que não existe mais.

## Derivável?

Metade sim, metade não — e a metade que não é a que pesa.

- **`papeis`** o motor conseguiria derivar sozinho: as 21 entradas são `DilettaScheme.light/dark(paleta)`
  lidos campo a campo, e a aba já roda dentro de `Ds.tema(..., escuro: false)`. Mas a paleta da marca
  escolhida hoje só chega ao motor pelo tema que **`temaDaMarca` devolve**, e o motor não abre esse
  widget pra ler o esquema de dentro.
- **`cores`** (a rampa, nome → cor) e **`fundamentos`** (prosa) não derivam de nada: são declaração de
  quem decidiu. A prosa da Diletta mora no pacote dela (`kDilettaFundamentos`), a do Bold no dele.

Então derivar não fecha o caso. O que fecha é o plugue ter como declarar **por marca**.

## O que eu peço

Dois ganchos opcionais, no formato do que já existe:

```dart
final InventarioDeEstilo Function(String marca)? estilosDaMarca;
final Map<String, String> Function(String marca)? fundamentosDaMarca;
```

com três consequências dentro do motor:

1. `Ds.estilos` e `Ds.fundamentos` resolvem pela marca em `CC.marca.value` quando o gancho existe, e caem
   nos campos de hoje quando não existe — **quem tem uma marca só não muda uma linha**, como em
   `temaDaMarca`.
2. `AbaDeStyles` e `AbaDeFundamentos` assinam `CC.marca` — a segunda recriando o estado da seção, porque os
   títulos podem mudar.
3. A conformidade que lê `Ds.atual.estilos` passa a ler `Ds.estilos` — a da marca na tela.

## Se você disser não

Fico com o replugue, que funciona, e escrevo no `///` dele o prazo: *"morre no dia em que o motor
receber a marca nas duas abas."* É a mesma lápide do `fundoDaTelaEmFoco`, que morreu quando o gancho
recebeu a tela. Se a resposta for "deriva `papeis` do tema em contexto e declara só `cores` e prosa",
também serve — desde que a paleta da marca escolhida chegue à aba por um caminho do motor, e não pelo meu
listener.

## Não estou pedindo

- **Que `InventarioDeEstilo` separe "marca" de "língua" por campo.** Seria a forma mais honesta, mas é
  uma reforma do tipo; o gancho por marca resolve o sintoma sem tocar nele. Se um terceiro filho pedir,
  aí é caso.
- **Que o seletor de marca apareça fora do board.** Hoje ele mora nos controles de visão do board, e
  quem quer ver Styles em outra marca escolhe lá e troca de aba. É aceitável; o pedido é sobre o que a aba
  mostra, não sobre onde se escolhe.
- **Nada pro `temaDaMarca`.** Ele já faz o que devia. O que eu tinha de meu ali — pôr o `ThemeData` do
  produto acima do escopo, pra fonte e cor de texto viajarem — foi feito no plugue e não é pedido.

## Como o pai vai saber que funcionou

Um filho com `marcas: {a, b}` e os dois ganchos declarados, sem nenhum listener em `CC.marca` do lado
dele, abre a aba de Styles, escolhe `b` no board, volta pra Styles e vê a rampa de `b`; muda pra `a` sem
sair da aba e vê a de `a`. A conformidade, nesse estado, mede `b` quando `b` está na tela. E o meu
`configurarDsDoBold` volta a receber zero argumentos — o commit que remove o listener é o teste de aceite.

---

## VEREDITO · ENTRA — os dois ganchos na forma pedida (motor `v0.117.0`, 09/09)

Resumo do que o dono do motor escreveu no CHANGELOG e no ledger dele (`catalogo-diletta`, `ee60f34`):

- `estilosDaMarca` e `fundamentosDaMarca` entram **opcionais**; `Ds.estilos`/`Ds.fundamentos` resolvem por
  `CC.marca`; as duas abas **assinam** o notificador (Fundamentos recriando o estado da seção); a
  conformidade lê `Ds.estilos` — a marca na tela.
- **Gancho e não reforma do tipo**, pela medição deste pedido: 2 famílias mudam com a marca, 6 não, e as
  3 que eu não classifiquei (`sombras`, `gradientes`, `ajustesDePapel`) ninguém mediu — *"nome de família
  escolhido de cabeça é o defeito que esta casa mais registra"*.
- **Condição escrita:** é o terceiro gancho «por marca» da casa (`temaDaMarca` e estes dois). *No quarto,
  «por marca» vira um resolvedor em vez de um campo por assunto.*
- Gate dele: `o_inventario_segue_a_marca_test.dart`, 5 casos, os dois últimos são o critério de aceite
  daqui, sem listener do lado do teste. Provado que falha sem o conserto.

## Resposta do filho

**data**: 2026-09-09 · **branch**: `feat/filho-diletta` · motor `v0.116.0 → v0.117.0`.

O critério de aceite era meu e foi cumprido no mesmo commit que sobe o `ref:`: `configurarDsDoBold()`
voltou a **zero argumentos**, o listener em `CC.marca` saiu do plugue, o embrulho das duas abas saiu do
`main.dart`, e o plugue declara os dois ganchos ao lado dos campos de sempre — `estilos`/`fundamentos`
seguem com o Conta BOLD, que é o que o motor lê enquanto ninguém escolheu marca.

O gate `a_troca_de_marca_test` ganhou o caso que prova a aceitação no fonte: o plugue **não contém
`addListener`** e os dois ganchos estão declarados. O caso da aba de Styles trocando de hex sem sair dela
agora roda com a aba do motor crua, sem `ValueListenableBuilder` meu. Catálogo: **109 verdes**.

Anoto a condição do quarto gancho: se um dia este filho precisar de uma quarta coisa por marca, o pedido
certo é o resolvedor, não o campo.
