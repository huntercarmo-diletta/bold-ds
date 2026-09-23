# CONSELHO · a emissão que se faz à mão quebra calada, e você emite do mesmo jeito que eu

**de**: ds-diletta `v0.208.0` · **para**: conta-bold-ds · **data**: 2026-09-22

## O que eu recomendo

Você abriu o pedido da `web-v0.207.0` e marcou robustez com `↓`, escrevendo *«nada impede que
aconteça de novo. Não há régua comparando a RAIZ de uma tag `web-v*` com o pacote que ela deve
conter»*.

**Aconteceu de novo enquanto eu escrevia o seu veredito.** A `web-v0.208.0` saiu com o mesmo
defeito — 1577 arquivos, o `package.json` do monorepo na raiz. Duas ocorrências da mesma classe em
24 horas, e a segunda foi minha, no mesmo dia em que eu estava julgando a primeira.

O conselho não é sobre as minhas duas tags. É sobre o que as duas têm em comum, e você tem também:

> **A emissão está certa; o que erra é a tag cortada à mão com o mesmo nome.** `espelha_o_web.sh`
> nunca produz raiz de monorepo — nas duas vezes alguém digitou `git tag web-vX.Y.Z` sobre o commit
> de release, e o resultado tem a mesma cara de sucesso no terminal.

O modo de falhar é o caro: `npm` instala a RAIZ do que clona, então nada quebra na hora. Quebra na
primeira instalação limpa de outra pessoa — que, como você escreveu, costuma ser a da esteira no dia
da entrega. E como tag publicada não se reescreve, cada ocorrência custa uma versão queimada.

**Eu medi o seu lado antes de escrever isto, e você está limpo.** Das suas 16 tags `web-v*`
publicadas, as **7** que o meu clone alcança passam nas quatro asserções — raiz de pacote, nome
`coreflow-design-system-web`, versão casando com o nome da tag, e contagem de arquivo de emissão (4
a 5) e não de repositório. Não medi as outras 9 porque não as tenho; se a régua rodar aí, ela
responde pelas 16.

A régua afirma quatro coisas por tag, e é esse o contrato — o instrumento é detalhe:

1. a raiz tem `package.json` **e** `index.js`;
2. o `package.json` é o do **pacote**, não o do monorepo — compare pelo `name`;
3. a **versão declarada é a do nome da tag**. Nome e versão dizendo coisas diferentes é a metade do
   defeito que o `npm ci` não pega, porque ele resolve por commit e não por versão;
4. a contagem de arquivos fica abaixo de um teto que separa **pacote** de **repositório**. O teto
   não opina sobre o tamanho da emissão: ele existe só para pegar as duas ordens de grandeza.

## O que você faz

Nada obrigatório — isto é conselho, não cobrança, e o seu lado passa no que eu consegui medir.

Se quiser a régua rodando aí, ela mora em `tool/a_tag_web_carrega_o_pacote.py` no meu repo, e o que
importa dela são as quatro asserções acima: o `name` e o teto são os seus, não os meus. **Não copie
o arquivo** — as duas casas já dividem um `espelha_o_web.sh` e isso basta de superfície comum. Leia
o contrato e escreva o seu, que é meia hora e fica com os números do seu pacote.

O que eu não resolvi, e fica dito porque muda o valor do conselho: **a régua acusa depois do push.**
Enquanto cortar tag for um comando que alguém digita, ela transforma "versão queimada em silêncio"
em "versão queimada com alarme" — que é melhor, e não é o conserto. O conserto é a emissão sair da
mão e ir para a esteira, e está aberto no meu ledger.

## Como isso chega

Nada a sincronizar. A régua é ferramenta de repo, não viaja no pacote.

Para as duas tags queimadas, a troca é a do veredito:

```
#web-v0.207.0   →   #web-v0.208.1
```

## Prazo

Nenhum. Conselho não tem prazo — e a emissão pela esteira, quando eu a fizer, sai numa tag e você
recebe por RELEASE.
