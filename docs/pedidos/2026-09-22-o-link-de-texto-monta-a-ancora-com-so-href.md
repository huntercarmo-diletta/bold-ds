# PEDIDO · O `<diletta-text-link>` monta a âncora com SÓ `href`, e o link externo perde a nova aba e o `noreferrer`

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.0`, pela tag `web-v0.114.0` deste repo
- **bloqueante?**: **não** — os links externos continuam `<a>` nativo e funcionam.
  O que trava é a ADOÇÃO: **15 links em dois produtos** não podem usar a peça, e
  um deles carrega `rel="noreferrer"`, que não é conforto.
- **não é peça nova**, então a regra do `DilettaManifesto.busca` não se aplica.

> **Nota de procedência.** Achado no **core-flow-wa** na varredura de 22/09/2026,
> ao classificar os 5 `<a>` de produção por papel. Dois não podiam adotar a peça, e
> eu registrei «1 app, 2 usos, não pede». Na mesma tarde contei o irmão, que é a
> condição que eu mesmo tinha escrito para destravar — e ele tem 13.


> **Estado depois dos vereditos de 22/09.** Nenhum dos oito cobre este pedido, e um dá
> a forma dele: `2026-09-21-os-aria-param-no-hospedeiro` ENTROU como **«lista declarada de `aria-*`
> de estado que o hospedeiro repassa e apaga de si»**. `target` e `rel` são o mesmo
> problema com outros nomes — atributo que o consumidor escreve no hospedeiro e que tem de
> chegar no controle de dentro. **O mecanismo que a v0.208.0 cria para `aria-*` é a
> forma natural deste pedido**: uma segunda lista declarada, para os atributos da âncora.
> O pai já recusou campo por campo para o `aria-*` com o argumento *«o terceiro caso chega
> sem aviso»* — `download`, `hreflang` e `referrerpolicy` são esse terceiro caso aqui.

## Falta

O ramo `<a>` do `<diletta-text-link>` é montado só com `href`: `target`, `rel`
e `download` não atravessam.

## Número

**Lido na fonte instalada**, `diletta-text-link.js:42-44`:

```js
const tag = href && !off ? 'a' : 'button';
const attrs = tag === 'a'
  ? `href="${href.replace(/"/g, '&quot;')}"`
  : …
```

Um atributo. E `observedAttributes` confirma o eixo inteiro da peça:
`['tone', 'underline', 'href', 'disabled']`.

**Dois produtos, os dois na mesma tag `web-v0.114.0`:**

```
                        <a> de produção    com target="_blank"   com rel
internet banking (IB)         16                 13                13
core-flow-wa (webadmin)        5                  2                 2
                                                 ──                ──
                                                 15                15
```

**Todos os 15 têm os dois juntos**, e a forma é sempre a mesma:

```jsx
// IB — AjudaScreen, EntrarScreen, ReceberHubScreen, EmitirBoletoScreen
<a href={inst.links.ouvidoria} target="_blank" rel="noopener noreferrer">Ouvidoria</a>
<a href={c.boletoUrl} target="_blank" rel="noreferrer">Abrir boleto (PDF)</a>

// webadmin — TelaCliente, duas vezes
<a href={enderecoDoConteudo(pessoa, a.arquivo)} target="_blank" rel="noreferrer">
  abrir o documento →
</a>
```

Os três `<a>` restantes do IB **não** são externos (deeplink do app, âncora
interna), e esses de fato poderiam adotar a peça hoje.

**O `rel` não é enfeite.** `noreferrer` corta o `Referer` e o `window.opener`; o
segundo é o que impede a página aberta de escrever na que a abriu. Adotar a peça
sem ele trocaria uma peça local por uma peça da linguagem **e por um buraco**.

## Já tentei

1. **Pôr `target` e `rel` no HOSPEDEIRO.** Não atravessa — é a mesma família do
   `aria-label` no hospedeiro, medida por esta casa em 21/09: o `<a>` de verdade
   mora no shadow e não lê atributo do elemento de fora.
2. **`::part`.** A peça não publica `part` no `<a>` (varrido o arquivo: zero
   `part=`). E ainda que publicasse, `part` governa ESTILO, não atributo.
3. **Interceptar o clique e abrir por `window.open`.** Funciona, e é pior: perde
   o clique do meio, o «abrir em nova aba» do menu de contexto e o
   arrastar-para-a-barra. Um link que só abre por JS deixou de ser link.
4. **Usar a peça só nos links internos.** É o que sobra, e é o que eu faço — mas
   aí a mesma tela tem dois desenhos de link, e o que decide qual é «este vai
   para fora», que é justamente o que o leitor não vê.

## Conferi no pai

- O `///` da peça explica muito bem o ramo `<button>`: *«Sem `href` isto vira
  `<button>`, e não um `<a>` sem destino. Âncora sem href não recebe foco de
  teclado nem é anunciada como link»*. **A decisão de existirem dois ramos está
  certa**, e não é ela que eu contesto — é o que o ramo `<a>` carrega.
