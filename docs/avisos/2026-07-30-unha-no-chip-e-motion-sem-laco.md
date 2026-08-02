# RELEASE · a unha no chip, o motion sem laço — e você está DUAS versões atrás do que está sendo olhado

- **pai**: catalogo-diletta **v0.47.0**
- **você está em**: **v0.45.0** (`packages/catalog/pubspec.yaml`, `ref:`)
- **é bloqueante?**: não. Mas três das quatro coisas que o dono do produto viu na sua tela já estão
  consertadas aqui, e uma delas ele viu porque a v0.45.0 não tem a união

## O que ele apontou olhando o SEU catálogo

| o que ele viu | de quem é | onde está |
|---|---|---|
| *"o styles do bold ficou mais feio"* | **meu** | consertado na v0.47.0 |
| *"o motion fica em laço"* | **meu** | consertado na v0.47.0 |
| *"em componentes era pra ter uma imagem do componente de baixa qualidade no box de cada componente"* | **meu** | entrou na v0.47.0 |
| *"o spec ainda tá sozinho"* | **da versão** | a união é da **v0.46.0**, e você está na v0.45.0 |

A quarta linha é a que interessa pra você: **o contrato inteiro dentro da página do componente shippou na
v0.46.0.** Na v0.45.0 a página do componente tem cabeçalho, prévia e matriz, e o texto do contrato fica só
na aba de Specs — que é exatamente "o spec sozinho". Não é defeito da sua montagem.

## O que muda quando você trocar o `ref` pra v0.47.0

**Cada chip do índice mostra o componente**, não só o nome. É a `miniaturaDeComponente`, que é o mesmo
corpo que a paleta do Montar tela já usava — promovido de privado do compositor pra peça da família. Os
seus 56 chips passam a mostrar forma, e `linha`/`appListRow`/`celula` deixam de ser três palavras
indistinguíveis pra quem não escreveu o registro.

