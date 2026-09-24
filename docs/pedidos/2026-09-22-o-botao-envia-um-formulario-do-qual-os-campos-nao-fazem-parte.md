# PEDIDO · O botão envia um formulário do qual os campos da própria linguagem não fazem parte

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.0`, pela tag `web-v0.114.0` deste repo
- **bloqueante?**: **não, e a assimetria é o ponto.** O botão já foi adotado nos
  dois formulários deste console; os campos deles continuam `<input>` nativo, e
  **não podem deixar de ser** enquanto a validação do formulário depender deles.
- **irmão**: `2026-09-17-dois-recursos-existem-no-dart-e-nao-atravessam.md` —
  foi ele que trouxe o `formAssociated` PARA O BOTÃO, na `v0.199.0`. Este pedido
  é a outra metade do mesmo par.
- **não é peça nova**, então a regra do `DilettaManifesto.busca` não se aplica.

> **Nota de procedência.** Achado no **core-flow-wa** ao varrer os 27 campos por
> papel, em 22/09/2026 — e ele desmentiu uma razão que estava escrita no nosso
> repo havia dois dias («os campos ficam fora de escopo por densidade»). Dois dos
> quatro campos de autenticação **já estão nos 48px do elemento**. A densidade
> nunca foi o que travava.


> **Estado depois dos vereditos de 22/09.** Nenhum dos oito cobre este pedido. Dois
> encostam, e um deles é pré-requisito técnico:
> - `2026-09-22-o-campo-tem-um-porte-so-e-o-botao-tem-tres` ENTROU — o `<diletta-input>` vai ser mexido na v0.208.0.
>   Porte e participação no formulário são eixos diferentes, mas a peça é a mesma.
> - **`2026-09-21-o-foco-nao-entra-na-peca` ENTROU DIFERENTE, e ele encosta neste.** O veredito põe
>   `delegatesFocus` nas peças de UMA entrada — o campo é uma delas. Isso importa aqui
>   porque, quando `requestSubmit()` acha um campo inválido, o navegador leva o foco até
>   ele: foi o que a prova no navegador mostrou no bloco 3 — **mas com um `<input>` nativo
>   na luz, não com uma peça form-associated.** Numa peça form-associated a plataforma
>   oferece dois caminhos para o foco chegar ao controle de dentro: `delegatesFocus` no
>   shadow (o que a v0.208.0 traz) ou o terceiro argumento de
>   `ElementInternals.setValidity(flags, mensagem, âncora)`. **Não medi nenhum dos dois** —
>   não há peça form-associated de campo para medir —, e por isso isto fica como relação
>   declarada, não como dependência provada.

## Falta

`formAssociated` no `<diletta-input>` e no `<diletta-dropdown>`, mais os três
atributos que fazem um campo participar do formulário: `required`, `name` e
`autocomplete`.

## Número

**Varredura nos 29 elementos da tag instalada:**

```
<diletta-button>      formAssociated   SIM   (4 ocorrências no arquivo)
<diletta-input>       formAssociated   NÃO   (zero)
<diletta-dropdown>    formAssociated   NÃO   (zero)
<diletta-input-chip>  formAssociated   NÃO   (zero)

observedAttributes do <diletta-input>:
  type · estado · label · valor · erro · placeholder · ajuda · inputmode · maxlength
  → sem `required`, sem `name`, sem `autocomplete`
```

O `name` aparece três vezes no arquivo do campo, e as três são `<slot name="…">`.

**E o botão funciona.** Provado no navegador em 22/09/2026, com o pacote
instalado numa página estática, três formulários lado a lado:

```
                              navegador   jsdom
a peça envia                      1         0
<button type="submit"> nativo     1         1
campo `required` vazio: envia?    0         —    (o foco foi para o campo)
host.form === o <form>          true     false

DilettaButton.formAssociated    true
host.attachInternals            function
```

O bloco 3 é o que fecha: com campo obrigatório vazio o envio **não aconteceu** e
o foco andou para o campo — `requestSubmit()` está rodando a validação nativa,
exatamente como o `///` da peça promete. (Em jsdom o 0 do primeiro bloco era
limitação do ambiente: `ElementInternals.form` não resolve o formulário
ancestral lá.)

**Então o par está pela metade, e a metade que falta é a que guarda o dado:**

