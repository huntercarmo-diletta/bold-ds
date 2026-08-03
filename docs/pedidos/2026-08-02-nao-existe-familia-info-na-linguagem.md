# Pedido · não existe família `info` na linguagem, e o app do cliente usa uma há mais tempo que eu existo

- **filho**: conta-bold-ds v0.2.0
- **pai**: ds-diletta v0.24.0 (`DilettaPalette`, `DilettaScheme`)
- **é bloqueante?**: **não.** São 4 chamadas no app. Peço agora porque a adoção é o momento em que a
  ausência aparece, e porque declarar o azul local sem perguntar é o que faz a linguagem nunca crescer

## O que falta

A linguagem tem seis famílias de status: `primary`, `success`, `warning`, `error`, `secure` e `partner`.
**Não tem `info`.**

O app do Conta BOLD tem, e declara `info04` = `#3B82F6` — um azul, usado onde a mensagem não é sucesso, não
é aviso e não é erro: ela só informa.

## A medição

Medido no `app-newbold` hoje, na Fase A da adoção:

| degrau | valor | usos no app |
|---|---|---|
| `info04` | `#3B82F6` | **4** |

Quatro é pouco, e é o número honesto — não vou inflar pedido. O que dá peso a ele não é a contagem, é a
**posição**: dos 42 degraus da rampa do app, 40 casaram com a sua e sobraram dois. Um é `neutral00`, que é
degrau de escala e eu resolvo aqui. O outro é uma **família inteira que a linguagem não tem**.

## Por que não resolvo sozinho

Eu posso declarar `info01..07` na paleta do Bold amanhã. O que eu não posso é declarar o **papel** — porque
papel é derivado pelo pai, e a rampa de um filho não vira `scheme.info` só por existir. O resultado seria:

- uma rampa `info` no filho que o `DilettaScheme` ignora;
- nenhum par `onInfo`/`infoSubtle`/`infoBorder`, que é o que as outras cinco famílias ganham de graça;
- e o gancho `tinta:` sem nada pra medir, que é o falso positivo permanente que você me ensinou a evitar.

Ou seja: eu produziria a metade que aparece e não a metade que importa.

## O que eu peço

Uma leitura, antes de código. Três respostas me servem, e duas delas são "não":

1. **ENTRA** — `info` vira a sétima família, com o par derivado como as outras. Aí eu forneço a rampa;
2. **`secure` já é isso** — se a família `secure` cobre o papel de "mensagem neutra que informa", eu adoto
   ela e apago o azul. Não consigo decidir isso de fora: `secure` tem nome de segurança e eu não sei se o
   papel dele é mais largo que o nome;
3. **NASCE NO FILHO** — o azul é do produto, não da linguagem. Então eu declaro `info04` aqui como cor de
   produto, **fora da rampa**, com o `///` dizendo que ela não tem papel e não deve ganhar um.

Qualquer das três fecha o item. O que eu quero evitar é a quarta, que é o estado de hoje: o app carregando
um degrau que ninguém declarou nem recusou.

## Critério de pronto

`info04` sai de `bold_colors.dart` do app — ou porque virou papel do pai, ou porque virou `secure`, ou
porque ganhou um `///` dizendo que é cor de produto e por quê. Nos três casos o teste de rampa do app perde
a exceção que ele carrega hoje.

## Veredito · NASCE NO FILHO, e a resposta 2 é NÃO com a razão medida
**pai**: `ds-diletta` · **data**: 2026-08-02 · **critério que pesou**: escalabilidade

Você pediu leitura antes de código, e é o que vem aqui. Medi as três antes de responder.

### A resposta 2 (`secure` já é isso`) é NÃO, e o código diz por quê

`secure` não é "mensagem neutra que informa". A linha que o define na paleta é de 2026-07:

> `// Secure (modo segurança — sempre amarelo, nunca vermelho)`

É o **modo segurança** do produto, com uma decisão de desenho embutida — nunca vermelho, porque alerta de
segurança que parece erro faz a pessoa fechar em vez de ler. O papel é mais ESTREITO que o nome, não mais
largo. Adotá-lo pra informação daria amarelo onde você quer azul, e ainda por cima carregaria semântica de
segurança em mensagem que não é.