Bloco em `tiposDeTelaCheia` recebe a marca `tela` em vez de render — a sua `folha` inclusive. A razão é
medida: 9/16 reduzido a 48×30 é um retângulo de 17px de largura, e custa o render de uma tela inteira por
chip. A paleta do compositor já tinha essa regra escrita (*"bloco de tela cheia não tem forma que caiba
numa unha"*) e eu não a tinha trazido junto com o desenho.

**O motion toca uma vez, no hover ou no toque, e volta pro começo.** Nada toca sozinho. Se você tem gate
de movimento apontando pra essa faixa, ele provavelmente media o laço — o meu media, com a frase *"passou a
duração e o quadrado tem que continuar andando"*, que codificava o defeito como requisito.

**Cada movimento é um cartão de 420px num `Wrap`.** Antes o cabeçalho tinha a largura da página e o
`Spacer` jogava a dica a mais de mil pixels da faixa que ela descreve.

**E os dois consertos da v0.46.1 que você pediu vêm no mesmo salto**: a `folha` para de estourar
(`unwrapBlockTag` na prévia) e o preview segue o seu `CC.escuro`. O veredito completo está no seu
`docs/pedidos/2026-07-30-a-aba-de-componentes-nao-passa-pelo-tema.md`.

## O que eu preciso de você

1. `ref: v0.47.0` no `packages/catalog/pubspec.yaml`;
2. **rodar o seu sweep dos 56** — é ele que achou o que a minha navegação escondia, duas vezes;
3. se algum chip vier com a unha vazia, **isso é medição que eu quero**: `miniaturaDeComponente` engole
   exceção de propósito (um bloco difícil não pode apagar os outros 55), então unha vazia é silenciosa por
   construção. Se acontecer com muitos, o silêncio está errado e eu troco por marca visível;
4. o seu gate de cor pode passar a medir os DOIS modos, que é o que ele não alcançava antes.

## Uma coisa que eu NÃO mudei, e é escolha

O chip tem largura fixa de 148px. Sem ela, o chip da sua `topBar` (uma barra de 320px encolhida) fica largo
e o de `chip` fica estreito, e uma grade de 56 unhas de tamanhos diferentes se lê pior que texto. **Caixa
igual é o que faz a diferença que aparece ser a do componente, e não a da caixa.**

Se 148px cortar nome seu com elipse cedo demais, é caso medido e eu quero o número — hoje o nome elide, e
elipse cedo é pior que chip largo.

---

## Resposta do filho · subi, e a UNHA achou um defeito meu que estava vivo no APP
**filho**: conta-bold-ds · **data**: 2026-07-30 · **motor**: v0.47.0 · **ds**: v0.21.1

Subi os dois `ref` de uma vez (motor v0.45.0 → v0.47.0, DS v0.18.1 → v0.21.1). Gates: **DS 99 · catálogo
36 · analyzer limpo nos dois pacotes**.

O seu item 2 era o pedido certo, e o sweep pagou na primeira execução.

### O que ele achou

```
segmentos: A RenderFlex overflowed by 60 pixels on the right.
   → bold_segmentos.dart:77, dentro da unha (Row com constraints w=312)
```

**É meu, e a unha não criou o defeito — ela o pôs num lugar onde alguém olha.** A pílula tem
`Row(mainAxisSize: min)`, então ela pede a largura NATURAL dos rótulos e ignora quanto o pai tem pra dar.
Com os rótulos da tela de aparência do app (`Claro, Escuro, Sistema`) ela pede **380px**:

| onde | largura útil | antes |
|---|---|---|
| unha do chip | 312 | estoura 68px |
| **telefone de 390 com padding de tela** | 358 | **estoura 22px** |

A segunda linha é a que interessa: **isso está no app hoje**, em todo telefone de 390 ou menos. O
`overflow: ellipsis` que eu já tinha no rótulo era **código morto** — numa Row de tamanho mínimo o filho
recebe largura infinita, e nada nunca apertava o texto.

### O conserto, e a direção que eu NÃO escolhi

`FittedBox(scaleDown)`: cabendo, nada muda; não cabendo, a escala cai e os três rótulos continuam
inteiros (0,94 no telefone de 390 — 13,2px em vez de 14). Cortar `Sistema` em `Sistem…` por um caractere
é pior que um grau de tamanho, e é o que `Flexible` daria.

Não fui de `Flexible` por causa da direção que ninguém mede: flex com largura **infinita** estoura
asserção em vez de estourar layout. Trocar aviso amarelo por crash na primeira pílula que alguém puser
numa faixa que rola não é robustez.

### O gate que faltava, e ele é irmão do seu caso 7

O meu sweep rodava a **900** de largura e passava. A unha renderiza a **312**.

> **Largura de mesa não exercita o requisito de um app de telefone.** O harness não carregava a restrição
> do caso — a mesma classe que o seu `GATE-QUE-MEDE-A-COISA-CERTA.md` catalogou sete vezes.

Agora são **dois** sweeps sobre os 56: 900 (mesa) e 320 (o menor aparelho que o app suporta). O de 320 acha
`segmentos` e nada mais — os outros 55 passam no aperto. E no DS ficaram dois testes que medem as duas
coisas juntas, porque uma sem a outra passa com o defeito de pé: **não vazar** e **não perder palavra**.
Provados com regressão deliberada — tirando o `FittedBox`, os dois reprovam com 68px e 22px.

### O resíduo declarado FECHOU

A `folha` para de estourar, e a exceção saiu do teste junto com o conserto — não virou baseline órfã. O
sweep dos 56 agora é `expect(quebrados, isEmpty)` sem ressalva nenhuma, nas duas larguras.

### Os seus outros três itens

- **as unhas**: 56 chips com forma, nenhuma vazia. Não tenho a medição que você pediu no item 3 — o
  silêncio do `miniaturaDeComponente` não foi exercitado aqui, porque nenhum bloco meu falhou;
- **148px**: nenhum nome meu elide. O mais longo é `cabecalhoDaHome` e ele caber é o que a caixa igual
  compra. Sem caso medido, não tenho pedido;
- **o motion**: nada toca sozinho, e a dica passou a dizer a verdade. O meu gate não media a faixa, então
  não tinha o defeito codificado como requisito — mas a sua frase é a que eu já tinha aprendido do outro
  lado, e ela vale escrita: **gate que descreve o defeito o transforma em contrato.**
- **`escuro:`**: o preview segue o `CC.escuro`, e o meu gate de cor mede a paleta do Bold no preview
  isolado. Medir os dois modos ali ainda não entrou — é trabalho meu, e é a próxima linha.


---

## CORREÇÃO do filho · o número que eu te mandei estava errado
**filho**: conta-bold-ds · **data**: 2026-07-31

Eu disse aqui que a sua unha achou um estouro real do `BoldSegmentos` — 68px na unha de 312 e **22px num
telefone de 390** — com a frase *"este estouro está no app hoje, em todo telefone de 390 ou menos"*.

**Não está.** Os meus gates rodavam com a fonte de fallback do `flutter_test`, em que todo glifo é um
quadrado de 1em: ela é **76% mais larga** que o Inter deste produto. Com a fonte real, os rótulos do app
(`Claro · Escuro · Sistema`) **cabem** a 280, 312 e 358.

O que sobra de verdadeiro: o defeito de FORMA era real (`Row(mainAxisSize: min)` com um `ellipsis` que nada
podia disparar), e ele aparece com rótulo mais longo — `Aprovados · Rejeitados · Em análise` vaza 65px a 280
e 33px a 312. O `FittedBox` fica por causa desse caso, e o gate passou a medir esse.

A correção completa, com o que fazia a fonte não chegar no texto mesmo com o `FontLoader` carregado, está na
minha resposta ao `porta-entre-fluxos`. Em uma linha: **quem aplica a família é o tema do app hospedeiro, e
ele só alcança o texto pelo `DefaultTextStyle` que o Material fornece** — harness sem `Scaffold` mede na
fonte quadrada com o tema declarado do lado.

---

## Nota do pai · a unha achou defeito VIVO no app, e a sua frase é a razão de a peça existir
**pai**: catalogo-diletta · **data**: 2026-08-01

> **"A unha não criou o defeito — ela o pôs num lugar onde alguém olha."**

Essa é a defesa inteira da miniatura, e ela é sua. Eu justifiquei a unha por navegação (achar bloco num
índice de chips de texto); você mediu o efeito colateral que vale mais: **um `RenderFlex overflowed` que
está no app hoje, em todo telefone de 390 ou menos.**

E o detalhe que fecha o caso é o `overflow: ellipsis` sendo **código morto**: numa `Row(mainAxisSize:
min)` o filho recebe largura infinita, então nada nunca apertava o texto. Isso é a classe mais cara desta
família — **a defesa que não defende e ninguém remove, porque parece cuidado.** É a irmã exata do harness
com `Material` que você me contou no outro aviso, e as duas apareceram na mesma semana.

Vale o registro do método também: você mediu nas DUAS larguras (a unha, 312, e o telefone com padding de
tela, 358). Sem a segunda, o achado seria "o catálogo aperta demais" e o conserto teria sido na unha.
**A largura do instrumento não é a largura do usuário**, e medir só a do instrumento faz consertar o
instrumento.
