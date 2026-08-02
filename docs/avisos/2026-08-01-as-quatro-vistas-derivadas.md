# RELEASE · a quarta vista derivada entrou, e a sua aba já a recebe sem você fazer nada

- **pai**: catalogo-diletta **v0.72.2** (a Árvore) · `ds-diletta` **v0.24.0** (o dado que ela precisa)
- **é bloqueante?**: não. Aditivo, e a sua aba de Fundamentos é a do motor inteira — a pill nova aparece
  quando você subir o `ref`.

## O que mudou

A **Árvore de dependências** entrou: de que cada peça é feita, e — a parte que ninguém responde de cabeça
— **quem quebra se ela mudar**. Ela deriva do `## Compõe` dos contratos, e o dado não existia: a seção
estava em **8 das 71 specs** do DS. Foram escritas (69 de 71) na v0.24.0.

Você usa `AbaDeFundamentos` como a aba inteira, então a vista entra sozinha assim que houver composição
declarada — e ela **só aparece no índice se houver**, pela mesma régua da seção de Dados: item de índice
que não leva a nada é pior que ausência.

## O que você faz

Subir o `ref` do motor e do DS. Nada mais.

## O que ela vai mostrar no seu catálogo, e é uma medição sua

O número que a página abre é **quantas das suas peças declaram do que são feitas**. Nos seus 56 blocos,
os que apontam pro contrato do pai herdam o `## Compõe` das 69; os **12 que você escreveu** (o
`kBoldSpecs`) só terão aresta se você escrever a seção neles.

Isso não é cobrança e o gate não muda: `## Compõe` continua opcional, e ausência degrada — a peça entra
na árvore sem aresta. Mas vale saber, porque é o mesmo movimento que você já fez com os 12 contratos: a
página só mostra o que alguém declarou.

## Uma coisa que você me ensinou e está no código desta vista

Componente e token se separam pela **existência do outro nó**, não por uma lista de nomes reservados:
`- Icon` vira seta porque existe um componente com aquele slug, `- Color` fica token porque não existe.

A razão é a sua, de outro assunto: **lista fixa de nomes envelhece, e a árvore já sabe.** Foi assim que a
auditoria passou a derivar o produto local do nome do pacote em vez de uma lista, e é a mesma escolha aqui
— uma tabela de "estes são tokens" erraria no primeiro filho que promovesse um token a componente.

## Como isso chega

`ref:` pra **v0.72.2** do motor, e **v0.24.0** do DS.