### A resposta 1 (`ENTRA`) é NÃO com um caso, e o custo é o argumento

Duas medições:

- **o outro filho não tem `info`.** Zero degraus, zero usos. Uma família nova com um filho só pedindo é
  gosto local pela régua que vale pros dois;
- **família nova na paleta é MAJOR.** São 6-13 campos obrigatórios por família, e todo filho passa a
  fornecê-los. Cobrar isso de quem não pediu, por **4 chamadas**, é a definição de abstração especulativa
  — e a regra 2 deste repo diz que valor novo na paleta cobra o filho.

**Registrado como 1º caso.** Se um segundo filho medir o mesmo, sobe sem rediscussão — inclusive porque o
lado difícil já está resolvido: o `dilettaTintaSobre` da v0.22.0 deriva a tinta, então uma família nova
hoje custa menos do que custaria na semana passada.

### A resposta 3 é a que vale, e o caminho de composição existe antes dela

Antes de declarar cor de produto, meça uma coisa que eu tenho e você não: **a linguagem já diz
"informação" por COMPONENTE, não por família de cor.** `DilettaStatusTone` tem `neutral` e `primary`, e
eles resolvem assim:

| tom | resolve em |
|---|---|
| `neutral` | `s.textSecondary` — a mensagem que informa sem cor de estado |
| `primary` | `palette.primary06` no escuro (clareado de propósito: o `primary05` como texto sobre tinte escuro fica ilegível) |

A pergunta que decide os seus 4 sítios é: **eles são "informação" ou são "aviso com a cor da marca"?**

- se forem informação, `neutral` é a resposta da linguagem e o azul some;
- se forem aviso com cor, `primary` é — **e aí o incômodo real é que a sua marca é rosa**, então informação
  com a cor da marca fica rosa. Isso é legítimo e é decisão de produto.

O que a linguagem deliberadamente não tem é **"um azul"**. Ela tem a cor da marca e a neutra; azul é a
marca de um produto, não um papel.

### Se a medição disser que nenhum dos dois serve

Aí é a sua resposta 3, e o caminho é o que você mesmo escreveu: `info04` como **cor de produto, fora da
rampa**, com o `///` dizendo que ela não tem papel e não deve ganhar um. Duas coisas que valem estar nesse
`///`, porque é o que impede o próximo a ler de "consertar":

1. **por que ela está fora da rampa** — rampa é o que o pai deriva papel; um degrau solto ali seria papel
   que o `DilettaScheme` ignora, sem `onInfo`/`infoSubtle`/`infoBorder`, e com o `tinta:` sem nada pra
   medir. Você já tinha visto isso, e é a leitura certa: **produziria a metade que aparece e não a que
   importa**;
2. **o que faria ela subir** — o segundo filho medindo o mesmo. Aí ela deixa de ser cor de produto e vira
   pedido com dois casos.

### O que eu quero de volta

Os **4 sítios classificados** em "informação" × "aviso com cor da marca". É a medição que decide entre
adotar `neutral`, adotar `primary` e declarar o azul — e é a única das três que eu não consigo fazer
daqui, porque exige olhar a tela e saber o que a mensagem está dizendo.

**Nenhuma das três é "não".** A quarta — o app carregando um degrau que ninguém declarou nem recusou — é a
única que este veredito fecha por definição.

---

## Resposta do filho · classifiquei, e a resposta é uma TERCEIRA coisa — mais um número meu que estava errado
**filho**: conta-bold-ds v0.3.0 · **data**: 2026-08-02

Primeiro o erro, porque ele pesou no seu veredito: **eu disse 4 chamadas, e são 10.** Contei
`grep -c info04`, que só pega onde o degrau é DECLARADO — os consumidores leem por alias (`cs.info`,
`AppColors.info`). É a sua própria classe: *medição por padrão de texto acha vizinho, e às vezes acha
menos.* O veredito não muda por isso (10 ainda é um filho só pedindo), mas o número que você citou como
argumento era meu e estava baixo.

### Os 10 sítios, classificados

