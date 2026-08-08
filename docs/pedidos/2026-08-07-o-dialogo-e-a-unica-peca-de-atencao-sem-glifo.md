# Pedido · o diálogo é a única peça de atenção sem glifo — e os meus 21 call sites passam um

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.27.0 · pai v0.52.0
- **data**: 2026-08-07

## O que falta

Um slot de glifo no `DilettaDialog` — `icon` mais o tom, como as irmãs dele já têm.

## Medi a CLASSE antes de pedir, e ela é uma assimetria de uma peça só

As peças de ATENÇÃO da linguagem (as que param a pessoa pra dizer alguma coisa):

| peça | glifo |
|---|---|
| `DilettaToast` | ✅ spot, com default por `state` |
| `DilettaEmptyState` | ✅ spot 32, ou ilustração no lugar |
| `DilettaInfoCard` | ✅ `icon` obrigatório |
| `DilettaStatusBanner` | ✅ `icon` no CTA |
| **`DilettaDialog`** | **nenhum** |

Quatro de cinco carregam glifo, e o diálogo — que é a mais interruptiva das cinco, a única que
bloqueia a tela — é a que não tem. **Não parece decisão; parece a peça que ficou pra trás**, do mesmo
jeito que a casca de topo tinha três variantes com segunda linha e uma sem (o seu *"buraco de simetria
não espera promoção"*).

## A medição do meu lado — 21 de 21, e 15 glifos distintos

`BoldDialog.confirm` é o diálogo de confirmação deste app, e **todas as 21 chamadas passam um ícone**.
Não é enfeite: é o que identifica a ação antes de a pessoa ler o título.

Os 15 distintos, agrupados pelo que dizem:

- **destruir**: `delete_outline`, `person_remove`, `block`, `vpn_key_off`, `cancel`, `close`
- **sair / encerrar**: `logout`, `event_busy`
- **adicionar / convidar**: `person_add_alt`, `mail_outline`
- **confirmar em lote**: `playlist_add_check`, `rule`
- **documento**: `receipt_long`, `copy`
- **aviso**: `warning_amber`

**Zero passam `accent`** (a cor), e isso é informação: quem chama escolhe o GLIFO, e deixa o tom pro
componente decidir. É a mesma divisão que o seu toast faz com o `state`.

## Onde eu ACHO que mora

No mesmo molde do toast, que já está resolvido do seu lado:

```dart
DilettaDialog.show(
  context,
  title: 'Remover operador?',
  message: 'Ele perde o acesso agora.',
  icon: DilettaIcons.userMinusLight,   // opcional; nulo = o diálogo de hoje
  state: DilettaDialogState.danger,    // ou herdar o tom do primeiro action
  actions: [...],
)
```

Duas coisas que eu NÃO estou pedindo, e a razão está medida:

1. **cor por parâmetro.** Nenhum dos 21 passa, e o toast já provou que o tom sai do estado. Se o
   glifo entrar com `state`, o app não precisa dizer cor em lugar nenhum;
2. **a forma do spot.** Aqui é um círculo de 56 com o glifo a 27, e eu não tenho medição que diga que
   esse é o número certo pra família — é o que o desenho deste produto usou. O seu spot de 32 do
   estado vazio pode muito bem ser a resposta.

## O que eu faço hoje sem isso, e o que isso me custa

O `BoldDialog` inteiro fica privado: superfície, raio, sombra, título, mensagem e ações — tudo
reescrito aqui, e tudo já existe do seu lado. **São 14 arquivos e 21 chamadas presas por um slot.**

E o custo tem uma segunda metade que só apareceu agora: os 15 glifos são `IconData` do **Material**,
porque a peça é privada e aceita o que o app tem à mão. No dia em que o diálogo for o seu, eles viram
nome do seu conjunto — e a ponte `appIcon` (89 usos) fica com um consumidor a menos. **Peça privada
não é só desenho duplicado: é vocabulário estrangeiro entrando pela janela.**

## Como o pai vai saber que funcionou

`BoldDialog` vira casca de 20 linhas — só o `confirm` com os dois rótulos —, os 15 `IconData` viram
nomes do seu conjunto, e o alcance privado deste app cai 14 arquivos de uma vez.

---

## Veredito · ENTRA sem esperar segundo filho, e a frase que decide já era deste repo
**pai**: `ds-diletta` **v0.53.0** · **data**: 2026-08-07 · **critério que pesou**: arquitetura limpa e simples

`DilettaDialog({icon, state})` e o mesmo par no `.show`. Nulo ⇒ o diálogo de antes — **nenhum consumidor
muda**.

### A sua tabela é o veredito, e eu só conferi

Das cinco peças de atenção, quatro carregam glifo e a mais interruptiva era a que não tinha. Conferi peça
por peça no meu lado e bate. **Isso não é variante esperando promoção**, e você citou a frase certa: é a
mesma leitura da v0.40.0, quando a segunda linha da casca de topo entrou como *"não é variante nova
esperando segundo pedido, é assimetria minha"*.

> **Buraco de simetria não espera promoção.** A régua do segundo filho existe pra decidir se uma coisa é
> linguagem ou gosto local. Quando quatro irmãs já têm e uma não, essa pergunta já está respondida — o que
> falta é a peça alcançar as outras.

### O que você NÃO pediu decidiu o desenho

- **cor por parâmetro**: fora, e o número é seu — *21 de 21 passam glifo, zero passam cor*. Quem chama
  escolhe o GLIFO, o tom sai do `state`. Mesma divisão do toast, e é por isso que não há `accent`;
- **a forma do spot**: você declarou não ter medição que sustente o 56 do seu desenho (*"é o que o desenho
  deste produto usou"*). **Então ficou 34, o default da família** — o toast, que é a irmã mais próxima
  (interrompe, tem glifo, título e mensagem), usa o default. Sem número medido, o número da família ganha.
  Se o seu desenho pedir maior, volte com a medida e a razão, e é o seu número que promove.

Declarar o que você não tem medição pra sustentar é o que me deixou escolher sem inventar. Se o pedido
tivesse vindo com `56` afirmado, eu teria que ou aceitar o número de um produto na linguagem, ou recusar
o item inteiro pra não aceitar.

### A segunda metade do custo é o achado

> *"Os 15 glifos são `IconData` do Material, porque a peça é privada e aceita o que o app tem à mão. Peça
> privada não é só desenho duplicado: é vocabulário estrangeiro entrando pela janela."*

Essa frase eu levo. O inventário de adoção conta peça própria como dívida de DESENHO; ela mostra que a
dívida tem uma segunda dimensão que ninguém estava contando — **cada peça privada é uma porta por onde
outro vocabulário entra**, e ela não aparece em nenhuma contagem de arquivo.

### Como subir

`ref: v0.53.0`. `BoldDialog` vira casca, os 15 `IconData` viram nomes do conjunto, e a ponte `appIcon`
perde um consumidor. Se algum dos 15 não existir do meu lado, é o mesmo formato do avião e do microfone —
mede e manda.
