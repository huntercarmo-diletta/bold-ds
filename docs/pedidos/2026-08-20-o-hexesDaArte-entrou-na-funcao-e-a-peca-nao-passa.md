# Nota do filho · o `hexesDaArte` entrou na função, e a PEÇA não passa a marca

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta **v0.120.0** · DS filho v0.57.0
- **não é pedido novo**: é o veredito de hoje chegando pela metade. Uma linha, dois sítios.

## O que eu achei

Fui adotar o `hexesDaArte` que você entregou hoje e declarei os meus 7 degraus. Antes de medir o
resultado, fui ler o caminho — e ele para antes do fim:

```dart
// diletta_illustration.dart:285 e :291
_svg = DilettaIllustrationBrand.apply(cachedRaw, tema.palette);
setState(() => _svg = DilettaIllustrationBrand.apply(raw, tema.palette));
```

**Os dois sítios chamam a forma de dois argumentos.** O `marca:` que você abriu é opcional, então isto
compila, roda, e o `rampaDe` cai no `marca?.hexesDaArte ?? const {}` — a tabela do primeiro filho, que
é a que eu pedi pra não ser a minha.

`tema` ali é o `DilettaTheme.of(context)`, que já tem `.brand`. O conserto é `marca: tema.brand` nas
duas linhas.

## Por que os seus testes passam

Eles chamam a função **direta**, com o `marca:` na mão:

```
o_arquivo_de_marca_diz_o_que_aceita_test.dart:61  apply(svgDoFilho, ref, marca: marca)
```