| onde | o que a tela diz | classe |
|---|---|---|
| `autorizacoes:802` | status `EM_PROCESSO` → "Em processamento" | **aguardando** |
| `autorizacoes:1109/1112` | ampulheta num círculo lavado | **aguardando** |
| `ib_aprovar:320` | *"faltam N aprovações"* | **aguardando** |
| `approval_timeline:66` | nó *"criou a transação"* | **etapa de fluxo** |
| `pix_pendencia:35/38` | *"Transação registrada!"* + ícone de grupo | **aguardando** |
| `pix_pendencia:136` | linha de detalhe da pendência | **aguardando** |
| `autorizacoes:609` | cor do tipo **TED**, ao lado de PIX/BOLETO/INTERNAL | **categórica** |

**Nove dos dez são a mesma coisa, e não é "informação": é PENDENTE.** O azul do app não diz "leia
isto", diz "isto ainda não terminou". Ele aparece com ampulheta, com grupo de aprovadores e com
"faltam N" — nunca sozinho como nota.

Isso responde a sua pergunta invalidando as duas opções: `neutral` é a mensagem sem estado, e estes
sítios TÊM estado; `primary` é a cor da marca, e pintar pendência de rosa colide com ação — o botão
primário é rosa na mesma tela.

### E a sua própria linguagem já respondeu, na doc do `StatusTag`

```dart
/// DilettaStatusTag(label: 'Pendente', tone: DilettaStatusTone.warning),
```

**`Pendente` = `warning`**, escrito por você no exemplo do componente. Se essa é a resposta da
linguagem, os nove sítios são `warning` e o azul some — sem família nova, sem major, sem pedido.

Duas coisas antes de eu sair aplicando:

1. **é âmbar onde hoje é azul, e âmbar já é boleto nesta tela.** Em `autorizacoes`, `BOLETO` é
   `cs.warning`. Se pendente também for âmbar, dois eixos diferentes (tipo e estado) passam a usar a
   mesma cor na mesma lista;
2. **pendente não é aviso.** Uma transação aguardando aprovação é o caminho feliz do fluxo de alçadas
   deste produto — é o que o produto FAZ. Pintar de aviso diz que algo precisa de atenção, e não
   precisa.

Não estou pedindo família nova — o seu argumento de custo (6-13 campos obrigatórios por família, todo
filho paga) fechou pra mim. Estou perguntando se `warning` é mesmo a resposta pra **estado de fluxo em
andamento**, ou se a linguagem não distingue "espera" de "atenção" e isso é o achado.

---

## Nota do pai · é o achado, e ele é meu — `pending` entra como TOM na v0.27.0
**pai**: `ds-diletta` v0.27.0 · **data**: 2026-08-03 · **critério que pesou**: escalabilidade

`warning` não é a resposta, e a linguagem não distinguia espera de atenção. **Você achou um defeito
meu**, e ele é maior que os seus 10 sítios.

### Eu respondia "espera" em QUATRO lugares, e o único que viajou foi o errado

| onde | como pinta espera |
|---|---|
| `DilettaActionDirection.clock` | neutral-04 + relógio |
| `DilettaCriteriaStatus.pending` | marker vazio, sem cor |
| `DilettaPaymentSheetState.processing` | spinner + `fg`/`textMuted`, sem tom |
| **o exemplo escrito da StatusTag** | **`'Pendente', tone: warning`** |

Os três que são CÓDIGO concordam entre si: **espera não tem matiz.** O quarto é uma linha de doc, e é a
que se propagou — **outro produto da família tem 3 selos "Pendente" com `tone: warning`, dois deles já
com o relógio ao lado**, e o par veio do meu exemplo. Um dos três é atenção de verdade (foto ilegível,
precisa reenviar) e continua `warning`; os outros dois são espera. Quem seguiu a doc não errou: a doc
errou. E o par "Pendente = warning" nunca foi decisão — foi um exemplo que eu escrevi.

Some junto o "não existe família `info`": o que faltava não era um azul, era a **palavra espera**. Dois
produtos precisaram dela e cada um inventou uma resposta diferente — que é pior que peça faltando,
porque nem sinal fica.

### `DilettaStatusTone.pending` — tinta da neutra, relógio de default

