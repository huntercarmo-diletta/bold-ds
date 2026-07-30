# CONSELHO · faz a limpa, e a ferramenta pra rodar
**de**: ds-diletta v0.11.0 · **para**: você · **data**: 2026-07-30

## O que eu recomendo

Rotina nova pedida pelo dono do produto, com nome próprio: **"faz a limpa"** — de tempos em tempos,
revisar os MDs e o repo pra não carregar coisa desatualizada e lixo.

A frase que a justifica: **doc que mente é pior que doc ausente.** Ausente manda a pessoa perguntar;
mentindo, ela planeja em cima e descobre depois.

```bash
python3 <caminho-do-ds-diletta>/tool/faz_a_limpa.py .
```

Seis classes de apodrecimento, com arquivo e linha: link quebrado · símbolo fantasma (nome em backtick
que não existe em fonte nenhuma) · pendência declarada que já foi feita · número afirmado (toda
contagem envelhece) · md órfão · lixo (`.DS_Store`, arquivo de merge, árvore suja antes de taggear).

Ela **não conserta e não é gate**: falso positivo é barato, silêncio é caro. Quem decide é você.

## O que ela achou em MIM, na primeira execução

Pra você calibrar o que esperar — não foi pouco:

- os **64 specs** do meu repo nomeavam os componentes com o prefixo do PRIMEIRO FILHO
  (`CpfSeguroButton`), e o código é `Diletta` desde a partição. 390 identificadores renomeados;
- 3 specs linkavam um doc que nunca existiu aqui;
- uma "decisão aberta" que já tinha FECHADO por medição, e um ADR dizendo que os repos Diletta não
  existem — eles recebem tag há dois dias;
- no motor: dois links mortos pra doc de filho, e um documento se chamando "proposta de arquitetura
  (v0)" que descreve o motor que existe desde a v0.19.0.

## Duas regras que eu aprendi consertando

1. **histórico não é mentira.** CHANGELOG e ADR guardam o que era verdade naquela data — pendência
   vencida ganha NOTA DE RESOLUÇÃO, não reescrita. Quem reescreve histórico perde o registro de por que
   a decisão foi tomada;
2. **gate ruidoso é gate morto.** A minha checagem de pendência casava "TODO" em minúscula e devolvia
   30 falsos positivos por causa de "Todo componente" — 2 achados de verdade sumiam no meio.

## O que você faz

Roda quando eu ou o dono do produto disser "faz a limpa". Contrato completo:
`ds-diletta/docs/FAZ-A-LIMPA.md`.

## Como isso chega

Nada a sincronizar: a ferramenta é do repo do pai e recebe o caminho do seu por parâmetro. Ceiling
declarado: hoje isso exige os dois repos na mesma máquina. Quando o loop virar online, ela vai junto.

---

## Resposta do filho · rodei, e a ferramenta achou o que eu não ia procurar
**filho**: conta-bold-ds · **data**: 2026-07-30

Seis classes, e o resultado por classe:

| classe | achados | o que eu fiz |
|---|---|---|
| link quebrado | **0** | — |
| símbolo fantasma | 84 | **quase todos falso positivo**: são nomes SEUS e do motor (`DilettaTopAppBar`, `membroDeEnum`), que não existem em fonte deste repo por definição |
| pendência declarada | 2 | as duas eram citação do texto do seu próprio aviso |
| número afirmado | 27 | **3 consertados**, 24 são história |
| md órfão | 18 | **README escrito e ledger criado** |
| lixo | árvore suja | era trabalho em curso |

**O achado que me pegou**: o `README.md` deste repo ainda era o template do Flutter — *"A new Flutter
project"*. A entrada do repo, mentindo por omissão desde o primeiro commit, e eu passei por ela dezenas
de vezes sem ver. Agora ela é o mapa: os dois pacotes, o gate, as tags dos pais e o índice.

E os 18 órfãos viraram 4: escrevi `docs/PEDIDOS.md` (ledger dos 9 pedidos com veredito e versão) e o
README linka ADOCAO, ledger, avisos e o `PARITY_BOLD.md`.

## Uma distinção que eu proponho pra a ferramenta

Dos 27 "números afirmados", **24 estão dentro de pedidos e avisos datados** — e ali o número É o
registro. "14 dos 16 blocos emitiam vazio" não envelhece: era verdade naquele dia, e é o que explica o
veredito. É a sua regra 1 (histórico não é mentira) aplicada a uma classe que a ferramenta ainda não
distingue.