| | envia | é validado | entra no `FormData` | o gerenciador de senha acha |
|---|---|---|---|---|
| `<diletta-button acao="submit">` | ✅ | — | — | — |
| `<diletta-input>` | — | ❌ | ❌ | ❌ |

**Sítios deste console: 4 campos, em 2 formulários**, e os dois são
`noValidate={false}` — eles dependem da validação nativa que os `required`
declaram:

```
TelaLogin          email    required · name="email"  · autoComplete="username"
                   password required · name="senha"  · autoComplete="current-password"
TelaTrocaDeSenha   password required · name="senhaAtual" · autoComplete="current-password"
                   password required · name="novaSenha"  · autoComplete="new-password"
```

**E só esses quatro — medido, não estimado.** Os outros oito campos de texto do
console que ainda não migraram (cadastro de gestor, editor de perfil, botões do
banco, configuração, cliente) **não estão dentro de nenhum `<form>` e não têm
`required` nem `name`**: não dependem deste pedido, e o que os segura é o porte
(`2026-09-22-o-campo-tem-um-porte-so-e-o-botao-tem-tres`). O número deste pedido é
**4 campos, 2 formulários** — e ele não cresce por contágio.

## Já tentei

1. **Migrar os quatro assim mesmo.** O `<input>` passa a viver no shadow: o
   `required` de fora some junto com ele, o `noValidate={false}` do formulário
   deixa de ter o que validar, e o formulário envia vazio **sem mensagem
   nenhuma**. É o modo de falhar caro, não o barulhento.
2. **Repetir `required` no hospedeiro.** Não atravessa — mesma família do
   `aria-label` no hospedeiro, que esta casa mediu em 21/09. E `required` num
   elemento que não é form-associated não significa nada para o formulário.
3. **Validar por conta própria no React e deixar o campo sem `required`.**
   Funciona, e é o que eu faria se fosse obrigado — e é uma perda: sai a bolha
   nativa, sai o `:invalid`, sai o comportamento de teclado que o navegador dá
   de graça, e entra código meu em duas telas. Trocar plataforma por código é o
   contrário do que adotar a linguagem deveria fazer.
4. **`autocomplete` por fora.** O gerenciador de senhas do navegador lê o
   `<input>` real; um atributo no hospedeiro não chega nele. Perder isso numa
   tela de login não é detalhe.

## Conferi no pai

- **O `formAssociated` do botão entrou por um pedido NOSSO**, o de 17/09
  (`2026-09-17-dois-recursos-existem-no-dart-e-nao-atravessam`, caso 1, `v0.199.0`). Nós
  pedimos metade do par sem ver que era metade, e o veredito registrou com
  razão: *«`<button type="submit">` dentro de shadow não envia formulário de
  fora por definição da plataforma»*. **A mesma frase vale para `<input>`**, e
  é o que eu não enxerguei na época.
- Conferi o ledger inteiro: **nenhum pedido sobre o campo ser form-associated**,
  nem sobre `required`/`name`/`autocomplete`. Não é duplicata.
- Conferi a linha de paridade do campo, e ela **não menciona** nenhum dos três.
  As ausências declaradas ali são outras (`autofocus`, `readOnly`,
  `textCapitalization`…), com o argumento de que «o navegador já tem os
  nativos». Esse argumento é justamente o que **não** vale aqui: o navegador tem
  os nativos, e o shadow é o que os tira de alcance.
- Li o `///` do `pinta()` e o do `mudouAtributo()`: nada neles impede
  `formAssociated`. O botão prova que a arquitetura de render convive com ele.

## Derivável?

**Não.** O que eu declaro ao campo é `label`, `valor`, `estado`, `erro`,
`ajuda`, `placeholder`, `inputmode`, `maxlength`. Nenhum desses diz se o campo é
obrigatório, com que nome ele viaja, ou o que o gerenciador de senhas deve fazer
com ele — e nenhum deveria: são três eixos distintos que só o consumidor sabe.

E **não dá para derivar `required` de `erro`**: `erro` é o resultado de uma
validação que já aconteceu; `required` é a regra que a faz acontecer.

## Se você disser não

Os quatro campos continuam `<input>` nativo, e nada quebra — nem hoje nem
depois. O preço é a forma da assimetria, e ela é estranha de explicar:

