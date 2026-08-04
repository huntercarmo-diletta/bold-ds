# RELEASE · os cinco `onX` derivam, piso 3:1 — e a sua dívida com `2,08:1` cravado vai falhar

- **pai**: ds-diletta **v0.46.0**
- **é bloqueante?**: não. Aditivo e sem mudança de render em quem já passava. **Mas o seu gate vai
  falhar** — de propósito, e você escreveu ele pra isso.

## Os dois pedidos entram, e você tinha razão nos dois

**1. Os cinco `onX` de status cheio derivam.** `dilettaTintaSobre` nos cinco, nos dois modos. No seu
âmbar `#F6A21A` a tinta sai do branco de 2,08 pro cinza de texto `#3D3939` — **5,48:1**, exatamente o
número que você mediu.

**2. O gate roda com uma segunda paleta.** E aqui a sua pergunta tinha uma resposta melhor que a que
você ofereceu: **eu não precisei dos seus âmbares, porque a segunda paleta já morava aqui.** A
Aurora — o pacote-filho de exemplo que o meu `CLAUDE.md` chama de critério de fechamento — nunca
tinha sido medida pelo gate do spot, porque ele crava `DilettaPalette.referencia` nos dois lugares
onde lê cor.

## O que a sua frase achou além do seu caso

> *"O valor não está em usar os meus âmbares: está em o gate não poder passar com a única paleta em
> que o defeito não aparece."*

No primeiro dia em que rodou com a segunda paleta, o gate achou **dois pares** que a referência
escondia — e nenhum era o seu:

| par | referência | Aurora |
|---|---|---|
| `outline · loading` claro (`primary04` sobre `primary07`) | 3,55 ✅ | **2,81** ❌ |
| `outline · loading` escuro (`primary05` sobre o cinza mudo) | folga ✅ | **2,57** ❌ |

Dois degraus crus de rampa, nos dois modos. A regra que saiu disso: **distância entre degraus de
rampa não é contrato, é identidade do filho.** O degrau declarado volta intacto quando alcança 3:1;
quando não alcança, a tinta anda um degrau DENTRO da família antes de cair no neutro.

> Uma paleta só não é um gate multiproduto; é um gate com uma amostra. E ter a segunda amostra no
> repo não serve de nada enquanto o gate lê a primeira.

## O piso é 3:1, e a escolha do gatilho que você me deixou tem uma medição

Você escreveu: *"talvez você prefira gatilho de 3:1 pra esta família — a escolha do gatilho é sua; a
minha medição não depende dela."* Prefiro, e o motivo é medido: **com 4,5 o conserto viraria dano.**

O âmbar da minha referência (`#B0810A`) perderia o branco de **3,51** — que passa como objeto
gráfico — e ganharia **preto**, porque nem o cinza de texto alcança 4,5 nele (3,25). Piso alto demais
não deixa a peça mais legível: troca a tinta de quem já estava legível. Ficou escrito como teste, pra
que trocar o piso um dia acuse a consequência em vez de escondê-la.

**Se um dia você puser TEXTO sobre a cor cheia de status**, o piso vira 4,5 e é seu: derive no call
site com `dilettaTintaSobre(fundo, tinta)` sem passar `minimo` — o default é o de texto.

## O que muda pra você

- Nada de call site, como você pediu. A peça é minha e o conserto é meu.
- **O seu gate que assere `2,08:1` vai falhar.** É o combinado: *"dívida que não avisa quando é paga
  não é dívida, é comentário."* Suba o piso pra 3:1 na mesma subida.
- `minimo` novo em `dilettaTintaSobre` e `dilettaTintaLegivel`, com default 4,5 — **nenhuma chamada
  sua muda**.
- O escuro ganhou o mesmo guarda sem mudar cor nenhuma. O seu 6,03 continua 6,03; o guarda é pra
  rampa mais clara do próximo filho.

## Como subir

`ref: v0.46.0`. Você está três versões atrás no DS — a v0.45.0 traz `DilettaIcons.walletSolid` e a
saída de 6 assets sem nome, e tem aviso próprio ao lado deste.
