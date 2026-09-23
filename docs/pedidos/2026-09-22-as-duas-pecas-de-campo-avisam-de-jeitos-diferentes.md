# PEDIDO · As duas peças de campo avisam de jeitos diferentes, e eu escrevo dois embrulhos

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.0`, pela tag `web-v0.114.0` deste repo
- **bloqueante?**: **não** — as duas peças estão adotadas e as duas funcionam. É custo de
  coerência, e ele é do tipo que só aparece quando alguém adota a segunda.
- **não é peça nova**, então a regra do `DilettaManifesto.busca` não se aplica.

> **Nota de procedência.** Achado no **core-flow-wa** em 22/09/2026, no dia em que as duas
> peças entraram — `<diletta-input>` na barra de filtro e `<diletta-dropdown>` no seletor.
> Eu escrevi os dois embrulhos na mesma hora, e eles ficaram diferentes.


> **Estado depois dos vereditos de 22/09.** Nenhum dos oito cobre este pedido. Dois
> encostam:
> - `2026-09-22-o-campo-tem-um-porte-so-e-o-botao-tem-tres` ENTROU — as duas peças de campo serão mexidas juntas na
>   v0.208.0, que é o momento natural para o contrato de evento ficar igual.
> - `2026-09-21-os-aria-param-no-hospedeiro` ENTROU DIFERENTE, e o pai recusou a saída de campos
>   para escolher **uma regra** — *«o terceiro caso chega sem aviso»*. Este pedido pede
>   exatamente isso: não um evento no `input`, mas **qual é a regra da família** para peça
>   de entrada. O precedente é dele, e é de hoje.

## Falta

`<diletta-dropdown>` emite `mudou` com o valor no `detail`; `<diletta-input>` não emite
evento nenhum — e as duas são a mesma família de peça na mesma emissão.

## Número

**Varredura na fonte instalada**, procurando `dispatchEvent` nas duas peças:

```
diletta-dropdown.js:177   this.dispatchEvent(new CustomEvent('mudou',
                            { detail: sel.value, bubbles: true }));
diletta-input.js          — nenhuma ocorrência
```

O custo aparece no MEU código, e são os dois embrulhos lado a lado:

```ts
// WaCampoSelect — 11 linhas, e o valor vem pronto
el.addEventListener('mudou', (e) => {
  const v = (e as CustomEvent<string>).detail
  if (typeof v === 'string') ouvinte.current(v)
})

// WaFilterBar — o mesmo trabalho pelo caminho da plataforma
el.addEventListener('input', (e) => {
  // `e.target` no hospedeiro vem RETARGETADO e não tem `.value`; o alvo de
  // verdade é o primeiro nó do caminho composto. Medido.
  const origem = e.composedPath()[0] as HTMLInputElement | undefined
  if (!origem || typeof origem.value !== 'string') return
  busca.aoMudar(origem.value)
})
```

A segunda funciona. Ela exige saber que o alvo vem retargetado e que
`composedPath()[0]` é o caminho — **duas coisas sobre shadow DOM que o consumidor precisa
aprender para usar UMA das duas peças irmãs, e nenhuma para usar a outra.**

**Sítios deste console** (contados na hora de abrir, 22/09): **6** `<diletta-dropdown>` em
5 arquivos, **2** `<diletta-input>` em 2. Dois embrulhos, duas formas de ler a mesma coisa.

A assimetria vai além do evento, e as três são da mesma família:

```
                         diletta-input        diletta-dropdown
