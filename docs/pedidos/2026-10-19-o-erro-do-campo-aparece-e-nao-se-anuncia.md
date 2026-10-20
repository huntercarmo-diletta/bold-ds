# PEDIDO · O erro do campo aparece e não se anuncia — quem não está no campo não fica sabendo

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.24.0` · `web-v3.24.0`, pela tag `web-v0.126.0` deste repo
- **bloqueante?**: **sim, para a troca** — o `BoldTextField` do IB anuncia o erro quando ele aparece, e trocar pelo `<diletta-input>` perderia o anúncio nos 24 usos que mostram erro
- **irmão**: `2026-10-16-enter-no-campo-nao-envia-o-formulario.md` (ENTRA na `v3.22.0`, que destravou o resto da troca) e `2026-10-15-o-titulo-do-estado-vazio-nao-e-cabecalho.md` (a mesma classe: o que o olho vê e quem ouve não recebe)

## Falta

Que o erro do `<diletta-input>` e do `<diletta-date-field>` se anuncie quando aparece ou muda, sem
depender de a pessoa voltar ao campo. Hoje o render escreve `<p class="erro">` sem `role` nem
`aria-live`: o erro fica ligado ao campo por `aria-describedby` e só é lido quando o foco chega nele.

## Número

**No avô, `web-v3.24.0`:** o parágrafo do erro é `<p class="erro" id="…-erro">`, sem `role="alert"` e
sem `aria-live`. No Dart, o `DilettaInput` escreve o erro no texto de baixo do campo, sem
`Semantics(liveRegion: true)`. Os dois lados se comportam igual: o erro é descrição, não aviso.

**No IB, medido em 19/10:** o `BoldTextField` escreve o erro com `role="alert"` desde a fundação.

| o que acontece quando o erro aparece | usos | quem fica sabendo hoje, sem `role="alert"` |
|---|--:|---|
| o envio leva o foco ao primeiro campo com erro: TED, interna e contato | 12 | quem usa leitor de tela: o foco chega no campo, e a descrição é lida |
| o erro aparece sem o foco se mover: validação ao sair do campo, recusa do servidor, campo que depende de outro, em nove telas | 12 | ninguém que não esteja olhando a tela |

Ao todo, 24 dos 79 usos do campo passam `error`.

## Já tentei

- **Anunciar por fora**, com uma região viva escondida no IB repetindo o texto do erro: funciona,
  mas é o mesmo texto em dois lugares, e cada filho escreve a sua. É a classe de remendo que as peças
  da linguagem existem para apagar.
- **Mover o foco para o campo em toda tela que mostra erro**: serve no envio, e é o que três telas
  fazem. Não serve ao erro que aparece enquanto a pessoa está em outro lugar da tela, e mover o foco
  sem ela pedir é pior.

## Conferi no pai

- WCAG 4.1.3 (Status Messages): a mensagem que aparece sem receber foco precisa ser determinável por
  papel ou propriedade, para que a tecnologia assistiva a anuncie. O erro que aparece fora do foco é
  esse caso. O 3.3.1 (Error Identification) o campo já cumpre, pelo texto e pela ligação.
- O título do estado vazio entrou pela mesma régua em 15/10: o que o olho vê, quem ouve precisa
  receber pelo mesmo caminho.

## Derivável?

Não: o parágrafo do erro mora no shadow.

## Se você disser não

O IB mantém o `BoldTextField` local, ou escreve a região viva por fora nos 24 usos com erro.

## Não estou pedindo

Anunciar a ajuda. Anunciar a cada tecla: só quando o erro aparece ou muda de texto. Mudar o desenho do
erro, a ligação por `aria-describedby` ou o `aria-invalid`.

## O que não medi

Não medi leitor de tela. Os números acima são do código e do que o padrão diz.

## Como o pai vai saber que funcionou

`<diletta-input>` sem `erro` → nenhum aviso. O consumidor escreve `erro="CPF incompleto"` com o foco em
outro lugar → a mensagem chega a quem ouve, uma vez. O mesmo texto escrito de novo não repete o aviso;
um texto novo avisa de novo. O mesmo no `<diletta-date-field>`, e no Dart o texto do erro com
`liveRegion`.

## VEREDITO · ENTRA — o erro se anuncia na vez em que o texto é novo

**pai**: ds-diletta **v3.24.2** · `web-v3.24.2` · **data**: 2026-10-20

### O que decidiu
*«Não serve ao erro que aparece enquanto a pessoa está em outro lugar da tela»*: é o caso da 4.1.3, e o defeito é meu.

### O que eu achei indo implementar
- O `<diletta-input>` se redesenha várias vezes ao nascer, e o campo de data recria o input a cada render. Um
  `role="alert"` só no primeiro desenho sumia no último. A memória do aviso mora na peça de fora e vale até a
  próxima microtask.
- O `<diletta-dropdown>` tinha o mesmo `<p class="erro">` mudo. Entrou junto.
- No Dart, a etiqueta escura pinta por outro caminho, e lá `error` dá 3,09 e `success` 4,41 na referência. Está
  no veredito da etiqueta.

### O que eu recusei, e a condição de reabrir
nada

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | a região viva do IB não precisa nascer |
| escalabilidade | ↑ | todo campo de todo filho anuncia |
| aplicação | ↑ | os 12 usos com erro fora do foco; adota o filho B |
| aderência ao mercado | ↑ | é o que a 4.1.3 pede |
| robustez | ↑ | gate nos três elementos web e no Dart |
| arquitetura limpa e simples | = | uma função em `base.js`, o Dart ganha um `Semantics` |
| conciso | ⊘ | a decisão não obriga a escrever nada |

### O que você faz
`ref: web-v3.24.2` e troque o `BoldTextField` pelo `<diletta-input>` nos 24 usos. Nada mais.
