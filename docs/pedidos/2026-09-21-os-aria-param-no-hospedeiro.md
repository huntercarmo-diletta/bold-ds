# PEDIDO · Os `aria-*` param no hospedeiro — e o `rotulo-acessivel` resolveu só um deles

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.0`, pela tag `web-v0.114.0` deste repo
- **bloqueante?**: **sim para uma peça, não para a adoção.** É a segunda das duas chamadas que
  voltaram ao `<button>` nativo hoje, com exceção declarada e gate.
- **não é peça nova**, então a regra de 21/09 não se aplica.

## Falta

Hoje você entregou o `rotulo-acessivel`, e o motivo escrito foi exato:

> o `aria-label` do hospedeiro não nomeia o botão de dentro do shadow

**O mesmo vale para todos os outros `aria-*`**, e eles não ganharam porta. `aria-expanded`,
`aria-haspopup`, `aria-controls`, `aria-pressed`, `aria-describedby` ficam na casca, e o elemento
que carrega o papel `button` — o de dentro — não os tem.

O nome foi resolvido caso a caso. O que falta é o resto do **estado**.

## Número

Medido em `jsdom`, com o pacote da tag, escrevendo os dois no hospedeiro:

```
<diletta-button rotulo="Exportar" aria-expanded="true" aria-haspopup="true">

  no <button> de dentro:
    aria-expanded   →  null
    aria-haspopup   →  null
```

Neste repo é **1 chamada** — pouca, e eu digo o número em vez de inflá-lo. O que a torna um pedido
não é o volume: é que **não há como escrever a segunda**. Todo padrão de *disclosure*, aba, alternar
e menu precisa de um `aria-*` de estado no elemento que tem o papel, e hoje a peça não tem por onde
recebê-lo.

## O que isso fez numa tela

`ExportarMenu` — o botão "Exportar" do extrato, que abre a lista de formatos. Ele é um *disclosure*:

```jsx
<BoldButton aria-haspopup="true" aria-expanded={aberto}>Exportar</BoldButton>
```

**Quem usa leitor de tela não sabe se o menu está aberto.** O botão anuncia "Exportar, botão" com a
lista aberta e com ela fechada, do mesmo jeito. É WCAG 4.1.2 (Name, Role, Value): o valor não chega.

## O que eu proponho, e a forma já é sua

Encaminhar os `aria-*` escritos no hospedeiro para o elemento interno que tem o papel, e **apagá-los
do hospedeiro** — a casca não deve anunciar nada, senão o leitor lê duas vezes.

É o que o `rotulo-acessivel` faz para um deles. A diferença é fazer por REGRA em vez de por campo:
um campo por atributo ARIA seria `rotulo-acessivel`, `expandido-acessivel`, `tem-menu-acessivel`, e
o vocabulário da linguagem passaria a espelhar o da norma, nome por nome.

Se você preferir campo nomeado — é a sua casa, e o `rotulo-acessivel` mostra que você prefere nomear
—, o que este repo precisa hoje são dois: **`expandido`** e **`tem-menu`**. Prefiro a regra, porque
o terceiro caso chega sem aviso; mas um pedido que exige a forma da resposta não é pedido.

**A armadilha que eu vejo**: encaminhar tudo às cegas levaria também `aria-label`, que agora tem dono
(`rotulo-acessivel`), e os dois brigariam. O `aria-label` precisa ficar de fora da regra, ou a regra
precisa ceder para o campo.

## O que eu NÃO estou pedindo

Não peço `role` no hospedeiro. Papel na casca com papel dentro é dois botões na árvore de
acessibilidade — o defeito que você recusou hoje, por escrito.

## Critérios que eu acho que decidem

**acessibilidade · escalabilidade.** Acessibilidade porque estado que não chega é estado que não
existe para quem ouve. Escalabilidade porque hoje é um `aria-expanded`, e o próximo padrão que
precisar de estado não tem por onde entrar.

---

## VEREDITO do pai — 2026-09-22 · `v0.207.0`

> Transcrito do ledger do pai (`ds-diletta/docs/PEDIDOS.md`) para a resposta morar junto da pergunta.

**ENTRA DIFERENTE — a REGRA, com lista nomeada, e não o campo.**

### O que decidiu
A sua frase sobre o número: *«o que a torna um pedido não é o volume: é que não há como escrever a
segunda».* Um pedido cujo argumento é *não há como escrever o segundo caso* está medindo vocabulário
faltando, e vocabulário não se mede por sítio. Uma chamada bastou.

E o que fechou: **você ofereceu a saída que eu preferiria — dois campos, `expandido` e `tem-menu` —
e argumentou contra a própria oferta**, com *«o terceiro caso chega sem aviso»*. Isso é
escalabilidade dita por quem perderia menos com a outra forma.

### O que eu achei indo implementar
**Isto corrige a minha v0.207.0, de ontem.** O `rotulo-acessivel` não estava errado: estava
incompleto. Eu tratei como caso o que era classe, e a prova é que a classe voltou em menos de 24
horas pela mão do mesmo filho.

A regra que fica, e que vale além deste atributo:

> **Campo nomeado para um membro de uma família é a forma que garante a segunda rodada.**

Então a fronteira passa a ser esta, e ela não é arbitrária: **nome continua campo** (é conteúdo, o
consumidor escreve a frase) e **estado passa a ser regra** (é da norma, e a norma é fechada —
`aria-expanded`, `aria-haspopup`, `aria-controls`, `aria-pressed`, `aria-describedby`, `aria-current`).
Entra a lista declarada, repassada ao elemento com papel e **apagada do hospedeiro**, como você
propôs. `aria-label` fica de fora por nome: tem dono desde ontem, e os dois brigariam — que é
exatamente a armadilha que você viu.

### O que eu recusei, e a condição de reabrir
- **encaminhamento cego de todo `aria-*`** — recusado pela sua armadilha. Reabre se a lista passar
  de uma dezena e virar manutenção: aí o certo é a regra com exclusão nomeada em vez de inclusão;
- **`role` no hospedeiro** — você não pediu, e confirmo a recusa de ontem: papel na casca com papel
  dentro são dois botões na árvore de acessibilidade.

### Os seis critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | uma regra contra N campos acrescentados ao longo do tempo |
| escalabilidade | ↑ | o próximo padrão ARIA entra sem tag nova |
| aplicação | ↑ | o `ExportarMenu` passa a anunciar aberto e fechado |
| aderência ao mercado | ↑ | WCAG 4.1.2 é a régua, e a lista é a da norma, não a minha |
| robustez | = | nem melhora nem piora o modo de falhar |
| arquitetura limpa e simples | ↑ | um mecanismo no lugar de uma família de campos espelhando a norma nome por nome |

### O que você faz
Quando a tag sair: suba o `ref:`, devolva o `ExportarMenu` ao `<diletta-button>` e continue
escrevendo `aria-expanded` e `aria-haspopup` **no hospedeiro** — é de lá que a regra os leva. O
`rotulo-acessivel` segue sendo o caminho do nome; não troque um pelo outro.
