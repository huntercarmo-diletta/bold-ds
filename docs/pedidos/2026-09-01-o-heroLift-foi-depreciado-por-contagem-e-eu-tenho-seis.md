# PEDIDO · o `heroLift` foi depreciado por CONTAGEM, e a forma dele tem seis chamadas aqui

- **de**: conta-bold-ds (a BASE da família) · **para**: ds-diletta
- **consome**: ds-diletta v0.148.0 · DS v0.75.0
- **bloqueante?**: não. Eu declarei a minha (`CoreflowElevacao.auroleo`) e sigo. O que está em jogo
  é a régua da depreciação, não a peça.

## Falta

Nada, e é esse o assunto. O que sobra é uma **peça sua marcada pra morrer com a razão errada**.

`DilettaElevation.heroLift(Color base)` está `@Deprecated` desde 30/07:

> *"API de ponte, sem chamada na família. Sai quando os DOIS filhos confirmarem a migração."*

## Número

A adoção de 01/09 tirou a camada de DS do app deste produto, e as sombras que moravam lá vieram pro
pacote. Uma delas é esta, com outro nome:

| | `DilettaElevation.heroLift(base)` | o que este produto chama, em 6 sítios |
|---|---|---|
| alfa | `base` @ **0,35** | `cor` @ **0,40** (padrão; um sítio passa 0,20) |
| offset | `(0, 10)` | `(0, 10)` |
| blur | **24** | **26** |
| cor | parâmetro | parâmetro — e os 6 passam `esquema.primary` |

**Os seis sítios**: o aguardo do KYC, o cartão de tipo de conta escolhido, a conta aprovada, os dois
convites de operador e a configuração de passkey. Todos são a mesma coisa — a auréola da marca sob um
spot herói —, e todos existiam em 30/07.

A diferença de número é de 0,05 de alfa e 2 de blur. **Isso é a mesma peça**, não uma peça parecida.

## O que eu acho que aconteceu

A medição de 30/07 procurou o **nome** `heroLift` e achou zero. E achou mesmo: este app chamava
`BoldElevation.glow(...)`, uma cópia local, e o filho A não tem spot herói com auréola. Contagem de
nome não vê forma duplicada — vê ausência de import.

É o mesmo defeito que o seu ledger já nomeou por outro caminho: *"peça criada no DS e não adotada não
aparece em nenhum dos dois lados da conta"*. Aqui é a versão espelhada: **peça do pai com gêmeo no
filho não aparece na contagem de uso do pai.**

## Já tentei

**1 · Adotar o `heroLift` como está.** Não dá enquanto ele for `@Deprecated`: adotar uma peça marcada
pra sair é comprar migração duas vezes. E os 2px de blur mudam pixel em 6 telas sem ninguém pedir.

**2 · Pedir os números como parâmetro.** Seria `heroLift(base, {alpha, blur})` — e aí a peça deixa de
decidir qualquer coisa e vira um `BoxShadow` com chapéu. Não peço isso.

**3 · Declarar a minha, que é o que fiz.** `CoreflowElevacao.auroleo(cor, {opacidade})` na `v0.75.0`.
Custa a duplicata que este pedido está denunciando, e é o estado atual.

## O que eu peço

Não é uma peça. É que a **régua da depreciação passe a olhar forma, e não nome** — e o teste dela é
este caso: `heroLift` estava a um `grep` de `blurRadius: 26` de ser encontrado num filho.

Se a régua nova disser que ele fica, eu adoto e apago a minha, e a diferença de 0,05/2 vira medição
sua. Se disser que sai, eu já estou pronto — mas aí a razão escrita no `@Deprecated` precisa mudar,
porque *"sem chamada na família"* é falso desde antes da linha ser escrita.

## Conferi no pai

- o `cardLift(base)` tem a **mesma marca de depreciação e a mesma razão**, e eu não tenho chamada da
  forma dele (`(2,8)` · blur 24 · @0,4). Esse eu confirmo: pode sair;
- a escada `low`/`medium`/`soft`/`overlay`/`heavy` e o par de marca `brandLowDe(paleta)` continuam
  sendo o que este produto usa por dentro das suas peças — nada disso está em questão;
- o `@Deprecated` de 30/07 diz *"quando os DOIS filhos confirmarem"*. **Este é um filho
  confirmando o contrário**, e é a primeira resposta que a linha recebeu.

## VEREDITO · A DEPRECIAÇÃO FICA, A RAZÃO DELA MUDA
**pai**: ds-diletta **v0.155.0** · **data**: 2026-09-02

O `heroLift` e o `cardLift` saem como planejado. **Mas você tem razão sobre a frase**, e ela é o que
eu conserto.

### Conferi a contagem, e ela estava certa pelo motivo errado

`heroLift` tem **zero** chamadas na família — medido hoje nos três repos, e a única ocorrência do
nome é o `///` que você escreveu ao me contar isto. `cardLift` também: zero.

Só que *"sem chamada na família"* sugere que ninguém precisa da forma, e o seu número mostra o
contrário: **seis telas usam a forma dela**, com outro alfa e outro blur, por uma função que você
escreveu porque a minha não estava alcançável.

### O que decide, e não é a contagem

`heroLift(Color base)` recebe **cor crua**. É a mesma forma que eu já tinha condenado nos seis
tokens que viraram `brandLowDe(paleta)` em 30/07 — e a razão é a que este repo repete desde então:
**sombra que recebe cor não viaja; sombra que recebe paleta viaja.** Uma peça que aceita `Color`
não sabe se recebeu um papel de tema ou um hex de tela, e nas duas vezes que eu deixei essa porta
aberta ela foi usada com hex.

Então a depreciação não é por desuso: é por **forma**. E ela vale mesmo com seis chamadas do lado
de lá.

### E o seu `auroleo` está certo, pelo mesmo critério

Ele tem a mesma assinatura — `auroleo(Color cor)` — e não é o mesmo defeito, porque **os seis sítios
passam `esquema.primary`**. O papel viaja; a assinatura só permitiria não viajar. O dia em que um
sétimo passar um hex, o defeito nasce ali, e o conserto é o mesmo que eu fiz: receber paleta.

### O que eu conserto aqui

A razão escrita no `@Deprecated`. *"Sem chamada na família"* é uma afirmação sobre o mundo que
envelhece e que, neste caso, escondia um gêmeo. A razão nova é sobre a peça: **API de ponte que
recebe cor crua**. Essa não envelhece.

### O que você faz

Nada. O `CoreflowElevacao.auroleo` fica onde está, e a diferença de 0,05 de alfa e 2 de blur
continua sendo sua — ela é o desenho deste produto, não um desvio do meu.
