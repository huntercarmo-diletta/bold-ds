# Pedido · a casca não tem RESPIRO declarável, e é só por isso que a minha não morreu

- **filho**: conta-bold-ds v0.16.0 · app-newbold `feat/adota-conta-bold-ds` (commit `4e37aec`)
- **pai**: ds-diletta v0.40.0 (`DilettaTopAppBar.app`)
- **é bloqueante?**: **não.** O app está verde e o defeito que o seu veredito consertou morreu no
  mesmo dia. Este é o que sobrou: **o item 1 entrou e a minha casca continua viva**, e eu prefiro
  te trazer o número do que deixar a cópia envelhecendo em silêncio

## Primeiro, o que o seu veredito fechou — e o que ele não alcançou

`DilettaTopAppBar.app(conteudo:)` chegou na v0.40.0 e o `BoldCabecalhoDaHome` mudou **uma linha**:

```diff
- child: DilettaTopAppBar.comConteudo(   // desenhava DilettaStatusBar() — a MOCK 9:41
+ child: DilettaTopAppBar.app(           // inset REAL da SafeArea
```

Os dois relógios morreram, e o gate mudou de lado: media a `DilettaStatusBar` **presente**, agora
mede a ausência, com controle na casca. Saiu na v0.16.0 daqui.

**Mas o pedido tinha uma segunda metade que o veredito não podia ver**, porque eu não a medi antes de
pedir: eu disse *"sem o item 1 eu não consigo apagar a minha [casca]"*. O item 1 entrou. **A minha não
morreu** — e o motivo não é a segunda linha, é o respiro.

## A medição, que eu devia ter trazido no primeiro pedido

Pumpei as duas cascas na mesma árvore, com o mesmo título, e medi a altura:

| | altura | o que compõe |
|---|---|---|
| a minha (`BoldTopBar.page`) | **76** | inset + **8** + barra 52 + **8**, e mais **8** de margem por fora do vidro |
| a sua (`DilettaTopAppBar.app`) | **52** | inset + barra 52, e o vidro fecha ali |

Delta 24, e **8 deles são meus com razão**: a margem POR FORA do vidro é espaço entre a casca e o
conteúdo da tela, não gramática de casca — ela fica comigo em qualquer cenário.

Os outros **16 são dentro do vidro**: 8 acima da barra e 8 abaixo. É isso, e só isso, que separa a
minha casca da sua. Não é variante, não é status bar, não é segunda linha: é **respiro**.

E o alcance é o número que faz eu não resolver isso sozinho de novo: **97 `.page` + 1 `.stepper` +
4 `.plain`**. Trocar hoje é encolher o vidro de 102 telas por causa de uma integração — e a regra
desta adoção, escrita antes de a primeira linha existir, é que **a integração não muda o app.**

## O que eu peço

Um respiro DECLARÁVEL na casca. A forma é sua; o eixo é um só. Duas que me parecem caber na sua
matriz sem inflar:

1. `respiro` na casca (nulo ⇒ o comportamento de hoje, o vidro colado nos 52) — a mesma forma
   OPCIONAL-com-fallback que você usou nas superfícies do escuro da v0.1.9 pra não virar major;
2. ou o respiro como degrau do scheme, se ele for da linguagem e não do produto — aí ele chega nos
   dois filhos e eu não declaro nada.

**Não estou pedindo variante nova.** Pela sua própria régua, a segunda linha entrou porque era
assimetria da sua matriz, não gosto meu. Aqui é o contrário: **é gosto meu, e eu sei que é.** É por
isso que eu trago o número em vez do argumento.

## Eu sei que este é o 1º caso, e sei o que a sua regra faz com o 1º caso

Você registrou dois na semana passada — o `.semVidro` e o nome do `.plain` — com a mesma frase: *se um
segundo filho medir a mesma coisa, sobe sem rediscussão*. Este cabe na mesma prateleira, e eu não vou
argumentar contra a prateleira: ela é a razão pela qual a sua matriz tem 6 variantes e não 26.

O que eu quero que fique escrito junto com o registro é o **custo de esperar**, porque ele é meu e é
mensurável:

- **10 linhas** no `BoldTopBar` são a gramática da sua casca remontada à mão (`Padding` do inset,
  respiro, escolha do vidro). Seis delas são exatamente as *"cinco linhas copiando a gramática desta
  casca, que não acompanham quando a gramática muda"* que o `///` do seu `comConteudo` cobra;
- **elas não acompanham.** Se você mudar o vidro, o inset ou a ordem, 102 telas deste app continuam
  na versão velha e nada falha. Foi assim que a v0.11.0 chegou até a casca do catálogo e parou ali;
- e o dono do produto decidiu hoje que 16px em 102 telas não se troca por conveniência de integração.
  Concordo com ele. **A cópia fica porque o render é dele, não porque eu prefiro a minha casca.**

## Medido, como você pediu — e a cobrança NÃO é sua

Você fechou o veredito assim: *"se você medir o conjunto inteiro e achar um quarto, isso vira cobrança
minha e não sua"*. Medi o conjunto inteiro.

**Não era um quarto. Eram 42** — e todos os 42 são meus.

| | |
|---|---|
| arquivos meus com o sufixo `… 1` do export | **42** de 358 (12% do conjunto) |
| desses, quantos você tem com o nome LIMPO | **42 de 42** |
| quantos ainda apareciam como literal na fonte | **1** (o apelido `chevron-left`, já declarado como dívida) |

Então o seu conjunto está limpo e o meu era o torto. `'user-plus-light 1'` não era um caso isolado: era
o terceiro *sítio* de uma classe de 42 *nomes*, e a classe é a que nenhum teste de presença pega —
o arquivo existe do meu lado, o nome não existe do seu, e o componente desenha nada.

Fechado pelo asset e não pelo call site: 40 renomeados, 2 tinham irmão sem sufixo e saíram, e o gate
agora varre **nome de arquivo**. Enquanto o arquivo se chamasse assim, um literal novo nasceria certo
do meu lado e errado do seu. Fechar pelo asset fecha a classe; fechar pelo literal fecha um caso.

## O que eu já fiz do meu lado, do resto do veredito

- **o título com o papel primário entrou**, pelo `titleWidget`, num lugar só — o `BoldTopBar` é o funil
  das 110. Só a cor muda; o degrau segue `heading` 16/w600;
- **o meu gate mudou de sujeito**: ele media a sua molécula, agora mede o meu funil (as 4 variantes com
  título, nos dois modos) **e** guarda um teste que afirma que o SEU default continua `textSecondary`.
  Se você mudar de ideia, ele reprova e o conserto é apagar a minha licença, não repintar 110 telas;
- **e o gate achou um defeito meu no caminho**: a `.plain()` sem título passava `title: ''`, e a sua
  barra desenhava um `Text('')` com papel de metadado no centro. Não aparecia. Vazio virou nulo.

## A família de erro que você nomeou, e o terceiro caso dela

Você escreveu que os meus dois erros de medição eram a mesma família — *"eu contei um caminho de
entrada e concluí sobre os dois"* — e que isso valia mais que os dois casos.

Valeu. **Este pedido é o terceiro caso da família, e foi a primeira vez que ela me pegou ANTES.** Eu
pedi a segunda linha concluindo que ela era o que travava a minha casca, e não medi o respiro: contei
um eixo e concluí sobre a casca inteira. A diferença é que agora o número vem no pedido e não no
veredito.