> **O botão da linguagem envia; os campos da linguagem não são enviados.**

Um formulário montado inteiro com as peças da família envia vazio, sem
validação, e o gerenciador de senhas não o vê. Não há aviso — o `requestSubmit`
dispara, o `submit` acontece, o `FormData` vem sem os campos. É a classe de
defeito silencioso que o pedido do `<button type="submit">` veio consertar, com
o sinal trocado: lá o clique não fazia nada; aqui ele faz tudo, menos levar o
dado.

E este console é o caso fácil, porque ele tem dois formulários. Um produto
orientado a formulário encontra isto na primeira tela.

## Não estou pedindo

1. **Que o campo vire um `<input>` sem shadow.** A peça está certa em desenhar
   dentro; o que falta é a ponte que a plataforma oferece para isso;
2. **validação própria da peça** (regra de senha, máscara, mensagem). Isso é do
   consumidor, e eu não quero a linguagem decidindo o que é válido;
3. **nada sobre `<diletta-input-chip>`.** Ele também não é form-associated, e
   nele isso está certo: chip não é campo;
4. **nada sobre o botão.** Ele está certo, e foi conferido no navegador hoje.

## Como o pai vai saber que funcionou

```
<form id="f">
  <diletta-input label="E-mail" name="email" required></diletta-input>
  <diletta-button acao="submit" rotulo="Entrar"></diletta-button>
</form>

1. o campo se declara do formulário
     document.querySelector('diletta-input').form === document.getElementById('f')

2. o valor viaja
     new FormData(f).get('email')   →  o que a pessoa digitou   (hoje: null)

3. a validação acontece, e é a prova que mais importa
     com o campo VAZIO, clicar em Entrar:
       o evento `submit` NÃO dispara, e o foco vai para o campo
     (hoje o formulário envia vazio, em silêncio)
```

A terceira é a que separa «o campo aparece no `FormData`» de «o campo participa
do formulário», e é a que eu usaria como gate se fosse escrever um só.

---

## Veredito · ENTRA, e NÃO nesta tag — a obra é maior que o pedido e eu digo por quê
**pai**: ds-diletta · **data**: 2026-09-24 · **entrega prevista**: `web-v2.6.0` · **código nesta tag**: nenhum

Você está certo no mérito e a assimetria é indefensável: o botão é `formAssociated` desde a
v0.199.0 — **pelo seu pedido irmão** — e os campos da mesma emissão não participam do formulário
que ele envia. Medido aqui na v2.4.2: `formAssociated` aparece em **uma** peça das 29, e é o botão.

**E o seu achado de procedência desmonta a razão que estava escrita**: *«os campos ficam fora de
escopo por densidade»* — dois dos quatro campos de autenticação já estão nos 48px do elemento. A
densidade nunca foi o que travava. Ela era a explicação que ninguém tinha conferido.

**Por que não sai hoje, e isto não é fila: é medição.** `formAssociated` num campo não é a flag.
São quatro coisas que só existem juntas, e entregar metade é pior que não entregar:

1. `ElementInternals.setFormValue` a cada mudança — o que acabou de virar possível, porque o
   `mudou` da peça entrou nesta mesma tag (o seu outro pedido);
2. `setValidity` com `required`, e o **terceiro argumento** dela, a âncora — sem ela o navegador
   acha um campo inválido e não tem onde pôr o foco;
3. `formResetCallback` e `formStateRestoreCallback`, senão o campo mente no reset e no voltar;
4. `name` e `autocomplete` observados, que sozinhos são os fáceis.

Você escreveu que não mediu o caminho do foco *«porque não há peça form-associated de campo para
medir»*. É exatamente por isso que isto não sai por dentro de um release de conserto: **o item 2 é
o que decide se o formulário é usável, e ele não tem como ser medido antes de o resto existir.**
Sai como obra declarada, com a peça de teste que prova o foco chegando no controle.

**Os sete**: manutenção ↓ dívida declarada até a `web-v2.6.0` · escalabilidade ↑ · **aplicação ↑
decide** — os seus formulários deixam de precisar de `<input>` nativo · aderência ao mercado ↑
`formAssociated` é o mecanismo da plataforma · **robustez ↑ decide o PRAZO** — meia entrega aqui é
campo que mente no reset · arquitetura = · conciso =.
