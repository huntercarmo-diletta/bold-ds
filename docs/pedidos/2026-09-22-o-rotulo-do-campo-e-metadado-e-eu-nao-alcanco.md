# PEDIDO · O rótulo do campo é pintado como METADADO, e eu não alcanço para consertar

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.0`, pela tag `web-v0.114.0` deste repo
- **bloqueante?**: **não** — as duas peças estão adotadas e no ar. O que fica é uma
  divergência de AA que eu **não posso** consertar do meu lado, e uma dívida de tela
  já declarada em comentário no meu código.
- **não é peça nova**, então a regra do `DilettaManifesto.busca` não se aplica.

> **Nota de procedência.** Achado no **core-flow-wa** (o webadmin), na varredura de
> 22/09/2026 — a que a designer pediu para saber se restava peça ou token local. Os dois
> fatos apareceram juntos, e é por isso que eles são um pedido só: o segundo é a única
> saída do primeiro, e ela está fechada.


> **Estado depois dos vereditos de 22/09.** Nenhum dos oito cobre este pedido, e um
> encosta: `2026-09-22-o-campo-tem-um-porte-so-e-o-botao-tem-tres` ENTROU, e o veredito diz que
> *«porte de campo não é só altura — degrau de tipo e recuo horizontal andam junto»*. Ou
> seja, **o render do `<diletta-input>` e do `<diletta-dropdown>` vai ser mexido na
> v0.208.0 de qualquer jeito** — a hora certa para o `<label>` ler outro papel e ganhar
> `part`. O veredito não trata cor de rótulo nem `part`; a tese daqui fica de pé.
> E o próprio gate do Bold confirma o diagnóstico: `o_piso_de_contraste_vale_nos_dois_modos`
> cobra 3,0 dos papéis discretos *porque* eles são metadado — o rótulo do campo não é.

## Falta

O `<label>` do `<diletta-input>` e do `<diletta-dropdown>` é pintado em `textMuted` — um
papel de METADADO — e o shadow não publica `part` para ele, então nem você o corrige nem
eu.

## Número

**Medido nas folhas instaladas pela tag**, compondo cor contra cada fundo em que um campo
aparece. O rótulo é texto de interface, então a régua é o piso de **4,5:1** da WCAG 2.2
§1.4.3:

```
                     textMuted   fundo      razão
claro,  sobre bg      #8a8398   #f4f3f6    3,29:1   ✗
claro,  sobre surface #8a8398   #ffffff    3,63:1   ✗
escuro, sobre bg      #686d7e   #0a0b12    3,81:1   ✗
escuro, sobre surface #686d7e   #14151f    3,52:1   ✗
```

**Quatro de quatro abaixo do piso.** Não é um tema, não é um fundo: é a combinação
inteira.

A declaração está nas duas peças, e é a mesma linha:

```js
// diletta-input.js:~196 e diletta-dropdown.js:~126
label { display: block; margin-bottom: var(--diletta-s1);
        color: var(--diletta-textMuted); ${degrau('caption')} }
