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
