# RELEASE · um componente pode pedir OUTRO DEGRAU da mesma família, por marca ou por contraste

- **pais**: `ds-diletta` **`v0.77.0`** (o eixo) + **`v0.78.0`** (ligado nos 124 sítios) ·
  `catalogo-diletta` **`v0.105.0`** (a seção que audita)
- **é bloqueante?**: **não.** O eixo nasce desligado: sem ajuste declarado, `s.primary` continua sendo
  `s.primary` e nenhum pixel muda. Os 409 testes da linguagem confirmam
- **o que ele resolve pra você**: você é white-label. Este é o eixo de adequação a parceiro — e a lista
  dele é, literalmente, **o mapa do que um parceiro novo pode mudar**

## O que é, e o que ele deliberadamente NÃO é

O terceiro filho (o de governo) tem uma camada de componente com **196 slots que aliasam qualquer papel**.
Nós olhamos e recusamos: ali o papel semântico não protege nada — `Button/Surface` pode apontar pro verde.

O pedido do dono do produto foi outro, e é o contrato:

> *"não queria perder o sentido do role semântico, mas ainda manter uma certa adaptabilidade que às vezes
> vai ser por questões de marca / melhor contraste — mas nunca uma coisa muito fora disso."*

Então a troca existe e é **limitada**:

| trava | o que ela garante |
|---|---|
| mesma **família** | `primary → primarySubtle` sim; `primary → success` **recusado** |
| **motivo** fechado: `marca` ou `contraste` | não existe ajuste "porque quis" |
| motivo `contraste` **medido** | o par novo tem que ler melhor. Se piorar ou empatar, reprova |
| destino existe e não é vazio | typo e papel opcional não declarado são acusados |

A família sai do NOME, sem ninguém declarar. Nos **21 papéis** que você declara em `_papeisDoBold()`, as
famílias com mais de um degrau são: `primary` (5 seus: `primary` · `onPrimary` · `primarySubtle` ·
`onPrimarySubtle` · `primaryTrack`), `success` (4), `surface` (2) e `text`. É dentro delas que a adaptação
cabe.

## Como se declara, e é uma linha no tema

```dart
DilettaTheme.resolve(
  palette: paletaDoParceiro,
  ajustesDePapel: const [
    DilettaAjusteDePapel(
      componente: 'DilettaProgressBar',
      de: 'primaryTrack', para: 'primarySubtle',
      motivo: MotivoDoAjuste.marca,
      nota: 'o trilho do parceiro X é pálido demais sobre a superfície dele.',
    ),
  ],
)
```

Nada mais muda. **Os 124 sítios de leitura da linguagem já passam pelo eixo** — cada componente resolve o
scheme com `DilettaTheme.schemeDe(context, 'DilettaX')`, então o ajuste chega sem você tocar em componente
nenhum.

O par acima usa dois papéis que **você** declara, e não invento: `primaryTrack` e `primarySubtle` estão os
dois no seu mapa. Medi as famílias antes de escrever isto: **9 das 15 têm movimento que melhora contraste**
no claro e 10 no escuro. As que não têm são as de um membro só (`fg`, `divider`) e o vidro — e o seu
`glassTint` cai justamente nessa: vidro não tem para onde ir dentro da família.

## O caso que é seu

Você tem parceiros, e o degrau que funciona sobre a superfície de um pode não funcionar sobre a do outro.
Antes deste eixo, a única saída era mexer no PAPEL — e papel é lido por **36 componentes** no DS: mudar
`primary` pro parceiro X mudava 36 peças de uma vez, sem jeito de mudar uma.

E a leitura que talvez interesse mais ao seu produto: **a lista de ajustes é o inventário do que é
negociável.** Quando um parceiro novo pedir, a resposta *"isto sim, aquilo não"* passa a ter uma página,
em vez de morar na cabeça de quem mantém.

**`marca` não precisa melhorar o contraste.** Se a identidade do parceiro pede o degrau mais pálido, é
`marca` e passa. A página mostra o número **em vermelho** — quem ajusta por identidade tem o direito de
piorar e o dever de ver.

## O que você vê no catálogo

A aba de **Styles** ganha `AJUSTE POR COMPONENTE`, logo depois de `PAPEL SEMÂNTICO` — a de cima diz o que
cada papel significa, esta diz onde alguém pediu outro degrau. Agrupada por componente, com o antes/depois
por modo.

**Os números abaixo são ILUSTRAÇÃO DA FORMA, não medição da sua paleta** — eu não rodei o seu produto pra
escrevê-los. Os seus saem quando você declarar:

```
DilettaProgressBar
  primaryTrack  →  primarySubtle                    [marca]
  claro  · 1.24:1 → 1.81:1
  escuro · 2.90:1 → 4.06:1
  o trilho do parceiro X é pálido demais sobre a superfície dele.
```

Você declara **nomes**, não cores: a página resolve os dois papéis no seu `estilos.papeis`. Cor declarada
duas vezes é cor que divergiu — e divergiria justamente na página que existe pra auditar.

A medição usa `razaoNaTela` e não `razao`, e a razão é sua: `razao` ignora o alpha, e o seu `border` do
escuro é branco a 8% — foi você que mostrou que um número assim sai *"errado com a mesma confiança"*. Fundo
translúcido devolve **sem medição** em vez de chutar, o que atinge o seu `glassTint`.

## As duas regras que entram na SUA conformidade

Só depois que você declarar. Nada é cobrado de quem não declarou.

| regra | quando | gravidade |
|---|---|---|
| `ajuste-com-motivo-invalido` | motivo fora de `marca`/`contraste` | **erro** |
| `ajuste-sem-papel-no-inventario` | `de`, `para` ou `surface` não estão em `estilos.papeis` | aviso |

Uma nota específica sua: os seus papéis de produto (`cascaDeTopo`, `lista`, `linha`, `ilustracao`,
`esqueleto`…) **não** são papéis do DS, então não servem de `de`/`para` — o gate do pai devolveria
`ajuste-para-papel-inexistente`. Eles continuam desenhando na aba como sempre; só não são alvo de ajuste,
porque o eixo mexe no vocabulário da LINGUAGEM.

## O que eu NÃO estou pedindo

- que você declare agora. A seção fica invisível até existir o primeiro ajuste, e isso é o correto;
- que você use `contraste` como motivo padrão. **Motivo que o gate não mede é comentário** — o gate mede
  este, então rotular de `contraste` um ajuste de gosto reprova. Se a razão é identidade, é `marca`;
- nada sobre a camada de componente da ciX. Ela **não entra**, e o registro do porquê está no `ADR-005`.

## E este eixo responde a um pedido SEU de 04/08

Você pediu `copyWith` na paleta e eu recusei, com o argumento de que *"copyWith de 67 campos sem igualdade
de valor é onde um campo novo deixa de ser copiado em silêncio"* — e declarei a condição de subida: **"com
o gate de que todo campo é carregado"**.

Este eixo precisava exatamente disso pro scheme, e a condição foi cumprida nos termos dela: o `comAjustes`
é **gerado da fonte** e o gate compara os 59 campos do gerado com os do construtor. Campo novo sem regerar
**falha**, em vez de sumir na cópia.

O `copyWith` da PALETA continua não subindo — mas o argumento que o barrava agora tem uma resposta
demonstrada, e se você medir divergência de um campo fora do eixo de material, o caminho está aberto.
