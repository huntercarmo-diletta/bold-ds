# Pedido · o `DilettaInput` não repassa três coisas que o `DilettaField` dele já tem

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.28.0 · pai v0.53.0
- **data**: 2026-08-08

## O que falta

`autofocus`, `onSubmitted` e `textInputAction` no `DilettaInput`.

**Os três já existem no `DilettaField`**, que é o primitivo que o próprio `DilettaInput` monta por
dentro (linhas 36, 41 e 48 do `diletta_field.dart`; ele repassa os três pro `TextField` nas 146-149).
O que falta não é comportamento novo: é o organismo expor o que o átomo dele já sabe fazer.

**É a mesma forma do descritor de CTA** (`ds v0.41.0`): o `DilettaButton` tinha `isLoading` e o
`DilettaNavigationAction` não tinha onde dizer. A tua frase de lá foi *"repasse do que já existia — o
descritor é que não tinha onde dizer"*.

## A medição — 87 chamadas, e o autofocus está em 20

O `BoldTextField` deste app é o último campo privado com alcance grande: **87 chamadas em 42
arquivos**. Medi prop por prop pra saber o que precisa atravessar:

| prop | chamadas | no `DilettaInput` |
|---|---|---|
| `controller` · `label` · `hint` · `keyboardType` · `onChanged` · `inputFormatters` | 87 · 73 · 64 · 41 · 32 · 31 | ✅ (o `hint` é o `placeholder`) |
| **`autofocus`** | **20** | ❌ |
| `validator` | 17 | — (é `Form`, e é meu; ver abaixo) |
| `maxLines` | 12 | ✅ via `type: long` |
| `obscureText` | 11 | ✅ via `type: password` |
| `errorText` | 11 | ✅ (`error`) |
| `suffixIcon` · `prefixIcon` | 10 · 7 | ✅ (`rightAccessory` · `leftAccessory`) |
| **`onSubmitted`** | **5** | ❌ |
| **`textInputAction`** | **3** | ❌ |

**Vinte sítios com `autofocus`** não é detalhe de conforto: é a tela de valor do Pix abrindo com o
teclado, o campo de senha do login recebendo o cursor, o código de confirmação pronto pra digitar. Sem
ele, cada uma dessas telas ganha um toque a mais — e são as telas mais usadas do app.

O `onSubmitted` + `textInputAction` andam juntos nos 5: é o "próximo/concluir" do teclado avançando o
formulário sem a pessoa procurar o botão.

## O que eu NÃO estou pedindo, e resolvo aqui

**Integração com `Form`** (`validator`, `onSaved`, `autovalidateMode` — 17 chamadas). O teu input não
é um `FormField` e não precisa ser: eu embrulho o teu `DilettaInput` num `FormField<String>` local,
rodo o validador e te passo o resultado no `error:` que você já tem. **Validação é comportamento do
produto; o desenho do estado de erro é teu, e ele já está lá.**

Isso vale como declaração: se um dia você quiser um `DilettaFormInput`, ele nasce medido — mas hoje o
que me falta são três repasses, não uma peça nova.

## O que eu faço hoje sem isso, e o que isso me custa

O campo continua privado, e ele é **o maior pedaço de desenho próprio que sobrou neste app**: 271
linhas com rótulo, pill, erro, contador e a fonte mono dos códigos. Enquanto ele não vira casca, o
produto mantém a própria régua de campo — e campo é onde a pessoa digita dinheiro.

Com os três, a peça vira casca e o alcance privado do app cai 42 arquivos de uma vez — de longe a
maior queda que sobrou.

## Como o pai vai saber que funcionou

`BoldTextField` fica com o `FormField` e a máscara, e mais nada de pintura. As 87 chamadas não mudam
uma linha.

---

## Veredito · ENTRAM OS TRÊS, no mesmo dia, porque é repasse e não peça
**pai**: `ds-diletta` **v0.54.0** · **data**: 2026-08-08 · **critério que pesou**: aplicação

`DilettaInput({autofocus, onSubmitted, textInputAction})`. **Defaults preservados — nenhum consumidor
muda.**

### Você citou o precedente certo, e ele é o que fez isto sair hoje

*"Repasse do que já existia — o descritor é que não tinha onde dizer."* É exatamente isso: os três moram
no `DilettaField` desde sempre, o organismo monta um por dentro e não tinha campo. **Não há decisão de
desenho nenhuma aqui** — o que havia era uma parede entre o átomo e quem o consome.

Por isso não passou pela régua do segundo filho: ela existe pra decidir se um COMPORTAMENTO é linguagem.
O comportamento já é da linguagem; faltava a porta.

### Uma decisão que eu tomei e você não pediu

**`autofocus` só atravessa na variante de UMA LINHA.** A multilinha é outro `DilettaField`, com
`maxLines: 8` — e abrir teclado sozinho num campo de texto longo não é o mesmo pedido nem tem consumidor
medido nos seus 20. O par `onSubmitted`/`textInputAction` atravessa nas duas, porque *concluir* faz
sentido nas duas.

Está no `///` e num teste, então se algum dia a multilinha precisar, o número que promove é seu.

### O que você NÃO pediu é o que fez isto caber num dia

As 17 chamadas de `validator` eram o caminho fácil pra transformar este pedido num `DilettaFormInput` — e
você resolveu do seu lado antes de perguntar, com a divisão certa escrita numa frase:

> *"Validação é comportamento do produto; o desenho do estado de erro é teu, e ele já está lá."*

**Isso é a fronteira desenhada por quem está do outro lado dela**, e não tenho o que acrescentar. Se um dia
o `DilettaFormInput` nascer, ele nasce medido — e a declaração de hoje é o que vai dizer se ele é
necessário ou se era só conveniência.

### Como subir

`ref: v0.54.0`. `BoldTextField` fica com o `FormField` e a máscara, e as 87 chamadas não mudam uma linha —
que é o critério que você mesmo escreveu.

---

## Nota do pai · sobre as negações: recebido, e a decisão do dono generalizou o meu argumento
**data**: 2026-08-08

O pedido de arte morre sem dívida, e eu não fico esperando.

Vale registrar o que aconteceu com a minha recomendação: eu mandei trocar `person_remove` pra
`userCircleMinusLightFull` porque ele diz *remover usuário* e o positivo não. O dono manteve o positivo, e
**a razão dele é a mesma que eu usei pros outros dois** — o positivo perde a negação e mantém o objeto, e
num diálogo o objeto é o que o glifo precisa dizer, porque o título já traz o verbo e o tom já vem do
`state`.

Ou seja: **eu apliquei o argumento em dois dos três e ele aplicou nos três.** A inconsistência era minha —
eu tratei o caso que tinha substituto disponível de um jeito e os que não tinham de outro, e *ter
substituto* não é critério de significado. Fica escrito porque é o tipo de erro que se repete: **a
existência de uma opção não é razão pra escolhê-la.**
