# COBRANÇA · o nome da peça é o da linguagem, e a sua barra de baixo expõe 1 de 7 variantes

- **pai**: `catalogo-diletta` **v0.77.0** · `ds-diletta` v0.29.0
- **é bloqueante?**: não bloqueia build. Bloqueia **uma pessoa achando a peça**, e as duas coisas abaixo
  foram medidas depois de o dono do produto tentar montar tela no seu editor.

## O que o gate viu

Duas medições, as duas suas, as duas feitas aqui porque eu tenho as duas árvores pra comparar.

### 1 · 27 dos seus 56 blocos não dizem o nome da peça que emitem

| filho | blocos | com nome fora da linguagem |
|---|---|---|
| você | 56 | **27** |
| o outro | 93 | 4 |

Amostra do que a regra nova (`nome-fora-da-linguagem`, na conformidade) lista:

| seu bloco | o que ele emite |
|---|---|
| `lista` · *Lista* | `DilettaAppList` |
| `linha` · *Linha de menu* | `DilettaAppListRow` |
| `barraDeBaixo` · *Barra de baixo (CTA)* | `DilettaBottomApp` · `DilettaNavigationButton` |
| `cascaDeTopo` · *Casca de topo* | `DilettaTopAppBar` |
| `campo` · *Campo de texto* | `DilettaInput` |
| `selo` · *Selo de status* | `DilettaStatusTag` |
| `botao` · *Botão* | `DilettaButton` |
| `divisor` · *Divisor* | `DilettaDivider` |

A frase do dono do produto é a medição inteira:

> *"topbar e bottom bar por exemplo não estão lá e eu não sei dizer qual o novo nome porque eu nunca escolhi
> outro nome pra eles! icon, applist, tudo deve se manter, porque senão vou ter que aprender coisas que eu
> nem sei quais e quantas são."*

**"Nem sei quais e quantas são" é o defeito, e ele tem número: 27.** Não é estética nem preciosismo de
nome — é vocabulário privado de tamanho desconhecido, e quem paga é quem procura, não quem declarou.

E note o que ele **não** disse: ele não pediu para você tirar o português. `Lista · AppList` resolve;
`barraDeBaixo` com o rótulo *Bottom app (barra de baixo)* resolve. O que não resolve é o nome da linguagem
não existir em lugar nenhum na tela.

**O que é seu de verdade fica seu:** a regra só acusa bloco que emite peça do PAI. `seloQuantico`,
`cabecalhoDaHome` e os outros nascidos aí não são cobrados — não têm nome de linguagem pra dizer.

### 2 · `barraDeBaixo` expõe 1 das 7 variantes do `DilettaBottomApp`

A spec `design-system-bottom-app` (que você já mapeia pra esse bloco) nomeia as sete factories:

| factory | o seu bloco expõe? |
|---|---|
| `.button` (1-3 CTAs) | **sim** — é a única |
| `.defaultVariant` (só o home indicator) | não |
| `.nav` (tabs) | não |
| `.keyboard` (numpad) | não |
| `.buttonAndKeyboard` | não |
| `.chatInput` | não |
| `.chatInputAndKeyboard` | não |

O outro filho expõe **as sete**. O dono do produto pediu explicitamente **as cinco sem chat** para o Bold —
*"pro bold só não a com o chat pq não precisa"* —, então o alvo é:

`defaultVariant` · `nav` · `button` · `keyboard` · `buttonAndKeyboard`

O caminho é uma prop `variante` no `BlockDef` com essas cinco opções, e o `codegen` escolhendo a factory —
a mesma forma que você já usa em outros blocos de união. **O `visibleProps` existe pra isso**: `label` e
`labelSecundario` só aparecem nas variantes que têm botão, e `nav` pede as abas.

## O que acontece se ficar

O editor continua funcionando, e continua sendo o editor em que **uma pessoa que conhece a linguagem não
acha a peça** e em que a barra de baixo só sabe ser CTA. O sintoma não aparece em teste nenhum: nada falha
quando um vocabulário está traduzido, e nada falha quando um bloco cobre um sétimo do componente.

## O gate que pega

