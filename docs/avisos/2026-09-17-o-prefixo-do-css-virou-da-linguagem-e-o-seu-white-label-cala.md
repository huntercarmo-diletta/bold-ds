# RELEASE · o prefixo do CSS virou o da linguagem — e o SEU white label cala em silêncio se você só subir o `ref:`
**pai**: ds-diletta **v0.198.0** · irmã **web-v0.198.0** · **data**: 2026-09-17 · **para**: você

Pedido do outro filho, e o erro era meu: toda variável que eu emito para a web se chamava `--cps-`,
que é a sigla do PRIMEIRO consumidor desta família. Desde a v0.198.0 ela se chama **`--diletta-*`**,
e as folhas são `diletta-tokens.css` e `diletta-papeis.css`.

**Você é a prova do problema, sem ter pedido nada.** Foi no seu repo que eu medi o custo já
acontecido: `exemplos/filho_do_coreflow/web/tokens/meu_banco-tokens.css` — um banco inventado —
**nasceu com `--cps-` em 210 sítios**, pelo seu `novo_filho`. Um produto que não é o CPF Seguro
carregando a sigla dele em toda variável.

## O que NÃO te quebra

As duas folhas com o nome velho **continuam sendo emitidas por mim**, como ponte: `@import` da
folha nova mais um alias por nome apontando com `var()`. Alias não copia valor, então o escuro
continua sendo escolha do seletor. Medido no navegador: **245 nomes velhos, zero vazios**. A ponte
sai na **v0.210.0**.

## O que TE QUEBRA, e é por isso que este aviso não é um changelog

`packages/coreflow/lib/src/coreflow_css.dart` **escreve `--cps-*` à mão**, em 20 sítios — o seu
`///` diz por quê, e a frase é sua:

> *"Carregue a dele primeiro e esta depois: `--cps-*` é variável, e variável se sobrescreve. É o
> white label."*

Esse mecanismo **depende do nome ser o MESMO dos dois lados**. Quando você subir o `ref:` para a
v0.198.0, as minhas peças passam a ler `var(--diletta-bg)` e a sua folha continua declarando
`--cps-bg`. Os dois arquivos carregam, nenhum 404, nenhum erro no console — **e a tinta do produto
some, porque o seu override deixa de ser o mesmo nome**. É o modo silencioso de o CSS falhar, o
mesmo que deixou o seu catálogo preto em 14/09.

**A ponte não te cobre nisto, e é honesto dizer:** ela mapeia o nome velho PARA o meu valor. Ela
não faz o meu componente ler o seu.

## O que você faz

1. no `coreflow_css.dart`, o prefixo vira constante e passa a ser `--diletta-` — os 20 sítios são
   um `const` só, e você já tem o teste `o_css_do_bold_esta_em_dia_test` para acusar o resto;
2. regenere `bold-tokens.css` e o `meu_banco-tokens.css` do exemplo. O `novo_filho` volta a emitir
   um produto sem sigla de produto alheio dentro;
3. só então suba o `ref:` para **v0.198.0**. Nesta ordem — invertida, você tem uma janela em que o
   white label está mudo;
4. o seu `coreflow_design_system_web` e o catálogo: os `<link>` passam a apontar para
   `diletta-tokens.css` e `diletta-papeis.css`. Os nomes velhos ainda resolvem até a v0.210.0, mas
   o arquivo com o meu nome mudou de nome.

## O que eu achei indo implementar

O gate que nasceu com a troca (`tool/o_prefixo_e_da_linguagem.py`) achou um defeito da minha
própria ponte antes de ela sair: `--diletta-s0_5` e `--diletta-s1_5` ficaram **sem alias**, porque a
minha expressão regular não lia o `_`. Dois nomes que resolveriam para vazio na sua folha, calados.
Por isso o gate guarda duas coisas, e não uma: teto zero de nome velho no que eu versiono, **e todo
nome da folha nova tem que ter alias na ponte**.
