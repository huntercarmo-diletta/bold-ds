# Pedido do filho · o mapa da arte é de quem DESENHOU, e hoje o filho carrega o mapa do pai na mão

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta **v0.124.0** · DS filho v0.58.0
- **origem**: a adoção do `hexesDaArte` de ontem, e o defeito que ela produziu aqui em 24 horas

## Falta

Uma arte tem UM dono, e o mapa que traduz os hexes dela é conhecimento DELE. Hoje `rampaDe` tem um mapa
só por chamada, e ele é **exclusivo**:

```dart
final declarado = marca?.hexesDaArte ?? const <String, String>{};
if (declarado.isNotEmpty) { /* devolve SÓ o do filho */ }
return { /* a sua tabela */ };
```

Quem consome arte de **dois desenhistas** — que é o caso normal assim que um filho adota uma ilustração
sua — tem que declarar as duas chaveaduras no seu próprio `DilettaBrand`. Não existe hoje forma de dizer
*"para os assets DELE, a tradução é a dele; para os meus, a minha"*.

## Número

- **33 pinturas** saíram azuis num app rosa por 24 horas, em 4 arquivos (`key_word` e `no_data`, claro e
  escuro), sem erro, sem log, sem gate. Adotei as duas artes ontem e declarei os meus 7 hexes no mesmo
  commit — **foi o ato de declarar que desligou a sua tabela**;
- **10 chaves suas** agora vivem copiadas dentro do `hexesDaArte` deste filho. São a sua rampa, na minha
  casa, sem nada que as reconcilie quando você mudar;
- **3 hexes** azuis nas suas 59 artes que a sua própria tabela não declara (`#7096ff` ×2, `#f5f9ff` ×2,
  `#dfe7ff` ×1). Quem adotar `save_quick_on_boarding`, `with_files_light`, `page_not_found_flat_light` ou
  `sad_face_flatline` leva azul mesmo copiando a sua tabela inteira;
- **20/09** é a data que você escreveu pra remoção da tabela. Nesse dia, o único lugar do mundo onde a
  rampa das SUAS artes estará escrita é o `hexesDaArte` dos filhos.

## Já tentei

Copiar as suas 10 chaves pro meu mapa. Funciona, está tagueado (v0.58.0) e é o que roda hoje. Duas coisas
que a cópia não resolve:

1. **ela envelhece calada.** Se um degrau seu mudar de hex na arte, o meu mapa continua traduzindo o hex
   velho e o novo passa direto — o `apply` não erra alto, é o argumento que você mesmo usou;
2. **ela se multiplica.** Três filhos consumindo arte sua = três cópias da sua rampa, e a quarta vai ser
   escrita de memória por alguém às onze da noite.

Também tentei ancorar o meu gate na sua tabela em vez da cópia: `rampaDe(paleta)` sem `marca:` devolve a
sua declaração, e eu afirmo que o meu mapa a cobre inteira. É o melhor que dá hoje, **e ele morre em
20/09 junto com a tabela.**

## Conferi no pai

- `DilettaBrand` tem `hexesDaArte` (um mapa, sem dono de asset);
- `rampaDe(p, {marca})` — um `marca:` por chamada;
- `DilettaIllustrationAccessory` resolve `tema.brand`, que é a marca do PRODUTO, não a do pacote de onde o
  asset veio. A informação que falta na hora do recolor é justamente essa: **o asset é de quem?**
- e ela existe: `DilettaIllustration` sabe que o caminho é `packages/diletta_design_system/assets/...`.

## Derivável?

Não do meu lado. Eu posso copiar a sua tabela (fiz), mas não posso fazer o meu `apply` distinguir asset
seu de asset meu: quem escolhe a rampa é a função, dentro da peça, com um mapa só.

## Se você disser não

Fica como está: eu carrego as suas 10 chaves copiadas, o gate 1 morre em 20/09, e **a condição de reabrir
é o terceiro filho** — no dia em que dois filhos tiverem a sua rampa copiada com valores diferentes, a
pergunta volta com o diff em vez do risco. Se for isso, o que eu peço no lugar é bem menor: **a sua tabela
não some em 20/09, vira uma constante pública** (`DilettaIllustrationBrand.rampaDoPai` ou nome seu), pra
que copiar deixe de ser copiar e vire referenciar.

## Não estou pedindo

- que `hexesDaArte` volte a ser aditivo por padrão — foi você que separou, e separar estava certo: um mapa
  aditivo faria a minha arte rosa herdar tradução azul sem eu pedir;
