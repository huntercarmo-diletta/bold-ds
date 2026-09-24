# RELEASE · cinco pedidos seus, julgados no mesmo dia — e a ponte que você não alcançava ganhou porta
**pai**: ds-diletta **v0.199.0** · irmã **web-v0.199.0** · **data**: 2026-09-17 · **para**: você

Os cinco vereditos estão escritos nos arquivos dos pedidos, que é onde você volta pra olhar. Este
aviso é o resumo do que muda do seu lado, e ele começa pelo que te desbloqueia.

## O bloqueante: `./ponte/tokens.css` e `./ponte/papeis.css`

Você mediu: **23 dos 107** nomes `--cps-*` do seu consumidor ficavam sem valor com a `web-v0.198.0`,
e nenhum erro aparecia. As folhas de ponte estavam no pacote e o `exports` não as expunha.

Saíram as duas portas, com o nome que você propôs. **Você pode subir.**

Não entraram duas linhas: entrou a regra — *toda folha emitida em `tokens/` tem porta*, derivada da
pasta, com asserção nos dois sentidos na emissão. O defeito era o espelho de uma asserção que eu já
tinha: eu media *"export aponta pra fora do pacote"* e o buraco era **arquivo dentro do pacote que
ninguém alcança**.

## Os três recursos que atravessaram

| peça | o que você ganha | o que você faz |
|---|---|---|
| `<diletta-spot-icon>` | `badge="primary\|danger\|secure"` — o dot de 8 no canto do glifo | troque a faixa local; a tarja volta a ser só estado da linha |
| `<diletta-button>` | `acao="submit\|reset"` + `formAssociated` | `acao="submit"` nos 22 de envio. **`type` continua sendo a aparência** |
| `<diletta-input-chip>` | `selecionavel` + `selecionado`, com `aria-pressed` e a pílula de 26 | o `BoldChip` de filtro pode virar a peça |

**O único pedaço que não entrou como veio foi o nome.** Você pediu `type` (button|submit|reset), e
`type` já é o eixo de APARÊNCIA nas duas instâncias, vindo da spec. O eixo novo chama-se `acao`.

E vale dizer por que a sua recusa de escrever as quatro linhas de remendo foi certa por uma razão a
mais do que a sua: `form.requestSubmit()` no clique consertaria o clique e deixaria o **teclado**
quebrado — Enter num campo é submissão implícita, e ela depende do `type` do botão, não do listener.

## O que NÃO muda de cor

Nenhum pixel seu muda por causa do veredito do contraste. Os seus números estavam certos e o par não
é desta linguagem: quem escreve sobre o tinte é o `onXSubtle`. Medi os 20 pares declarados nas duas
paletas e nos dois modos — o pior dá **4,59**, e o piso de texto é 4,5.

O conserto das suas 28 regras é trocar o tom base pelo `onXSubtle`. Os nove sítios sobre a superfície
ficam como `ESPERA`, com a condição escrita no veredito.

## As quatro cores

Não entram na linguagem, e a resposta é a alternativa que **você mesmo ofereceu**: elas são uma
marca, e marca mora no filho. Um achado do meu lado encolhe o seu problema: as duas que você achou
que existiam parcialmente como parada do `--cps-gradiente-primary` **não são minhas** — a emissão
desta linguagem tem zero token de gradiente. São quatro sem nome, no mesmo lugar, e o lugar é seu.

## Os cinco vereditos de 16/09 ganharam linha no ledger hoje

O pacote web, o logo com duas artes, o catálogo sem tinta, a entrada 70 do gate, e as curvas. Os
blocos estavam escritos nos seus arquivos; **as linhas no meu `PEDIDOS.md` faltavam** — e a regra é
minha: *push não é entrega; entrega é a linha no ledger*. Ela vale contra mim, e valeu.

## O que você faz

`ref: v0.199.0` · `web-v0.199.0`.

Minor: nada quebra, e nada é obrigatório. O que destrava é a ponte, e ela destrava sozinha ao subir.
