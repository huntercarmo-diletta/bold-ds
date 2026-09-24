# PEDIDO · o fundo padrão é decisão do cliente no Berço — e o filho nasce sem ele

> **Nota da rotina `atualizacoes-ds` (21/09): este arquivo está no lugar errado, e o conteúdo está
> certo.** `docs/PEDIDOS.md` abre dizendo *«o que este filho pediu aos pais»* — os destinatários são
> o `ds-diletta`, o `catalogo-diletta` e a dona do produto. Este aqui vai na direção contrária: quem
> pede é o **app**, e quem responde é **esta casa**. Pela doutrina da fila (*«o que mora em
> `packages/coreflow` é nosso e se faz aqui»*), **nada disto é pedido ao avô** — os quatro itens
> abaixo são todos nossos. Ele é carregado na `FILA-DOS-CHATS.md` como item, não como pedido, e o
> texto do app fica preservado aqui porque a medição dele é boa e a voz é de quem paga a conta.
>
> A rotina **remediu tudo em 21/09 contra `origin/main` (`v0.112.0`)**, três dias depois. Nada mudou
> de lado nenhum, e o andaime no app cresceu de um par de campos para **351 linhas**.

- **de**: app-newbold (quem veste o filho) · **para**: `packages/coreflow` (**esta casa**) e o Berço
- **consome**: coreflow v0.102.1 (vendorizado no app) · `norte_benk_coreflow` @ bold-ds v0.108.0 ·
  Berço de 17/09 · remedido contra bold-ds **v0.112.0** em 21/09
- **bloqueante?**: não pro Bold, que continua com a cidade dele. **Sim pro segundo filho aparecer com
  o fundo que o cliente escolheu**: na primeira vez que o Norte Benk rodou (18/09), ele abriu sobre a
  cidade do Conta BOLD.

## O caso

O Norte Benk rodou no app em 18/09 (flavor `nortebenkHml`). A tela de boas-vindas veio com o skyline
do Bold ao fundo. Não foi o DS: `app.dart` passava `BoldArteDeFundo.clara/escura` — dois JPEG que
moram em `assets/images/` do app — para o `CoreflowBackdropScope`, sem olhar qual produto estava
vestido. A arte é do app porque *"o DS não sabe onde a imagem mora"* (e o `///` do
`CoreflowBackdropScope` diz isso com essas palavras), e é isso que fez a cidade de um banco virar o
fundo do outro.

Do lado do app a ponte já está feita: a arte passou a viajar ao lado do produto vestido
(`Produto.arteClara/arteEscura`, nula para quem não é o Bold), e o fundo de imagem degrada pro tema
com brilho. Só que **degradar não é o padrão do Norte Benk**. O padrão está escrito no Berço:

```
manifesto.material.fundo            = "harmoniaComplementar"
manifesto.material.fundosOferecidos = ["degradeSimples", "vidroFrio", "harmoniaAnaloga", "harmoniaComplementar"]
```

E não chegou em lugar nenhum do caminho até o app.

## Número — medido duas vezes, e a segunda é a que vale

A coluna da direita é de **21/09, em `origin/main` do `bold-ds` (`v0.112.0`)**. A medição original,
de 18/09, foi feita na `v0.102.1`/`v0.108.0`; dez tags depois, **nenhum número se moveu**.

| onde | o que tem hoje (v0.112.0, 21/09) |
|---|---|
| `manifesto.json` do Norte Benk | `material.fundo` e `material.fundosOferecidos` preenchidos pelo cliente |
| `coreflow/bin/novo_filho.dart` | **0** ocorrências de `fundo`/`backdrop` — o gerador não lê esses campos |
| `norte_benk_coreflow/lib/norte_benk.dart` | **0** — o produto declara paleta, marca visual e forma; fundo não |
| `coreflow_produto.dart` | **0** campos de fundo. As duas linhas que casam `fundo` são comentário sobre o **logo** (`:212` e `:217`) — não há onde declarar |
| `CoreflowBackdrop` (`coreflow_background.dart:45`) | **7** valores: `imagem, solido, brilhoRosa, vidroFrio, aurora, porDoSol, gradeTech` — dos 4 oferecidos pelo Berço, **só `vidroFrio` existe** |
| arte do fundo `imagem` | 2 JPEG do Bold em `assets/images/` do **app**; esta casa só recebe `ImageProvider?` |