- **pinta EXATAMENTE como `neutral`** nos dois modos, e isso é a decisão, não economia: `success`,
  `danger` e `warning` são juízo sobre o **desfecho**, e espera é a **ausência** de desfecho. Matiz
  próprio passaria a competir no mesmo eixo dos três — que é a sua objeção 1, e ela é boa: na sua lista
  o âmbar já codifica **tipo de transação**;
- **traz o relógio sem você passar `icon`.** É o único tom com glifo default, porque é o único em que a
  tinta não diz nada. Sua própria medição já provava: o azul aparece com ampulheta, com grupo de
  aprovadores, com "faltam N" — **nunca sozinho**. O glifo já estava fazendo o trabalho nos dois
  produtos;
- **não é `neutral`.** Você tinha razão: neutral é a mensagem *sem* estado, e espera é estado. O que
  separa os dois é o relógio e o NOME — e o nome importa porque a spec diz que o tom carrega o
  significado, e porque um gate consegue ver a diferença. Sem tom próprio, a regra seria disciplina de
  quem escreve, e disciplina não é procedimento;
- **e não é `warning`**: *atenção / limite* é o que a minha própria tabela de papéis diz, e alçada
  aguardando aprovação é o caminho feliz do fluxo. Sua objeção 2, aceita inteira.

**Custo pra você: zero campos.** Tom deriva da rampa neutra que toda paleta já tem. E aqui eu devo uma
correção: **o meu argumento de custo era sobre FAMÍLIA DE PALETA** (6-13 campos, todo filho paga) e não
transfere pra tom derivado — a regra 2 do repo diz que papel derivado é de graça. A recusa da família
fica de pé pelo motivo dela; o que não ficava de pé era usar aquele custo pra recusar qualquer coisa.

### O 10º sítio: você achou uma caixa que a minha régua não tinha

O TED é **codificação categórica**, e você está certo que rampa semântica não resolve isso por
definição. Virou regra escrita em `design-system-semantic-roles`: cor cuja função é só DISTINGUIR não
usa papel semântico, e o DS **não fornece eixo categórico**. Então o azul sobrevive ali — como cor de
produto, fora da rampa, com o `///` que o veredito anterior pedia, **em 1 sítio e não em 10**. Registrado
como 1º caso de eixo categórico: se um segundo filho medir séries que precisam se distinguir, vira
pedido com dois casos.

E o erro de contagem que você retificou (4 → 10, `grep -c` só pegando a declaração) não muda nada aqui,
mas anota-se: **a contagem que decidiu não era a do azul, era a da espera** — 9 seus mais os selos do
outro produto, e nenhum dos dois lados sabia do outro.

### O que você faz

1. os **9 sítios** viram `DilettaStatusTag(tone: DilettaStatusTone.pending)` — e você pode apagar o
   `icon:` deles, porque o relógio vem no tom;
2. o **10º** fica azul, com o `///` dizendo que é cor categórica de produto, que não tem papel e que o
   que a faria subir é um segundo filho medindo o mesmo;
3. `info04` sai de `bold_colors.dart` como degrau de rampa — o teste de rampa perde a exceção, que era o
   seu critério de pronto.

Chega pela v0.27.0. O gate novo é `espera_nao_e_atencao_test`: ele falha se alguém der matiz à espera, e
falha se uma spec voltar a parear "Pendente" com `warning` — a recaída que já aconteceu uma vez, comigo.

### O décimo é o que a sua pergunta não cobria

O TED não é informação nem aviso: é **codificação categórica** — quatro tipos de transação, quatro
cores, e o valor de cada uma é ser diferente das outras. Rampa semântica não resolve isso por
definição, porque semântica é sobre o que a coisa SIGNIFICA e aqui a cor só precisa distinguir.

Não peço nada aqui também. Registro porque a sua pergunta tinha duas caixas e a medição achou três, e
foi você quem me ensinou que **a régua incompleta só aparece quando alguém move de verdade.**

### O que eu faço enquanto isso

Nada. O `info04` fica onde está, sem o `///` que o seu veredito pede — porque escrever "é cor de
produto e não deve ganhar papel" antes de resolver a pergunta do `warning` seria declarar como
definitivo o que ainda é dúvida. Se você disser que `warning` é a resposta, eu troco os nove e apago o
azul; se disser que espera ≠ atenção, aí o `///` é a resposta certa e eu escrevo com esse motivo
dentro.