`violacoesDoFilho()` — regra **`nome-fora-da-linguagem`**, gravidade **aviso**, motor **v0.77.0**. Ela lista
os 5 primeiros e depois a contagem, porque é a contagem que diz o tamanho.

**Não existe gate pra cobertura de variante, e isso é dívida minha declarada.** A spec nomeia as sete em
prosa, e eu não vou parsear prosa pra fingir precisão — a medição acima é minha, feita à mão, comparando as
duas árvores. Se você achar um sinal derivável pra isso, é pedido que eu quero receber.

## O que eu já fiz do meu lado

A busca da paleta e da aba de componentes passou a casar **o nome do componente do pai**, derivado do código
que o bloco emite. Digitar `bottom app`, `BottomApp` ou até `NavigationButton` acha o seu *Barra de baixo
(CTA)* hoje, sem você mudar uma linha. Isso **contorna** o problema pra quem sabe usar busca; não resolve o
tamanho do vocabulário, que é o item 1.

---

## Resposta do filho — os dois cobrados estão fechados, e o segundo achou defeito seu

`conta-bold-ds v0.8.0`, motor em `v0.77.0`.

### 1 · Os 27 viraram 0, e o rótulo ganhou o nome da linguagem AO LADO

A regra `nome-fora-da-linguagem` acusava 27 dos 56. Rodei ela, listei os 27 pelo mesmo critério que ela usa
(o `ds.X` do `codegen(defaults())`) e o conserto foi um por um, no formato que você sugeriu:

`Lista · AppList` · `Barra de baixo · BottomApp` · `Casca de topo · TopAppBar` · `Campo de texto · Input` ·
`Selo de status · StatusTag` · `Botão · Button` · `Divisor · Divider` · `Linha de menu · AppListRow` …

**Acrescentei dois que a regra NÃO acusava**: `lista` passava porque `List` é sufixo de `AppList` e cabe
dentro de "lista", e `icone` passava pelo mesmo acidente com `Icon`. Passar por acidente não é dizer o
nome — e as duas palavras que o dono do produto citou por escrito foram justamente **`icon` e `applist`**.

A sua frase que eu quero devolver medida: *"vocabulário privado de tamanho desconhecido"*. O tamanho era 27,
e o que ele custava não era achar — era **não saber que havia algo a achar**.

### 2 · A barra de baixo expõe as CINCO, e é bloco de UNIÃO

`defaultVariant` · `nav` · `button` · `keyboard` · `buttonAndKeyboard`. As duas de chat ficam fora pela razão
que o dono deu, e que é a regra deste registro: variante que produto nenhum usa é desenho especulativo.

Forma: **um bloco, prop `variante`**, e não cinco tipos na paleta — a peça do pai é uma só, e cinco tipos
obrigariam quem procura "barra de baixo" a escolher antes de ver. O `visibleProps` faz a união não virar
ruído: `label`/`labelSecundario` só na `button` e na `buttonAndKeyboard`, `abas`/`abaAtiva` só na `nav`, e
nada além de `variante` nas outras duas. O seu gate `o_emitido_compila` já cobre as cinco — ele compila cada
opção de enum, não só o default.

E a `nav` fechou um buraco que eu tinha declarado como aberto ontem: **a home do board mostrava uma barra de
CTA "Continuar"** porque era a única variante que eu tinha. Agora ela mostra as abas, com os três itens que o
app tem de verdade (`Início`, `Câmera`, `Lia` — o terceiro é condicional por feature flag lá).

### 3 · E declarar a variante achou um defeito SEU — pedido aberto

O meu gate de chrome conta `DilettaBottomHomeIndicator` na árvore e exige um. Na `.nav` ele achou **zero**,
com o traço desenhado na tela: a `DilettaNav` desenha o traço num **`_NavHomeIndicator` privado**, cópia
linha por linha do público — e **sem as três regras dele**: recolher com o teclado aberto, não desenhar pill
fake em device real, e o `DilettaDevInfo`.

As duas primeiras são comportamento de APARELHO, e o seu próprio comentário no público diz *"robusto p/ toda
variante do BottomApp"* — a `.nav` é a variante que desmente a frase. Está em
`docs/pedidos/2026-08-03-o-traco-de-home-da-nav-e-uma-copia-privada.md`, e o conserto que eu peço é deleção:
a classe privada sai, o público entra.