```

E o `part` não existe para ela. Varrido o que as duas publicam:

```
diletta-input.js      part="caixa"                      (1)
diletta-dropdown.js   part="caixa"  part="controle"     (2)
<label>               — nenhum, nas duas
```

**Sítios deste console** (contados na hora de abrir, 22/09): **6** chamadas de
`<diletta-dropdown>` em 5 arquivos (`ConfigurarPainel`, `TelaGestores`, `SeletorDePerfil`,
`TelaKyc` ×2, e a ordenação da forma estreita do `WaDataTable`) e 2 de
`<diletta-input>` em 2 telas (`TelaKyc`, `TelaGestores`). Todas com rótulo visível —
porque não há outro jeito.

## Já tentei

1. **`::part(...)` no rótulo.** Não existe `part` para ele. `diletta-input::part(caixa)`
   funciona e é o que eu já uso para o raio; o `<label>` está fora do alcance porque não
   foi publicado. Isto não é furar o shadow — é a porta não ter sido aberta.
2. **Herdar do hospedeiro.** `color` herda, mas a regra do shadow declara
   `color: var(--diletta-textMuted)` explicitamente, e declaração vence herança. Testado.
3. **Redeclarar `--diletta-textMuted` no hospedeiro do campo.** Funciona — e é a pior
   saída possível: eu estaria mudando o valor de um PAPEL DA LINGUAGEM para consertar uma
   peça, e o papel vale para todo o resto do console. É exatamente a exceção local que a
   D1 proíbe, e ela consertaria o campo quebrando o metadado das outras 140 leituras de
   `labelSm`.
4. **Esconder o rótulo e nomear por fora.** Não sobrevive ao shadow: `<label for>` de fora
   aponta para o HOSPEDEIRO, e o `<select>`/`<input>` de dentro nasce com id próprio. Nós
   medimos isso em 21/09 e foi o que fez o `WaSelect` deixar de existir aqui.

## Conferi no pai

**E o que eu ia escrever estava errado.** A primeira versão deste pedido dizia
«`textMuted` reprova AA». Ele não reprova no papel dele: o seu próprio pedido
`2026-08-17-a-rampa-de-texto-do-escuro-nao-viaja-a-minha-e-azul` diz, com a razão escrita,
que

> *«o meu `mudo` é METADADO, e ele fica a 3,81 de propósito — passa»*

Passa mesmo, contra o piso de 3:1 de não-texto. **O que está errado não é o papel: é o
USO dele.** Rótulo de campo não é metadado — ele é o nome acessível do controle e o único
texto que diz o que se digita ali. Ele é conteúdo, e conteúdo tem piso de 4,5.

Conferi também que a escolha é da INSTÂNCIA WEB e não da spec: o eixo declarado das duas
peças não tem nada sobre a cor do rótulo, e a linha está escrita à mão no template de cada
uma. Então ou o Dart pinta igual e o problema é dos dois lados, ou a web divergiu — eu só
tenho a metade web, e é o que eu afirmo.

## Derivável?

**Não.** A cor do rótulo não sai de nenhum eixo que eu declaro: eu passo `label`, `valor`,
`estado`, `erro`, `ajuda`, `moldura`. Nenhum deles governa a tinta do rótulo, e nenhum
deveria — a escolha de papel é sua.

## Se você disser não

Ficam duas coisas, e a segunda já está escrita no meu código como dívida:

1. **A divergência de AA fica.** Eu não a conserto sem redeclarar um papel da linguagem,
   e isso eu não faço. Fica registrada aqui, e acessibilidade é o único lugar onde esta
   casa já diverge de propósito — mas divergir exige poder mexer, e aqui eu não posso.
2. **O rótulo duplicado na tela fica.** `ConfigurarPainel.tsx`, linhas 115-123, tem o
   comentário inteiro: a seção já tem um `<h2>Período das séries</h2>`, e o campo embaixo
   repete «Período das séries» porque o rótulo não pode ser escondido. A saída NÃO é
   remover o rótulo — ele é o nome acessível, e «Faixa» fora de contexto não diz nada a
   quem só ouve. Antes da adoção nós tínhamos `rotuloOculto`, que escondia visualmente e
   mantinha o nó.

O preço somado é pequeno em pixels e grande em tipo: é uma peça da linguagem em que a
regra de AA da casa não alcança.

## Não estou pedindo

1. **Que você mude o valor de `textMuted`.** Ele está certo no papel dele, e você já
   escreveu por quê. O que eu peço é que o rótulo leia OUTRO papel — `textSecondary` dá
   5,00 e 5,53 no claro, 10,24 e 9,47 no escuro, e é o que o meu campo lia antes de
   adotar a peça;
2. **uma prop de cor no elemento.** Cor de rótulo não é decisão de tela;
3. **`part` em tudo.** Eu peço um: o rótulo. A caixa e o controle já têm, e eles me bastam
   para o resto;
4. **que o `part` substitua o conserto do papel.** Se vier só o `part`, eu conserto a cor
   aqui e todo filho que adotar a peça vai reprovar até fazer o mesmo — que é o oposto de
   a linguagem carregar a decisão.

## Como o pai vai saber que funcionou

Dois gates, e o primeiro é o que importa:

```
1. contraste do rótulo do campo contra `bg` e contra `surface`, nos dois temas,
   >= 4,5:1  — hoje 3,29 · 3,63 · 3,81 · 3,52

2. <diletta-input> e <diletta-dropdown> publicam part="rotulo", e uma regra
   `diletta-dropdown::part(rotulo) { position: absolute; clip-path: inset(50%) }`
   de fora esconde o texto SEM tirar o nó da árvore de acessibilidade
```

Vale a prova de mutação da família no primeiro: troque o papel de volta para `textMuted` e
o gate tem de ficar vermelho. Se continuar verde, ele está lendo a declaração e não a
composição — que é o modo de falhar que os três produtos desta família já pagaram com o
anel de foco.

---

## Veredito · ENTRA DIFERENTE — metade já estava consertada, e por isso a outra metade dói
**pai**: ds-diletta **web-v2.5.0** · **data**: 2026-09-24

Você mediu `textMuted` nas duas peças, na sua tag. Medido aqui na v2.4.2: **o `<diletta-input>` já
lê `textSecondary` desde a v0.200.0**, e o `<diletta-dropdown>` continuava em `textMuted`.

Isso é pior do que os dois errados juntos: **mesma família, mesmo slot, dois papéis** — e ninguém
tinha posto os irmãos lado a lado, nem eu ao consertar um deles. O seletor foi para
`textSecondary`.

### O que eu NÃO fiz, e é o pedido dentro do pedido

**`textMuted` continua metadado, com piso de 3,0.** O seu próprio gate
(`o_piso_de_contraste_vale_nos_dois_modos`) cobra 3,0 dos papéis discretos *porque* eles são
metadado, e ele está certo. O defeito nunca foi o piso do papel: foi **o rótulo vestir um papel
que não é o dele**. Mudar o piso do `textMuted` consertaria o seu rótulo e apagaria a diferença
entre metadado e texto em toda peça que usa o papel direito.

### A segunda metade: você não alcançava, e agora alcança

`part="rotulo"` nas duas peças. Era a parte do seu pedido que dizia *«nem você o corrige nem eu»* —
e ela vale mesmo com o papel consertado, porque a próxima divergência de tema não vai ter um pai
por perto.

**Os sete**: manutenção ↑ os irmãos concordam · escalabilidade ↑ · **aplicação ↑ decide** — o
rótulo passa o piso de texto · aderência ao mercado ↑ `part` é o mecanismo da plataforma ·
**robustez ↑ decide** — o gate compara os DOIS, que é o que faltava · arquitetura = · conciso =.