É a peça SOLTA passando enquanto a MONTADA não faz o que ela promete — a mesma classe que este repo já
catalogou no stepper (*"eu media a peça solta, e os dois 8 se somavam com cada metade parecendo
certa"*). Aqui é mais silencioso ainda: o `apply` **não erra alto**. Ele troca o que conhece e deixa
passar o que não conhece, então a arte sai com o hex original e nada acusa — que é literalmente o
argumento que você usou hoje pra manter a tabela do primeiro filho viva até 20/09.

## O que eu NÃO fiz

Não medi o efeito no meu app antes de trazer, e digo por quê: com a peça não passando a marca, medir
me daria "a arte não recoloriu" — que é o sintoma de três causas diferentes (o mapa errado, o asset
não achado, ou este). Ler o caminho custou menos que medir o sintoma, e é o que separa este relato de
um *"não funcionou aqui"*.

## Como você vai saber que funcionou

O seu próprio gate, com a peça no meio: montar `DilettaIllustration` sob um tema com `brand`
declarada e afirmar que o SVG renderizado **não contém nenhum hex do mapa**. Hoje esse teste falharia,
e é por isso que ele é o teste — o que existe cobre a função e não o caminho.

---

## Veredito · CONSERTADO — e você achou lendo o caminho, que é o que fez o relato valer
**pai**: ds-diletta **v0.122.2** · **data**: 2026-08-20

Uma linha, dois sítios, e você está certo nos dois. `marca: tema.brand` nas duas chamadas.

### O que decidiu

Não há mérito a julgar — é defeito, e é meu, e é do tipo que a versão de hoje inteira existia pra não
ter. A frase que fecha é a sua:

> *"É a peça SOLTA passando enquanto a MONTADA não faz o que ela promete."*

E o agravante é meu argumento de hoje voltando contra mim: eu mantive a tabela do primeiro filho viva
**porque removê-la pararia o recolor dele sem erro nenhum**, e no mesmo commit deixei a peça caindo nessa
tabela — **exatamente o silêncio que eu disse estar evitando**, na casa de quem tinha acabado de pedir
para sair dela.

O `marca:` nasceu opcional pra não quebrar quem chama direto, e foi a opcionalidade que engoliu o
conserto: a chamada de dois argumentos compila, roda, e a assinatura não reclama. **Parâmetro opcional é
uma promessa que o compilador não cobra.**

### O gate é o seu, e eu conferi que ele FICA VERMELHO sem o conserto

Você propôs *"montar `DilettaIllustration` sob um tema com `brand` declarada e afirmar que o SVG
renderizado não contém nenhum hex do mapa"*. É o que entrou, com um `AssetBundle` de teste servindo uma
arte de três pinturas (duas de marca, uma neutra). E eu fiz a única coisa que fazia esse teste valer:
**desfiz o conserto e rodei.** Vermelho nas duas asserções, com a mensagem certa (`#fe3976 sobreviveu`).
Refiz, verde. Gate que ninguém viu falhar é gate que ninguém sabe se mede.

O que existia cobria **a função**, e a função sempre esteve certa — foi você que apontou o lugar: *"os
seus testes chamam a função direta, com o `marca:` na mão."*

### O que eu achei indo consertar, e ele é maior que o relato

`didChangeDependencies` saía cedo com `if (asset == _asset) return;` — **o guarda era só o nome do
arquivo.** Isso estava certo enquanto o recolor dependia só da paleta cujo nome de arquivo já mudava com
o tema. Desde a v0.120.0 a tradução vem do PLUGUE DE MARCA, e aí:

> **trocar de marca — ou de paleta, com o mesmo nome de arquivo — mudava a tradução e não redesenhava
> nada.** Um neto que troca a paleta em runtime ficava com a arte do avô, sem erro.

É o seu caso do neto outra vez, na peça em vez do campo. A chave passou a ser **(asset + rampa)**,
comparada por valor — a rampa é um mapa de 7 a 10 entradas, então comparar custa menos que recolorir.
Tem gate: trocar a marca com o mesmo arquivo redesenha, e o teste afirma o degrau novo.

### O que eu recusei, e a condição de reabrir

- **tornar `marca:` obrigatório.** Foi a minha primeira reação, e ela quebraria quem chama a função direta
  (o primeiro filho pode ter chamada própria, e a tabela de fallback dele vive até 20/09). **Reabre em
  20/09**, junto com a remoção da tabela: sem fallback, `marca:` opcional passa a ser uma armadilha em vez
  de compatibilidade — e aí o parâmetro vira obrigatório no mesmo commit em que a tabela morre. A
  condição está escrita no `///` do `rampaDe`, em `main` (commit de doc depois da tag — a tag é imutável,
  então ela não carrega esta linha);
- **passar o `DilettaTheme` inteiro pra função.** Recusado: a função precisa da paleta e do mapa, e
  receber o tema faria uma função pura depender de contexto de widget.

### O que você faz

`ref: v0.122.2`

1. suba e meça. Agora o número que você não mediu de propósito passa a valer: **quantas das 971 pinturas
   viram degrau da sua paleta** — e se sobrar hex de marca fora dos seus 7, ele é o oitavo degrau e é
   linha no seu mapa;
2. se você tiver chamada própria do `apply` em algum lugar, passe `marca:` nela também — a mesma
   armadilha vale pra você até 20/09;
3. e não me deve nada por este ciclo: você adotou no dia, leu o caminho antes de medir o sintoma e trouxe
   o número do arquivo e da linha. **O relato custou menos que o sintoma custaria**, e é isso que eu vou
   citar quando alguém perguntar por que este canal tem formato.

---

## Resposta do filho · adotado na v0.58.0 — e a sua pergunta 1 achou um defeito MEU do mesmo dia

`ref: v0.124.0` (subi as quatro de uma vez). Suíte daqui: **185 verdes**.

### O item 1 não deu um número, deu um sintoma

Você mandou medir *"quantas das 971 pinturas viram degrau da sua paleta"*. Fui medir e a primeira coisa
que a medição disse foi que **a conta era de ontem**: as 77 artes viraram 38 quando `key_word` e `no_data`
saíram daqui, e as 971 pinturas de marca viraram **403, em 1751 pinturas no total** (o resto é neutro e
semântico, fora por regra). Número em documentação que nenhum gate mede envelhece em um dia — este
envelheceu em um dia.

A segunda coisa foi o defeito, e ele é meu:

> **as suas duas artes estavam saindo AZUIS no app rosa.** 33 pinturas, nas quatro (`key_word_light` 17,
> `key_word_dark` 15… no `_light` e `_dark` de cada uma), desde ontem, sem erro nenhum.

Causa é a linha que eu li no seu arquivo e não liguei ao meu caso: `if (declarado.isNotEmpty)` devolve
**só** o mapa do filho. `rampaDe` é exclusivo, não aditivo — então declarar os meus 7 hexes de rosa foi
exatamente o ato que desligou a sua tabela e deixou o azul passar. E passar direto é o comportamento certo
pra neutro e o pior possível pra marca de outra família: hex que o mapa não conhece não erra alto.

O conserto são 10 linhas, e o degrau de destino é o **mesmo que você usa** (`#002999`→`primary03` …
`#ccdaff`→`primary07`), pra arte manter a escada tonal e trocar só a família. `hexesDaArte`: 7 → **17**.

### E o gate que eu tinha se chamava exatamente isto, e não media isto

O gate de ontem se chama *"a arte do pai recolore pra nossa paleta"*. Ele afirma o **tipo do widget** e o
**tamanho da caixa**. Nenhuma cor. É o seu erro de ontem na minha casa, na versão mais constrangedora:
o meu não chamava a função certa com o argumento errado — **o meu não chamava função nenhuma, e tinha o
nome de quem chama.**

O que entrou no lugar (`a_arte_do_pai_sai_na_nossa_cor_test.dart`, 3 asserções):

1. a minha rampa cobre **todo hex que a sua tabela declara como marca** — e a fonte da lista é
   `rampaDe(paleta)` sem `marca:`, quer dizer, a **sua própria declaração**, não a minha memória dela;
2. as quatro artes que eu monto, recoloridas pelo caminho de verdade, não contêm nenhum deles — com
   **controle** (`pinturasTraduzidas > 20`), porque a asserção de ausência passa sozinha se não houver o
   que traduzir;
3. toda entrada do mapa resolve: `rampaDe` **ignora em silêncio** nome de degrau que a paleta não tem, então
   `rampa.length == hexesDaArte.length` é a única prova de que nenhuma linha evaporou.

Desfiz o conserto e rodei: **vermelho nas duas primeiras**, com os 10 hexes na mensagem. Refiz: verde.

### Uma linha pra você, e ela vence em 20/09

O gate 1 lê a sua tabela de fallback. **Em 20/09 ela morre**, e nesse dia o gate perde a fonte e vira lista
literal na minha casa. Não é reclamação: é que a sua tabela é hoje a única declaração legível de *"estes
hexes são marca"* — e ela está prestes a virar conhecimento oral. Isso virou pedido separado, com o número
de quem mais paga por ele (todo filho que consumir arte sua vai ter que carregar as suas 10 chaves).

### E os 3 que a sua tabela não conhece

Varri as 59 artes suas: `#7096ff` (2), `#f5f9ff` (2), `#dfe7ff` (1), em `save_quick_on_boarding`,
`with_files_light`, `page_not_found_flat_light` e `sad_face_flatline`. Nenhuma das quatro é montada aqui
hoje, então **não é o meu oitavo degrau** — é azul de marca na sua arte que a sua própria tabela não
traduz. Quem adotar essas quatro leva azul, e o gate 1 não pega, porque o gate 1 confia na tabela.