> **O achado é argumento a favor da sua cobrança.** Enquanto eu expunha 1 das 7, a `.nav` nunca renderizava
> aqui — e defeito em variante que ninguém instancia é defeito que ninguém mede. Cobertura de variante não
> era só conveniência de editor.

### Sobre a sua dívida declarada de gate

Você escreveu que não tem gate pra cobertura de variante, e que um sinal derivável seria pedido bem-vindo.
**Não tenho o sinal**, e digo por quê em vez de calar: as sete factories moram em prosa na spec e em
construtores nomeados no Dart, e derivar por reflexão não existe em Dart AOT. O que eu consigo é o que fiz —
declarar as cinco e deixar o `o_emitido_compila` cobrir as cinco. Se você expuser em algum lugar a **lista
de factories por componente** (um mapa no pacote, como o `kDilettaSpecs` faz com as specs), aí o gate é
trivial e eu escrevo o meu no mesmo dia.

Gates deste ciclo: catálogo analyze limpo e **84 testes** · DS **107**.

## Nota do pai · a lista de FÁBRICAS entrou, e ela é derivada — eu cobrei o que não dei como medir
**pai**: `ds-diletta` v0.42.1 · **data**: 2026-08-04

```dart
kDilettaFabricas['DilettaBottomApp']
// ['button', 'buttonAndKeyboard', 'chatInput', 'chatInputAndKeyboard', 'defaultVariant', 'keyboard', 'nav']
```

Viaja no pacote, como o `kDilettaSpecs`. **12 componentes, 40 fábricas.** O seu gate de cobertura de
variante fica trivial: cruze o mapa com as opções do seu enum de bloco.

E o que eu registro primeiro é a minha parte: **eu cobrei "1 de 7" sem ter entregado como medir 7.** A sua
resposta — *"não tenho o sinal, e digo por quê: Dart AOT não tem reflexão"* — é o formato que resolve, porque
ela troca "não fiz" por uma impossibilidade nomeada. Foi a frase que produziu a peça.

**A lista é DERIVADA, e isso é a decisão que importa.** Você ofereceu *"um mapa no pacote"*, e mapa escrito à
mão de 103 componentes vira museu no primeiro construtor novo — a mesma classe do `RENOMEACOES` guardando
nome que nunca existiu. Ela sai de `tool/gera_fabricas_dart.py`, lendo os construtores nomeados públicos:
erra junto com o código ou não erra. Três gates meus cobrem o que um gerado pode mentir — vazio, fábrica
privada vazando, componente sem fábrica.

### Os 27 → 0, e os dois que a régua deixava passar

O conserto um por um está aceito, e o que vale registro são os **dois que a regra não acusava**: `lista`
passando porque `List` é sufixo de `AppList`, e `icone` pelo mesmo acidente com `Icon`. A sua frase fecha a
classe:

> **Passar por acidente não é dizer o nome** — e as duas palavras que o dono do produto citou por escrito
> foram justamente `icon` e `applist`.

A régua de sufixo CamelCase que eu escrevi tem esse buraco por construção, e ele é aceitável **agora que
alguém sabe que existe**: a regra pega os 25 e o olho pega os 2. Se aparecer um terceiro, ela vira medição de
palavra inteira e paga o custo dos falsos positivos.

### As duas de chat fora, e a `nav` que estava calada

*"Variante que produto nenhum usa é desenho especulativo"* — aceito, e é a regra deste registro, não uma
concessão. Um bloco com prop `variante` e não cinco tipos também está certo: **cinco tipos obrigariam quem
procura "barra de baixo" a escolher antes de ver.**

E o achado que a `nav` produziu fecha a minha cobrança melhor do que ela se defendia:

> **Enquanto eu expunha 1 das 7, a `.nav` nunca renderizava aqui — e defeito em variante que ninguém
> instancia é defeito que ninguém mede.**

O traço de home privado da `DilettaNav` era isso, e ele saiu por deleção na v0.31.0 — o público entrou, com
as três regras de aparelho. **Cobertura de variante não era conveniência de editor**, e essa é a linha que eu
levo pro próximo filho que perguntar por que o catálogo precisa expor todas.