- que `marca:` deixe de virar obrigatório em 20/09 — concordo com a data;
- forma. Duas que eu enxergo, e a escolha é sua: um mapa por PACOTE de origem (`Map<String, Map<...>>`
  chaveado pelo `pacote:` do `DilettaBrand`), ou a sua rampa como constante pública que o filho compõe
  explicitamente (`hexesDaArte: {...meus, ...DilettaIllustrationBrand.rampaDoPai}`). A segunda é uma linha
  e resolve 90% — a primeira é a que também resolve o caso de o filho C consumir arte do filho A.

## Como o pai vai saber que funcionou

Um filho que declara mapa próprio E monta uma arte SUA não tem nenhum hex de marca sua no SVG renderizado
— **sem ter escrito nenhuma chave sua**. O gate está escrito aqui e passa hoje só porque eu copiei:
`packages/conta_bold_design_system/test/a_arte_do_pai_sai_na_nossa_cor_test.dart`. No dia em que a forma
existir, eu apago as 10 linhas e ele tem que continuar verde.

---

## Veredito · ENTRA DIFERENTE — a rampa vira PÚBLICA, e você derrubou uma frase minha de ontem
**pai**: ds-diletta **v0.126.0** · **data**: 2026-08-20

`DilettaIllustrationBrand.rampaDoPai`, pública e completa. **E a retificação do que eu escrevi ontem.**

### O que decidiu

Isto, que é a segunda das duas formas que você ofereceu — e você mesmo disse que ela *"é uma linha e
resolve 90%"*:

```dart
hexesDaArte: const {...osMeus, ...DilettaIllustrationBrand.rampaDoPai},
```

Mas o que decidiu **não** foi a economia de linhas. Foi a sua conta sobre 20/09:

> *"Nesse dia, o único lugar do mundo onde a rampa das SUAS artes estará escrita é o `hexesDaArte` dos
> filhos."*

Isso me fez ir contar, e a contagem derruba a premissa do que eu escrevi ontem: **as 59 artes moram no MEU
pacote** (`assets/illustrations/`, contadas). Elas foram desenhadas no azul do primeiro filho e **doadas ao
pai**. Então o mapa que as traduz não é valor de marca de um produto na minha casa — é **dado meu sobre
asset meu**, e a regra 1 nunca falou disso.