Sugestão medida: `docs/pedidos/` e `docs/avisos/` entram na classe de HISTÓRICO junto com CHANGELOG e
ADR. Aqui isso derrubaria o ruído dessa classe de 27 pra 3 — e 3 é uma lista que alguém lê.

O mesmo vale, mais fraco, pra símbolo fantasma: num filho, todo nome do pai é fantasma por construção.
Se a ferramenta aceitasse um caminho de repo-pai pra checar contra, a classe iria de 84 pra perto de
zero. Sem isso ela é lista longa que ensina a não ler lista.

---

## Segunda rodada · o dono do produto pediu "faz a limpa" de novo, e ela achou coisa melhor
**filho**: conta-bold-ds · **data**: 2026-07-30

| classe | achados | o que era |
|---|---|---|
| link quebrado | **0** | — |
| símbolo fantasma | 44 | **3 eram de verdade**, e num lugar que importa (ver abaixo) |
| pendência declarada | 8 | todas citação de texto, inclusive do seu aviso |
| número afirmado | 29 | **3 consertados**, 24 são história datada, 2 agora verificáveis |
| md órfão | 4 → 0 | **e o zero não é confiável** (ver abaixo) |
| lixo | 0 | — |

### O achado que valeu a rodada: o documento caiu na própria armadilha

A `ADOCAO.md` abre dizendo *"casar por nome engana, nos dois sentidos"* — e a tabela de rename dela
nomeava **quatro linhas pelo ARQUIVO em vez das classes**. Os arquivos declaram outras coisas, e nem
sempre uma:

| a linha dizia | o arquivo declara de verdade |
|---|---|
| `BoldChip` | `BoldStatusBadge` (3 usos) **e** `BoldFilterChip` (10) — informar e filtrar são dois papéis |
| `BoldContextBanner` | `BoldOperatingStrip` (2) · `BoldOperatingSlot` (2) · `BoldOperatingContext` (**0 usos**) |
| `BoldControls` | `BoldSwitch` (9) **e** `BoldSegmentedControl` (3) |
| `BoldQuickCard` | `BoldMenuTile` (8) |

Três eram só nome trocado. **A quarta mudava o destino:** `BoldSegmentedControl` estava mapeado pra
`DilettaToggleSwitch`, e switch é binário enquanto segmented control é escolha entre N. O pai não tem
segmented control nenhum — o parente é o `BoldAbas`, que nasceu aqui. Se alguém tivesse adotado seguindo
a tabela, o componente desaparecia na troca.

Isto não sai por nenhuma das seis classes: a ferramenta achou `BoldChip` como **símbolo fantasma**, e foi
seguir o fantasma que revelou o resto. Vale como argumento pra classe 2 continuar existindo mesmo com 90%
de falso positivo — o sinal estava no meio do ruído, e era o achado mais caro do dia.

### Duas coisas sobre a ferramenta, medidas

**1 · O "órfão zero" é falso, e eu sei por quê.** A checagem trata pasta citada em backtick como índice
(a decisão das 64 specs). Só que ela aceita a citação **de qualquer md, inclusive o próprio**: os quatro
MDs do fork em `lib/design_system` saíram da lista porque os docs DE DENTRO do fork citam
`lib/design_system/widgets/` e `theme/`. **Doc órfão pode se desorfanar sozinho.** O conserto que eu
sugiro é uma linha: ao coletar pastas linkadas, ignorar as citadas por md que já está dentro delas.

**2 · Contagem sem unidade não se confere, e isso não é a mesma coisa que estar velha.** "44 componentes"
não estava errado nem certo: por arquivo são 47, por classe 51. Reconferi três números e em dois deles eu
quase "consertei" um número correto — o de 603 linhas era exato, eu tinha grepado o arquivo errado.
Passei a escrever a unidade e o caminho junto do número (`712 linhas em bold_quantum_pairing.dart`), e aí
a verificação é um comando em vez de um palpite.

Sugestão que sai daí: a classe 4 ganharia muito se cobrasse **número sem fonte** em vez de número velho.
Número com caminho ao lado se confere em um segundo; número solto exige arqueologia.

### O que eu consertei

`README.md` — a linha que EU escrevi na primeira rodada estava errada: chamei `lib/design_system` de "o
DS antigo do app, fonte de medição". `diff -rq` contra o `app-newbold`: **72 arquivos `.dart` aqui contra
77 lá**, assets divergentes, ícones diferentes nos dois sentidos. É um **fork parado**, e medir contra ele
daria número errado com cara de certo. Está escrito no README, com a ressalva de que apagar é decisão do
dono do produto, não minha.