- A linha de paridade diz: *«href — SÓ NA WEB: é o `<a>` de verdade, e o Dart
  chama um callback»*. Ou seja, **o ramo `<a>` já é reconhecido como coisa só da
  web**, sem contraparte no Dart para medir. Isso me parece facilitar: não há
  simetria a preservar, só o que a plataforma pede de um `<a>`.
- Conferi que **nenhuma peça da família repassa `target` ou `rel`** — varredura
  nos 29 elementos da tag instalada: **zero ocorrências** das duas palavras.
  Cinco peças rendem `<a>` (`text-link`, `button`, `icon-button`, `file-card`,
  `rail-item`) e as cinco montam a âncora só com `href`. Duas delas ainda usam
  `|| '#'` como destino padrão. **Se a resposta for uma regra, ela vale para as
  cinco**, e é por isso que eu escrevo o gate da última seção assim.

## Derivável?

**Não.** Eu declaro `tone`, `underline`, `href` e `disabled`. Nada aí diz se o
destino é do mesmo site ou de fora — e não deveria: essa é informação do
consumidor, não do papel.

E **não adianta a peça decidir sozinha** por heurística («se o `href` começa com
`http`, abre fora»). O IB tem 13 externos e 3 internos com URL absoluta no meio;
adivinhar acertaria alguns e erraria em silêncio nos outros — que é a classe de
defeito que esta família evita por princípio.

## Se você disser não

Os 15 continuam `<a>` nativo, e **nada quebra**. O preço é de coerência e ele é
recorrente: toda tela que tem link externo ao lado de link interno passa a ter
dois desenhos de link, e a diferença entre eles não descreve nada que o leitor
possa usar.

O custo maior é o próximo produto. `target`/`rel` não é caso raro — é o que todo
link para fora precisa, e a peça é a única da família que rende `<a>` como
propósito principal. Um filho novo vai encontrar isto no primeiro link externo
que escrever.

## Não estou pedindo

1. **Que a peça adivinhe o destino.** Heurística de URL erra em silêncio, e eu
   prefiro escrever `target` do que descobrir que a peça decidiu por mim;
2. **`part` no `<a>`.** Estilo não é o problema aqui;
3. **nada sobre o ramo `<button>`.** Ele está certo, e o `///` explica por quê;
4. **`download`.** Eu não tenho o caso; se ele vier de graça com o mesmo
   repasse, ótimo, mas eu não conto sítio nenhum para ele.

## Como o pai vai saber que funcionou

```
<diletta-text-link href="https://exemplo" target="_blank" rel="noreferrer">ir</diletta-text-link>

espera, no <a> DENTRO do shadow:
  getAttribute('target')  →  "_blank"      ← hoje null
  getAttribute('rel')     →  "noreferrer"  ← hoje null
  getAttribute('href')    →  "https://exemplo"
```

E o gate que fecha a classe, se a resposta for uma regra: **toda peça da família
que renda `<a>` repassa o mesmo conjunto** — hoje são **cinco** (`text-link`,
`button`, `icon-button`, `file-card`, `rail-item`), e as cinco montam a âncora
com só `href`. Varredura na tag instalada: **zero `target=` e zero `rel=` nos 29
elementos.**

---

## Veredito · ENTRA como LISTA, e a sua leitura do precedente estava certa
**pai**: ds-diletta **web-v2.5.0** · **data**: 2026-09-24

Cinco atributos atravessam: `target`, `rel`, `download`, `hreflang`, `referrerpolicy`.

Você leu o precedente do `aria-*` certo, e eu aplico o mesmo argumento no seu caso: **lista
declarada, não campo por pedido**, porque *o terceiro caso chega sem aviso*. Aqui ele tem nome —
você mesmo o nomeou — e por isso os cinco entram juntos.

### O que eu acrescentei ao que você pediu, e é o que uma peça existe pra fazer

`target="_blank"` **sem `rel`** passa a ganhar `rel="noopener noreferrer"`. Não é conforto: é
*reverse tabnabbing* — a página aberta recebe `window.opener` para a sua. Os navegadores de hoje já
implicam `noopener`; **«hoje» não é contrato**, e `noreferrer` ninguém implica. Quem declara `rel`
manda, porque pode estar precisando do referrer de propósito.

Os seus 15 links já traziam os dois juntos. O 16º, que alguém escrever amanhã, não vai trazer — e
ele é a razão de a regra morar na peça e não na revisão de código.

**Os sete**: manutenção ↑ uma lista, um lugar · escalabilidade ↑ · **aplicação ↑ decide** — 15
links em dois produtos destravam · aderência ao mercado ↑ · **robustez ↑ decide** — o `_blank` nu
deixa de existir · arquitetura = nenhum eixo novo, é passagem de atributo · conciso ↑ os cinco
cabem numa constante nomeada.
