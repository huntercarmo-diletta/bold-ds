# PEDIDO · A ponte do prefixo viaja no pacote e não tem porta

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.198.0` · `web-v0.198.0`
- **bloqueante?**: **sim, para subir de versão.** O nosso consumidor lê 107 nomes `--cps-*`; com a
  `web-v0.198.0`, **23 ficam sem valor** e nenhum erro aparece. Seguramos a subida por isso.

## O caso, em duas linhas

A `v0.198.0` renomeia as variáveis para `--diletta-*` e emite a ponte:

> *«ponte: as folhas com o nome velho continuam emitidas, com `@import` + alias por `var()`. Sai na
> v0.210.0»*

Elas continuam emitidas mesmo — conferimos na tag, não no changelog:

```
$ git ls-tree -r --name-only web-v0.198.0 | grep tokens/
tokens/cps-papeis.css
tokens/cps-tokens.css
tokens/diletta-papeis.css
tokens/diletta-tokens.css
```

E `files` carrega a pasta inteira. **Os dois arquivos estão no pacote publicado.**

O que mudou junto foi o mapa de exportação:

```json
"./tokens.css": "./tokens/diletta-tokens.css",   // era ./tokens/cps-tokens.css
"./papeis.css": "./tokens/diletta-papeis.css",
```

Não há entrada para as folhas de ponte, e `exports` fecha o resto do pacote:

```
$ node -e "require.resolve('diletta-design-system-web/tokens/cps-tokens.css')"
ERR_PACKAGE_PATH_NOT_EXPORTED
```

**A ponte existe e não tem porta.** Quem importava pelo nome documentado recebe, em silêncio, a folha
sem os apelidos — e o silêncio é o ponto: variável sem valor não é erro no navegador, é uma
declaração que some.

## O que medimos do nosso lado

O Internet Banking lê **107** nomes `--cps-*`. Com a `web-v0.198.0` instalada:

| | |
|---|---|
| resolvem | 84 — os que a NOSSA folha declara e agora aliasa |
| **sem valor** | **23** |

Os 23 são as suas primitivas, que só você declara: nove degraus de espaço (`--cps-s0_5` a
`--cps-s12`), os raios (`--cps-r200`), `--cps-blackAlpha40`, as três durações, as duas elevações,
`--cps-glassBlur` e os degraus de tipo.

Nenhum deles é nosso para consertar: são a língua.

## O pedido, e ele já está provado

Duas linhas no `exports`. Sem arquivo novo, sem emissão nova:

```json
"./ponte/tokens.css": "./tokens/cps-tokens.css",
"./ponte/papeis.css": "./tokens/cps-papeis.css"
```

Testamos no seu pacote instalado, acrescentando as duas linhas e restaurando depois:

```
OK  diletta-design-system-web/ponte/tokens.css  → cps-tokens.css
OK  diletta-design-system-web/ponte/papeis.css  → cps-papeis.css
OK  diletta-design-system-web/tokens.css        → diletta-tokens.css
```

Os três caminhos convivem: quem já migrou pede `tokens.css`, quem ainda escreve o nome velho pede
`ponte/tokens.css`, e a data de saída continua sendo a sua — v0.210.0.

O nome `ponte/` é sugestão, não exigência. O que importa é existir um caminho, e ele dizer no nome
que é temporário.

## O que aprendemos do nosso lado, e que talvez sirva

Fomos ao mesmo buraco por outra porta, e quase publicamos um pacote quebrado por causa dele.

A sua ponte aponta `--cps-x → var(--diletta-x)`, e ela serve a quem **escreve** o nome velho na
própria folha. Um consumidor. **Um filho não escreve: ele sobrescreve** — e sobrescrever o nome velho
não alcança as peças, que passaram a ler o novo.

Medido num diretório vazio, com o nosso pacote instalado pela tag, antes de publicar:

    <diletta-button>  desenhou em  #17a37d   ← o seu verde de referência
    a nossa folha declarava        #f66fa0   ← o rosa do Bold, que ninguém lia

Sem um erro no console. Consertamos emitindo `--diletta-*` e carregando a nossa própria ponte de 149
apelidos — e nasceu um gate que faltava na nossa casa: *«o nome que a PEÇA lê é o nome que a FOLHA
declara»*, que lê os `var(--x)` dos seus fontes e compara com o que emitimos.

**A classe é a mesma nos dois casos, e talvez ela renda um gate do seu lado:** uma renomeação com
ponte tem dois públicos, e eles precisam de coisas diferentes. Quem **escreve** o nome velho precisa
do alias. Quem **sobrescreve** precisa saber que o nome mudou — para ele, a ponte não é ajuda, é
anestesia: tudo continua resolvendo e nada mais é lido.
