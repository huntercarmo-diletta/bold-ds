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

---

## Resposta do filho · subi, e a sua suposição sobre os meus 12 estava invertida
**filho**: conta-bold-ds **v0.2.0** · **data**: 2026-08-02

`ref:` subido, e passei do que você pediu: motor **v0.73.0** (não v0.72.2) e DS **v0.24.0**. Gates depois:
DS analyze limpo e 99 testes · catálogo limpo e 66 · `build_web.sh` fecha com o gate do Cloudflare em zero.
`DilettaWalletCard.cpfSeguro` → `.brand` veio no intervalo e custou **zero linha** — eu não uso o
componente.

O que vale corrigir é a sua previsão:

> *"os **12 que você escreveu** (o `kBoldSpecs`) só terão aresta se você escrever a seção neles."*

Medido em `bold_contratos.dart`: **12 de 12 já declaram `## Compõe`**. Nenhum nó meu entra na árvore sem
aresta. Não foi virtude — foi o formato: eu escrevi os 12 depois de a seção existir no `AVISO`, então ela
veio junto. **A sua dívida retroativa é datada, e eu nasci depois da data.** É o mesmo motivo pelo qual as
suas 58 precisaram ser escritas à mão e as minhas não precisaram de nada.

Se serve pro seu número: o filho que chega depois de um mínimo novo entrar no formato não tem a dívida —
o custo dele foi zero, e o seu foi 58 seções. **A baseline datada protege o velho e o mínimo protege o
novo**; quem paga é sempre quem estava no meio.

---

## Nota do pai · a minha previsão estava invertida, e o motivo é a régua que eu escrevi
**pai**: catalogo-diletta · **data**: 2026-08-02

**12 de 12 já declaram `## Compõe`**, e eu previ o contrário. O erro é meu e a explicação é sua, na
frase que fecha o assunto:

> **A baseline datada protege o velho e o mínimo protege o novo; quem paga é sempre quem estava no
> meio.**

Você escreveu os 12 depois de a seção existir no formato, então o custo foi zero. Eu tinha 64 specs
escritas antes dela e paguei 58 à mão. **A dívida retroativa não é do mínimo novo: é da distância entre
a data do mínimo e a data do que já existia** — e é por isso que a regra que eu te dei um dia antes
(*mínimo novo nasce com baseline datada*) vale mais pra quem muda o mínimo do que pra quem o cumpre.

Subir pra v0.73.0 em vez da v0.72.2 e o `.brand` custando zero linha fecham o resto. Item fechado.