Eu tinha lido a frase do meu próprio `///` (*"as ilustrações vêm do Figma com o azul do primeiro filho
cozido dentro do arquivo"*) como *"a arte é dele"*, quando ela diz *"a arte foi desenhada por ele e está
aqui"*. **Uma preposição, e ela mudou de quem era o dado.** A retificação está escrita no `///` do
`rampaDe`, e o **PEDIDO DO PAI que eu mandei pro primeiro filho foi retirado hoje**, no arquivo dele, com
a razão.

Então: a tabela **não morre em 20/09**. Ela fica, pública, completa e com o nome dizendo de quem ela é.

### Os três hexes que você mediu eram defeito, e o pior tipo

`#7096ff` (2), `#f5f9ff` (2), `#dfe7ff` (1) — cinco pinturas em quatro artes que **a minha própria tabela
não declarava**. Conferi por luminância, com os degraus vizinhos já declarados como régua:

| hex | luminância | vizinhos | virou |
|---|---|---|---|
| `#7096ff` | 0,325 | entre `#668fff` (0,297) e `#99b4ff` (0,466), os dois `primary06` | `primary06` |
| `#dfe7ff` | 0,801 | passa do `#ccdaff` (0,702, `primary07`) | `primary08` |
| `#f5f9ff` | 0,944 | o quase-branco | `primary09` |

E a sua leitura do que isso custava é a que importa: **quem adotasse `save_quick_on_boarding`,
`sad_face_flatline`, `with_files_light` ou `page_not_found_flat_light` levava azul mesmo copiando a tabela
inteira.** Mapa incompleto não erra alto — ele mente no caso que ninguém testou. Tem gate agora: **nenhum
azul cozido fora da rampa**, nas 59, medindo canal azul dominante e ignorando cinza (que é invariante por
regra).

### O que eu achei indo implementar

**1 · A rampa passou a ser `hex → NOME`, igual ao `hexesDaArte`.** Ela era `hex → cor resolvida` por
dentro; virar nome é o que permite compor com o mapa do filho no mesmo tipo, e é o que faz a composição ser
uma linha em vez de uma conversão.

**2 · As 13 linhas passam na minha própria conformidade.** Rodei `violacoesDoMapaDaArte` contra a rampa do
pai: vazio. Era o mínimo, e não era garantido — o gate que eu escrevi ontem pra medir mapa de filho nunca
tinha sido apontado pro meu.

**3 · O que eu NÃO fiz, e é a sua opção 1.** O mapa por PACOTE de origem (`Map<String, Map<...>>`) não
entrou, e a razão é a sua própria medição: hoje são duas rampas que **não colidem em nenhum hex** (a sua é
rosa, a minha é azul), então um mapa composto é exato e não aproximado. A forma por pacote resolve um caso
que ainda não existe, e o custo dela é real — a peça passaria a precisar saber de que pacote o asset veio,
que é informação que ela hoje não carrega.

> **A condição de reabrir está escrita:** duas rampas que compartilham um hex com significados
> diferentes. Nesse dia a composição deixa de ser exata e a chave por origem é a única resposta — e o
> pedido volta com o diff, como você propôs no seu «Se você disser não».

### O que você faz

`ref: v0.126.0`

1. troque as **10 linhas copiadas** por `...DilettaIllustrationBrand.rampaDoPai` no seu `hexesDaArte`. O
   seu gate (`a_arte_do_pai_sai_na_nossa_cor_test`) tem que continuar verde — é o critério que você
   escreveu, e agora ele mede a composição em vez da cópia;
2. **os três hexes novos entram de graça** com a composição. Se você tiver adotado alguma das quatro artes,
   elas param de sair azuis sem você declarar nada;
3. e o seu gate 1 (o que ancorava na minha tabela) **não morre mais** — a âncora agora é pública e tem
   nome. Se algum dia eu mudar um hex de uma arte, o seu gate acusa, porque ele compara com a minha
   declaração e não com uma cópia dela.

Uma coisa que eu quero registrada, porque ela é o par das duas notas de hoje: você trouxe **um defeito meu
de arquivo** (o clip vazio) e **um defeito meu de premissa** (a tabela que eu ia matar) no mesmo dia, e nos
dois casos o instrumento foi olhar a arte com um renderizador que não é o nosso. **O meu retrato é de peça,
não de arte** — essa é a lacuna que os seus dois relatos mediram, e ela é minha.

---

## Resposta do filho · adotado na v0.62.0 — as 10 linhas viraram uma, e 3 hexes entraram sem eu saber

`ref: v0.126.0`. Suíte daqui: **192 verdes**.

```dart
hexesDaArte: {
  ...os 7 nossos,
  ...DilettaIllustrationBrand.rampaDoPai,   // 13, e eu não preciso saber que eram 10 ontem
},
```

O gate que eu escrevi como critério (`a_arte_do_pai_sai_na_nossa_cor_test`) continuou verde **sem uma
linha de mudança**, e é isso que fecha o ciclo: ele nunca mediu a cópia, mediu a cobertura. Trocar a
fonte por baixo dele foi trocar o que ele lê, não o que ele afirma.

### Os 3 hexes de graça, medidos do meu lado também

`#7096ff`, `#dfe7ff`, `#f5f9ff` entraram na composição sem eu escrever nada. Nenhuma das quatro artes
que os usam é montada aqui hoje — então o que eu ganhei não é pixel, é a **classe de defeito que deixou
de existir** pro dia em que eu adotar uma delas. Foi exatamente o valor que eu não soube estimar quando
escrevi o pedido: eu falei em cópia envelhecendo e o caso real foi mapa incompleto em arte que eu ainda
não uso.

### A sua retificação vale mais que a forma, e eu quero dizer por quê

> *"Uma preposição, e ela mudou de quem era o dado."*

Eu escrevi o pedido inteiro em cima de *"a rampa das suas artes"* sem notar que estava concordando com a
premissa que ia matar a tabela. Você foi contar e achou que as 59 moram no seu pacote — quer dizer: **o
argumento que derrubou a sua decisão de ontem saiu de uma frase minha que eu escrevi sem perceber que era
um argumento.** Fica registrado porque a lição não é minha nem sua: pedido que carrega o número bruto (não
a conclusão) deixa o outro lado chegar em conclusão que nenhum dos dois tinha.

### E o que eu fiz com o «não» da opção 1

Nada, e concordo com a condição de reabrir. Medi do meu lado pra confirmar a sua premissa: as duas rampas
**não compartilham nenhum hex** — 7 chaves minhas em rosa, 13 suas em azul, interseção vazia. Enquanto for
assim, a composição é exata e o mapa por pacote resolveria um caso que não existe.

### Uma coisa sua que eu não vou deixar passar em branco

> *"O meu retrato é de peça, não de arte."*

Foi a mesma lacuna que me pegou. Eu tinha **três gates verdes** sobre estas ilustrações e nenhum via que a
arte saía azul; o que viu foi abrir um PNG. No mesmo dia, o que achou o `clipPath` vazio foi um
renderizador que não é o nosso, e o que achou um quadrado preto num `_dark` foi uma folha de contato de 14
artes. **Gate mede o que eu já sei perguntar** — e três descobertas em um dia vieram de olhar, não de
perguntar.
