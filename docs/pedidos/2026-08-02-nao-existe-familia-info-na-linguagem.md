# Pedido · não existe família `info` na linguagem, e o app do cliente usa uma há mais tempo que eu existo

- **filho**: conta-bold-ds v0.2.0
- **pai**: ds-diletta v0.24.0 (`DilettaPalette`, `DilettaScheme`)
- **é bloqueante?**: **não.** São 4 chamadas no app. Peço agora porque a adoção é o momento em que a
  ausência aparece, e porque declarar o azul local sem perguntar é o que faz a linguagem nunca crescer

## O que falta

A linguagem tem seis famílias de status: `primary`, `success`, `warning`, `error`, `secure` e `partner`.
**Não tem `info`.**

O app do Conta BOLD tem, e declara `info04` = `#3B82F6` — um azul, usado onde a mensagem não é sucesso, não
é aviso e não é erro: ela só informa.

## A medição

Medido no `app-newbold` hoje, na Fase A da adoção:

| degrau | valor | usos no app |
|---|---|---|
| `info04` | `#3B82F6` | **4** |

Quatro é pouco, e é o número honesto — não vou inflar pedido. O que dá peso a ele não é a contagem, é a
**posição**: dos 42 degraus da rampa do app, 40 casaram com a sua e sobraram dois. Um é `neutral00`, que é
degrau de escala e eu resolvo aqui. O outro é uma **família inteira que a linguagem não tem**.

## Por que não resolvo sozinho

Eu posso declarar `info01..07` na paleta do Bold amanhã. O que eu não posso é declarar o **papel** — porque
papel é derivado pelo pai, e a rampa de um filho não vira `scheme.info` só por existir. O resultado seria:

- uma rampa `info` no filho que o `DilettaScheme` ignora;
- nenhum par `onInfo`/`infoSubtle`/`infoBorder`, que é o que as outras cinco famílias ganham de graça;
- e o gancho `tinta:` sem nada pra medir, que é o falso positivo permanente que você me ensinou a evitar.

Ou seja: eu produziria a metade que aparece e não a metade que importa.

## O que eu peço

Uma leitura, antes de código. Três respostas me servem, e duas delas são "não":

1. **ENTRA** — `info` vira a sétima família, com o par derivado como as outras. Aí eu forneço a rampa;
2. **`secure` já é isso** — se a família `secure` cobre o papel de "mensagem neutra que informa", eu adoto
   ela e apago o azul. Não consigo decidir isso de fora: `secure` tem nome de segurança e eu não sei se o
   papel dele é mais largo que o nome;
3. **NASCE NO FILHO** — o azul é do produto, não da linguagem. Então eu declaro `info04` aqui como cor de
   produto, **fora da rampa**, com o `///` dizendo que ela não tem papel e não deve ganhar um.

Qualquer das três fecha o item. O que eu quero evitar é a quarta, que é o estado de hoje: o app carregando
um degrau que ninguém declarou nem recusou.

## Critério de pronto

`info04` sai de `bold_colors.dart` do app — ou porque virou papel do pai, ou porque virou `secure`, ou
porque ganhou um `///` dizendo que é cor de produto e por quê. Nos três casos o teste de rampa do app perde
a exceção que ele carrega hoje.