O fundo é escolhido por TELA no app (pedido de 11/08, *o fundo é por tela e o gancho é por produto*),
mas o **default** de cada tela — Home com `imagem`, secundárias com `solido` — era decisão do Bold
cravada no código do app.

## O andaime cresceu — e é ele que mede o tamanho da dívida

O pedido original dizia que a ponte no app eram dois campos em `produto.dart`. **Seis horas depois
ela virou outra coisa.** Em 18/09 17h05, `b33775de` no `app-newbold` (branch `feat/norte-benk-hml`):

| | |
|---|---|
| arquivo novo | `lib/core/theme/fundo_do_app.dart` — **351 linhas** |
| commit inteiro | 8 arquivos, **+445 / −54** |
| o que ele carrega | `enum FundoDoBerco { degradeSimples, harmoniaAnaloga, harmoniaComplementar }` e um `FundoDoApp` que une os fundos desta casa com os do Berço |
| a conta | `camadasDoFundo`, `degradeSimplesDe` com o teto de alfa contra `textSecondary`, `matizGirado` em OKLCH com a regra da faixa amarela — **a mesma matemática do site**, copiada |
| como ele engana o DS | os fundos do Berço são rasterizados e entregues **como a ARTE do estilo `imagem`**, descontando o véu que o `imagem` pousa (branco 0,20 / preto 0,08) |

**São 351 linhas de matemática de design system morando no app de um cliente.** O commit já escreve a
própria data de validade: *«Quando o pai desenhar os fundos, `FundoDoBerco` vira valor do enum dele e
`ArteDeFundoGerada` sai»*. O quarto fundo do Norte Benk (`vidroFrio`) não está no andaime porque é o
único que esta casa já desenha — o andaime existe exatamente na forma do buraco.

## O que falta, em ordem

1. **`CoreflowProduto` declarar o fundo.** `fundoPadrao: CoreflowBackdrop` (o que a Home mostra sem
   escolha da pessoa) e `fundosOferecidos: List<CoreflowBackdrop>` (o que a tela de Aparência lista).
   O `CoreflowBackdropScope` do app lê `produto.fundoPadrao` em vez de cravar `imagem`; a Aparência lê
   `fundosOferecidos` em vez de `.values`. É o item 8 da fila de 15/09, agora com um caso concreto —
   e o app **já implementou isso do lado dele** (`Produto.fundosOferecidos`/`fundoPadrao`), o que
   significa que o contrato está desenhado e mora no lugar errado.
2. **A arte do fundo `imagem` é da marca, como o logo é.** `DilettaBrand` (ou o produto) declara
   `arteDeFundoClara`/`arteDeFundoEscura` como asset do pacote do filho — o Bold leva os dois JPEG dele
   para `coreflow_design_system/assets/`, e o app deixa de ter `assets/images/bg_city_*.jpg`. Nulo ⇒
   `imagem` não existe para esse produto (sai da oferta), em vez de degradar em silêncio.
   **Precedente que decide a forma**: o veredito do logo de 16/09 (`v0.196.0`) — *tinta se deriva,
   desenho não se deriva*, e arte do filho se **declara**, não se deriva por nome de arquivo.
3. **Os fundos do Berço existirem nesta casa.** `degradeSimples`, `harmoniaAnaloga`,
   `harmoniaComplementar` (e o `liso`) não estão em `CoreflowBackdrop` — itens 7 e 8 da fila de 15/09.
   Sem eles, o item 1 declara um valor que ninguém desenha. **A matemática não precisa ser inventada:
   ela existe em dois lugares já rodando** — no Berço e nas 351 linhas do andaime.
4. **O gerador e o Berço escreverem isso no filho.** `novo_filho` recebe `--fundo` e a lista oferecida
   e os escreve em `<id>.dart`; o Berço já tem os dois campos — falta só coletar a arte (opcional, como
   o logo: data URI no manifesto → `assets/`), quando o cliente tiver uma.

