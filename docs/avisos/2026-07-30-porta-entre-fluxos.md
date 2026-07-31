# RELEASE · a seta agora SAI do fluxo (`Ligacao.paraFluxo`)

- **pai**: catalogo-diletta **v0.50.0**
- **é bloqueante?**: não. Acrescenta, e o formato antigo continua lendo.

## O que era o furo

`Ligacao.de`/`para` são índices DENTRO de um fluxo, então não havia como declarar *"este botão entrega o
usuário pro fluxo de Onboarding"* nem *"esta tela só se alcança vindo do hub do perfil"*.

O outro filho mediu no repo dele: **11 cruzamentos em 13 fluxos** — 9 gatilhos que levam pra outro fluxo e
2 telas que só se alcançam de fora. As 2 apareciam SOLTAS no board, e a leitura natural de uma tela sem
seta é *"alguém esqueceu a seta"*: elas passaram meses parecendo dívida.

Se você tem fluxos que se cruzam, o furo é seu também.

## Como declarar

```dart
Ligacao(de: 5, para: 2, tipo: TipoConexao.push, bloco: 'b_9',
        paraFluxo: 'sdk/onboarding-criar-conta')   // ← o fluxoId do destino
```

`para` continua sendo o índice — agora ele conta na lista do fluxo apontado por `paraFluxo`. Ausente ⇒ seta
local, como sempre. **JSON sem a chave continua lendo**, então as suas setas declaradas não migram.

O board desenha no cabeçalho do frame, em âmbar:

```
→ Onboarding · Criar conta      (a saída: o gatilho tem para onde ir)
← vem de Perfil                 (a entrada: a tela solta diz DE ONDE se entra)
```

Âmbar e não azul porque azul já é o parentesco DENTRO do fluxo (camada), e cor igual faria as duas relações
se confundirem justamente onde a documentação some.

## A entrada é DERIVADA — você declara uma vez

```dart
Conteudo.entradasDeOutrosFluxos(fluxoId)   // → [(fluxoDeOrigem, Ligacao)]
Conteudo.saidasParaOutrosFluxos(fluxoId)
```

Você declara a **saída**, no fluxo de origem. O fluxo de destino descobre sozinho que alguém entra nele por
ali — mesmo caminho do `varianteDe`, e a mesma razão: **parentesco declarado duas vezes diverge no primeiro
conserto.**

## Duas coisas que valem pra quem lê o motor

**Por que campo e não tipo novo.** Quem pediu levantou a objeção antes de mim, citando a auditoria dele: é o
sexto campo opcional de `Ligacao`. O gatilho não disparou, e a regra que ficou escrita é:

> **O gatilho de virar tipo é acumular eixo INDEPENDENTE, não acumular campo.**

Os cinco anteriores são eixos (quem dispara, onde encosta, sob que condição, com quanto de espera, decidido
por quem). `paraFluxo` **qualifica um campo que já existe** — é namespace, não flag.

**O risco que o campo criava, e que eu consertei de antemão.** `para` deixa de ser índice deste fluxo, e
**vinte sítios do board comparam `l.para == i`**. Uma seta pro índice 2 de outro fluxo casaria com a tela 2
daqui e desenharia uma seta que não existe. O conserto é `Ligacao.ehLocal` — **um predicado no modelo, não
vinte guardas** —, e a lista de ligações continua inteira, porque filtrar na origem faria o editor SALVAR
sem as setas que saem.

**Se você tem código que lê `Ligacao` por fora do board, use `ehLocal`.** É o único ponto de atenção desta
versão.

## E um gate de graça

```dart
Conteudo.ligacoesParaFluxoInexistente(fluxosQueExistem)
```

Chave errada falha CALADO: não casa, o board cai nas setas derivadas, e nada avisa. Recebe as chaves válidas
por parâmetro porque o conteúdo conhece as ligações e não os grupos — quem tem os grupos é você.

## O que eu preciso de você

1. `ref: v0.50.0`;
2. se você tem cruzamento entre fluxos hoje resolvido em prosa, declare — e me diga quantos eram. **Dois
   filhos com o mesmo caso é o que promove uma forma de "caso do produto" pra "gramática da família"**;
3. rodar o gate da chave no seu conjunto de fluxos.
