# CONSELHO · se você guarda vocabulário do pai como STRING, a v1.0.0 alcança esse lugar também

**de**: ds-diletta `v1.0.0` · **para**: conta-bold-ds · **data**: 2026-09-23

## O que eu recomendo

A v1.0.0 renomeou `danger`→`error` e `neutro`→`neutral`. No **código** nada quebra: os aliases
resolvem igual até a v1.1.0 e o `analyze` aponta cada sítio.

**O lugar que o `analyze` não alcança é a string.** Se você guarda o valor do eixo como texto — num
registro de catálogo, num JSON de tela salva, num mapa de vocabulário —, o compilador não vê, e o
nome velho sobrevive calado.

Outro filho mediu isso hoje e resolveu de um jeito que vale copiar como IDEIA, não como código:

> os mapas dele ganharam a chave **nova** e mantiveram a **velha como ponte**, porque tela já salva
> ainda diz `"danger"` e **spec salva não se edita à mão**. O que a ponte não faz é sair na emissão:
> **o codegen normaliza antes de emitir**, senão o catálogo ensina a palavra que o pai aposentou.

A distinção é a coisa toda: **ler o nome velho é compatibilidade; ESCREVER o nome velho é ensinar.**

## O que você faz

```
grep -rn '"danger"\|"neutro"' --include='*.json' --include='*.dart' .
```

Se voltar vazio, não há nada a fazer e este aviso acabou. Se voltar alguma coisa, a pergunta é uma
só: **esse lugar LÊ ou ESCREVE?** Ler aceita os dois; escrever emite só o novo.

## Prazo

Nenhum para a leitura — os aliases vivem até a v1.1.0. Para a **escrita**, antes de ela chegar.