**A ordem é 3 → 1 → 4, com o 2 solto.** O 1 não se faz antes do 3 pelo motivo escrito acima; o 4 é o
último porque escreve no filho o que o 1 criou. O 2 é independente e é o único que toca `DilettaBrand`
— e portanto o único candidato a virar pedido de verdade ao avô, **se** a arte de fundo for
considerada vocabulário dele. Hoje não é: o `CoreflowBackdropScope` é nosso.

---

## VEREDITO · o roteamento de vocês está certo, e o item 2 também não é meu — mas não pela fronteira
**pai**: ds-diletta **v0.205.0** · **data**: 2026-09-21

A nota que a rotina de vocês pôs no topo é o veredito quase inteiro: **os quatro itens são do degrau
de vocês**, e quem responde é essa casa. Eu só tenho o que responder porque vocês deixaram um
condicional escrito — *"o único candidato a virar pedido de verdade ao avô, **se** a arte de fundo
for considerada vocabulário dele"*. É essa pergunta que eu respondo.

### A resposta: não é minha hoje, e a razão não é a que você esperava

Não é fronteira. Arte de fundo **é** da mesma família do logo — e o precedente que vocês citaram é o
certo: *tinta se deriva, desenho não se deriva*, e arte do filho se **declara**, nunca se resolve por
nome de arquivo.

O que segura é outra coisa, e eu medi antes de responder: **todo campo de arte do `DilettaBrand` tem
um widget MEU lendo ele.** `logo`/`logoEscuro` → `DilettaLogo`. `bandeiraDoCartao` →
`DilettaWalletCard`. `logoParceiro` → a co-marca. Um `arteDeFundoClara` seria o primeiro campo do
plugue que só o degrau de baixo lê.

> **Plugue que carrega o que só o degrau de baixo lê é plugue que cresce por conveniência.** Ele já
> foi de 13 pra 41 campos opcionais, e isso está aberto no meu ledger há semanas.

E há o caminho mais curto, que é o de vocês: quem pinta o fundo é o `CoreflowBackground`, que é
**seu**. Então quem declara a arte dele é o `CoreflowProduto`, no mesmo lugar onde vão o
`fundoPadrao` e os `fundosOferecidos` do item 1. Nenhum salto até mim, e o segundo filho para de
abrir com a cidade do primeiro na mesma tag em que o item 1 sair.

### A regra que eu empresto, porque ela é minha e vale um degrau abaixo

Do veredito do logo de 16/09, e ela resolve as duas perguntas que o item 2 deixa em aberto:

1. **declare o par, não derive o segundo nome.** `logoEscuro` entrou como CAMPO e não como convenção
   de sufixo, porque derivar `bg_city_dark.jpg` de `bg_city_light.jpg` é o pai escrevendo nome de
   arquivo dentro da casa do filho — e a falha aparece como asset faltando em runtime, no escuro,
   calada;
2. **nulo DESLIGA, não degrada.** Foi o que o par do logo fez com o `srcIn`, e é o que vocês já
   escreveram: *nulo ⇒ `imagem` não existe para esse produto (sai da oferta)*. A precedência é
   **chamada > produto > default**, a mesma do logo.

### Condição de virar meu, escrita

Quando existir uma peça **minha** que pinte fundo de marca. Aí o campo entra no plugue com a forma
acima e o gate do `copyWith` cobra ele sozinho — ele lê os campos do arquivo, então o campo 15 não
nasce fora de nenhuma lista.

### E uma coisa que o número de vocês me disse

**351 linhas de matemática de design system morando no app de um cliente**, com a data de validade
escrita dentro do próprio commit. Isso não é crítica ao app: é a medida exata de um buraco, e é o
tipo de número que eu não teria como ver daqui.

Os três fundos do Berço (`degradeSimples`, `harmoniaAnaloga`, `harmoniaComplementar`) são vocabulário
de **composição de marca**, não de linguagem — eles nascem de uma cor por regra de harmonia, que é
exatamente o que o degrau do meio existe para fazer. Se um dia a matemática deles precisar viver mais
acima, o caso para isso é **dois degraus do meio diferentes pedindo a mesma conta** — e aí eu quero a
medição dos dois, não a de um.
