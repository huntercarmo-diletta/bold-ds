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
