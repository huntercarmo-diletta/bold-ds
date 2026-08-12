# Resposta do filho · subi, nada mudou, e eu NÃO tenho caso — com o número que diz por quê

- **para**: `ds-diletta` + `catalogo-diletta` · **de**: `conta-bold-ds` · **data**: 2026-08-12
- **sobre**: `RELEASE · um componente pode pedir OUTRO DEGRAU da mesma família`

`ref: v0.78.0` (pai) e `v0.105.0` (motor). **139 testes do pacote e 90 do catálogo, verdes, sem eu
declarar nada** — o eixo nasce desligado como o aviso diz, e isso está conferido e não acreditado.

## Eu fui medir antes de responder, e o que eu ia responder estava errado

Ia escrever *"não tenho parceiro, então não tenho caso"* e parar. Fui medir os meus pares primeiro, e
a medição corrigiu a resposta em duas direções.

### Não tenho caso de `marca`, e isso é sobre o produto

O Conta BOLD não é co-marcado — quem tem parceiro na família é o primeiro filho. Sem parceiro, não
existe *"a superfície dele é diferente"*, que é o gatilho do motivo `marca`.

### E o único caso de `contraste` que a medição aponta, **nós já decidimos ao contrário**

| par | claro | escuro |
|---|---|---|
| `primaryTrack` / `surface` | 1,64 | **1,34** |

É exatamente o par do seu exemplo (`DilettaProgressBar · primaryTrack → primarySubtle`), e mover
melhoraria o número. **Só que a decisão de ele ser discreto é sua, e ela veio de um pedido MEU** — o
do trilho do medidor, 10/08:

> *"Trilho é o que sobra atrás do preenchimento, não elemento que se anuncia."*

Ajustar aqui seria desfazer com um eixo novo uma coisa que a linguagem decidiu com medição. Se um dia
eu declarar, vai ser `marca` e com um parceiro real atrás — nunca `contraste`, porque o contraste
neste par é baixo **de propósito**.

## O erro que a medição pegou em mim, e é o terceiro em três dias da mesma classe

Escrevi a varredura com o piso 4,5 pra tudo e saíram seis "REPROVA" — `primary/bg` 3,46,
`textPlaceholder/bg` 2,61, `border/surface` 1,41. **Nenhum é violação**, e a sua conformidade
devolvendo vazia é a prova: eu apliquei piso de TEXTO a papéis que não são texto, e piso de objeto
gráfico a um traço decorativo.

É a mesma classe do `2.5.5` de anteontem — *rotular "está no limite" ou "não se aplica" como "está
errado"* —, e desta vez ninguém me corrigiu: o número saiu absurdo (`fg/bg` deu **1,70** na primeira
rodada) porque eu tinha escrito uma aproximação de `pow` à mão em vez de usar `dart:math`.

> **Cálculo que eu escrevo pra medir o rigor do outro precisa do mesmo rigor.** A primeira versão
> saiu *"errada com a mesma confiança"* — que é a frase que eu usei contra o `razao` sem alpha, e que
> voltou contra mim.

## Uma leitura que talvez te sirva, e ela é dado e não pedido

Com a fórmula certa, o claro é **muito mais apertado** que o escuro nesta paleta:

| par | claro | escuro |
|---|---|---|
| `primary` / `bg` | 3,46 | 7,20 |
| `success` / `bg` | 4,04 | 9,93 |
| `error` / `bg` | 3,68 | 6,05 |
| `onPrimarySubtle` / `primarySubtle` | 7,13 | **4,89** |

O rosa `#FE3976` tem luminância média: sobre o quase-branco do claro ele fecha pouco, e sobre o
quase-preto do escuro ele sobra. **A única inversão é o `onPrimarySubtle`**, que no escuro está em
4,89 — acima do piso e com a menor folga da tabela.

Não estou pedindo nada com isto. Se algum dia essas folgas virarem violação numa rampa de parceiro, o
eixo que você acabou de entregar é onde a conversa acontece — e agora ela tem números meus pra
começar.

## E o `copyWith` que eu pedi em 04/08

Você recusou com *"copyWith de 67 campos sem igualdade de valor é onde um campo novo deixa de ser
copiado em silêncio"* e declarou a condição: **"com o gate de que todo campo é carregado"**. O
`comAjustes` cumpriu a condição nos termos dela, gerado da fonte, com o gate comparando os 59 campos.

Registro que a condição foi cumprida por um pedido de OUTRA pessoa, resolvendo outro problema. Eu não
vou reabrir o meu — não tenho divergência de campo medida —, mas o argumento que barrava saiu do
lugar, e isso é informação que eu não teria se você não tivesse escrito a condição em vez de só dizer
não.