evento de mudança        nenhum               `mudou` com detail
part publicado           caixa                caixa · controle
escape do `label`        nenhum               `aspas()` — só a aspa dupla
```

## Já tentei

1. **Ouvir `input` nos dois.** Funciona no campo e é o que eu faço. No dropdown eu
   preferiria o mesmo caminho por simetria — mas aí eu estaria ignorando um evento que a
   peça publica de propósito, e o dia em que ele passar a carregar mais do que o valor eu
   não recebo.
2. **Ouvir `mudou` nos dois.** Não funciona: o campo não o emite, e o ouvinte fica mudo
   **sem erro nenhum**. Foi a primeira versão do `WaFilterBar`, e o modo de falhar é
   o pior da família: a barra desenhava, a pessoa digitava, e nada acontecia.
3. **Ler `.value` do hospedeiro.** `undefined` — o valor é do `<input>` de dentro. Medido.

## Conferi no pai

**E a metade errada deste pedido é minha.** Em `2026-09-17-o-campo-apaga-o-que-a-pessoa-digitou`
eu escrevi, na seção «Não estou pedindo», item 3:

> *«evento próprio de mudança. `input` e `change` já sobem compostos; o que falta é o
> campo guardar, não avisar»*

Isso continua verdade, e eu não estou voltando atrás nele. **O que mudou não é a
necessidade — é que agora existe uma irmã, e ela faz diferente.** Na época a comparação
não existia porque a peça de seleção não existia.

Então este pedido não é «o campo precisa de evento». É: **duas peças da mesma família
resolvem o mesmo problema por dois contratos**, e quem paga é quem adota a segunda achando
que ela se parece com a primeira.

Conferi também que o dropdown tem razão escrita para emitir: ele é um `<select>`
espelhado, e o `change` do `<select>` de dentro sobe composto — ou seja, o `mudou` dele é
**adicional**, não necessário. Isso reforça o pedido em vez de enfraquecê-lo: se o evento
próprio é conforto, o conforto devia valer para as duas.

## Derivável?

**Sim, e é por isso que o pedido é barato.** O `mudou` do dropdown não carrega nada que o
`change` nativo não carregue — ele é conveniência de contrato. A mesma conveniência no
campo é `this.dispatchEvent(new CustomEvent('mudou', { detail: campo.value, bubbles: true }))`
no ouvinte que a peça já teria de ter.

Eu peço mesmo assim porque o que eu quero não é o evento: é a **regra**. Qual dos dois é o
contrato da família?

## Se você disser não

Fica o que já está: dois embrulhos com dois caminhos, e um comentário de cinco linhas no
`WaFilterBar` explicando o retargeting para quem ler depois. Não quebra nada.

**O preço é de aprendizado, e ele é recorrente.** Toda peça nova da família obriga o
consumidor a perguntar «esta emite ou eu escuto o nativo?», e a resposta não está em
lugar nenhum a não ser na fonte do elemento. Hoje são duas peças; a régua da `v0.201.0`
lista 13 peças ainda sem instância web.

Se a resposta for **«escute o nativo, o `mudou` do dropdown é que sobra»**, isso me serve
igual — é uma regra, e eu apago meu ouvinte de `mudou`. O que não serve é não haver regra.

## Não estou pedindo

1. **Uma propriedade `value` no elemento.** Já recusei isso em 17/09 e continuo recusando:
   é decisão de API sua, e o atributo resolve;
2. **que o `mudou` do dropdown saia.** Se a regra for «toda peça de entrada emite», ele é
   o certo e o campo é que falta;
3. **evento novo com nome novo.** `mudou` já existe e já é o nome da família;
4. **nada sobre o `part` nem sobre o escape do `label`.** Os dois aparecem na tabela acima
   só para mostrar que a assimetria não é de um eixo, e cada um tem pedido próprio — o
   `part` no rótulo é `2026-09-22-o-rotulo-do-campo-e-metadado-e-eu-nao-alcanco`, e o escape
   é o `2026-09-21-o-rotulo-do-botao-entra-cru-no-html`, que recebeu uma nota do filho no mesmo
   dia — o caminho de ATRIBUTO também quebra.

## Como o pai vai saber que funcionou

```
para cada peça de ENTRADA da família (input, dropdown, e as que vierem):
  digitar/escolher e esperar UM evento de nome `mudou`, com o valor em `detail`
    — ou nenhuma delas emitir, e a regra estar escrita no contrato da família

hoje: dropdown emite, input não
```

Se a decisão for «nenhuma emite», o gate é o contrário e vale igual: **zero
`dispatchEvent` de mudança na família**, com a razão escrita. O que eu preciso é que o
gate exista, porque hoje as duas passam nos gates que existem — cada uma sozinha está
certa.
