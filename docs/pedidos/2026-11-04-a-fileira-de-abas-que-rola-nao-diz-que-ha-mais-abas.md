# PEDIDO · A fileira de abas que rola não diz que há mais abas, e a roda do mouse não chega nelas

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.26.0` · `web-v3.26.0`, pela `web-v0.129.0` deste repo. É o que o Internet Banking `core-flow-ib` recebe na PR #406
- **bloqueante?**: não. O IB fica com o menu dos estados que está no ar desde 28/10, e a mudança que o tira (`14440ce6`, branch local `fix/pagamentos-abas-que-rolam`, que cumpre o «O que você faz» do veredito de 30/10) espera este pedido
- **irmão**: `2026-10-28-a-aba-da-web-quebra-o-rotulo-e-a-fileira-nao-rola.md`, que entrou na `v3.26.0`. A fileira passou a rolar. Este pedido é sobre quem não vê que ela rola e não consegue rolá-la

## Falta

Quando a fileira rola, nada na tela diz que há abas fora da parte à vista. A roda comum do mouse também não move a fileira. Quem usa mouse só alcança as abas escondidas pelo teclado, pela lateral do trackpad ou por um gesto que ninguém vê.

## Número

**No IB, «Pagamentos por estado»:** são sete abas, «Todos», «Sem a sua assinatura · 3», «Aguardando outros · 1», «Agendados · 4», «Pagos», «Falharam · 1» e «Cancelados». A medida é de 04/11, no Chrome instalado, com a `web-v0.129.0` e sem o menu dos estados:

| tela | largura da fileira | quanto ela rola | o que fica fora, sem sinal |
|---|--:|--:|---|
| 768 | 720 | 197 px | «Falharam · 1» e «Cancelados» |
| 1024 (com o menu lateral) | 712 | 205 px | «Falharam · 1» e «Cancelados» |
| 1280 (com o menu lateral) | 968 | 0 | nada |
| 1366 (com o menu lateral) | 1054 | 0 | nada |

Nas larguras de notebook, as duas abas escondidas são justamente as que dizem o que deu errado.

**O que o mouse faz com a fileira.** Medi com o ponteiro sobre uma aba, a página no topo e a fileira em 0, nas duas larguras que rolam:

| gesto | a fileira | a página |
|---|---|---|
| roda comum (vertical, 300) | fica em 0 | rola 300 px |
| roda lateral, como a do trackpad (300) | vai ao fim (197 e 205) | fica |
| setas e Home/End, com o foco numa aba | traz a selecionada à vista (o `scrollLeft` de 30/10) | fica |

## Já tentei

- **O menu dos estados, que está no ar.** É um `BoldMenu` em forma de botão abaixo de 62rem de área. Resolve, mas é o que o veredito de 30/10 mandou tirar: «Tire o `BoldMenu` de `PagamentosScreen.tsx`». Fica de pé até aqui.
- **Tirar o menu**, que é a mudança guardada. O e2e dela passa: as sete abas numa linha em toda largura, e a fileira rola em 342 px. Mas, no Chrome, em 1024 px a fileira termina em «Pagos», e a roda rola a página.
- **Mostrar a barra por fora.** O `.trilho` não tem `part`, e a barra está escondida dos dois jeitos, dentro do shadow (`scrollbar-width: none` e `::-webkit-scrollbar { display: none }`).
- **Esmaecer a borda por fora**, com uma máscara no hospedeiro. Quem consome não sabe quando a fileira passa da caixa nem para que lado: a peça não diz.
- **Converter a roda em rolagem lateral no IB**, com um ouvinte de `wheel` no hospedeiro. Não fiz. Seria consertar o comportamento da peça por fora, e o filho não conserta o pai localmente.

## Conferi no pai

- **`diletta-tabs.js` da `web-v3.26.0`:**
  - `:host { display: block; min-width: 0; }`;
  - `.trilho { display: flex; position: relative; overflow-x: auto; scrollbar-width: none; }`, mais `.trilho::-webkit-scrollbar { display: none; }`;
  - `.aba` com `white-space: nowrap; flex-shrink: 0`;
  - `#trazAVista`, que mexe só no `scrollLeft`;
  - nenhuma `part` no trilho.
- **O comentário da peça** cita o `isScrollable` das abas do Material como a referência da fileira que rola.
- **A spec `design-system-tabs` da `main`** não tem requisito para a fileira que rola. O comportamento de 30/10 está no código e no veredito.
- **O e2e da varredura de 30/10** (`e2e/as_dividas_de_layout.spec.mjs`) mede «sete rótulos em 342 px, uma linha cada, a fileira rola e a página não». Ele mede que a fileira rola, e não que a pessoa consegue rolá-la.

## Derivável?

Não do que declaro. A peça não publica se a fileira passa da caixa, nem para que lado: não há atributo, evento ou `part`. Medir por fora exigiria ler o shadow dela.

## Se você disser não

O IB fica com o menu dos estados abaixo de 62rem de área, como está no ar, e a mudança que o tira não sobe. O custo é ter dois controles para a mesma escolha, e o «O que você faz» do veredito de 30/10 fica sem cumprir. Outro filho que tiver uma fileira longa em notebook terá as abas escondidas sem saber.

## Não estou pedindo

1. **Uma forma específica.** Pode ser seta nas pontas, borda esmaecida, barra visível ou um menu com as que não cabem. O mercado tem as quatro: os botões de rolagem das abas do MUI e o menu de «mais» do Polaris são dois exemplos. A escolha é da linguagem.
2. **Voltar a quebrar ou encolher o rótulo.** O veredito de 30/10 fica.
3. **Mudar o toque.** No celular o dedo arrasta a fileira, e em 390 px ela já faz o certo, inclusive trazendo a selecionada à vista.

## Como o pai vai saber que funcionou

No e2e do pai, um cenário com as sete abas do IB num hospedeiro de 712 px:
1. há um sinal visível de que existem abas à direita, e ele some quando a fileira chega ao fim e quando tudo cabe (por exemplo, em 1054 px);
2. só com o ponteiro, sem teclado e sem roda lateral, dá para trazer «Cancelados» à vista.

Do lado do IB, o e2e da mudança guardada ganha «em 1024 px, com o mouse, chega em Cancelados».

## Como cheguei aqui

Medido em 04/11, preparando a mudança que tira o menu, no Chrome instalado e pelo modo de demonstração do IB com a `web-v0.129.0`.
- **A roda comum e a lateral:** medidas pelo `mouse.wheel` do Playwright.
- **O Shift + roda:** não se mede assim, porque o evento sintético não passa pela conversão do sistema operacional. Não afirmo nada sobre ele.

## VEREDITO · ENTRA — seta sobre a borda esmaecida, só do lado que tem aba fora
**pai**: ds-diletta **v3.27.0** · `web-v3.27.0` · **data**: 2026-11-06

### O que decidiu
A forma foi do Hunter, entre as quatro que você listou: a seta do MUI (`scrollButtons="auto"`) sobre um esmaecido até
`surface`. Ela resolve os dois pontos do seu «Como o pai vai saber»: o sinal e o alcance só com o ponteiro.

### O que eu achei indo implementar
A spec `design-system-tabs` não tinha requisito para a fileira que rola, como você disse. Ganhou um, com o seu
cenário. E dois gates do pacote pegaram o meu primeiro CSS: o atalho `border:` e o `[hidden]` sem `!important`.

### O que eu recusei, e a condição de reabrir
- **a roda comum virar rolagem lateral.** A seta já dá o alcance, e o MUI não converte a roda. Reabre se o IB medir
  alguém que não acha a seta.
- **porta para o fundo do esmaecido.** Ele vai até `surface`. Reabre se a fileira morar sobre outro fundo e o
  esmaecido aparecer como bloco.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | o menu dos estados do IB sai |
| escalabilidade | ↑ | toda fileira web que rola recebe a seta |
| aplicação | ↑ | «Pagamentos por estado» do IB; adota o filho B |
| aderência ao mercado | ↑ | é o `scrollButtons="auto"` do MUI |
| robustez | ↑ | e2e em 712 e 1054, mais o jsdom |
| arquitetura limpa e simples | = | dois botões e um ouvinte na própria peça |
| conciso | = | um requisito na spec |

### O que você faz
`ref: web-v3.27.0`. A seta só aparece quando a fileira rola, então nada muda em fileira que cabe. Depois disso a
`14440ce6` pode subir sem o menu, e o e2e de 1024 px chega em «Cancelados» pela seta.

## ADENDO · 2026-11-11 — a fileira mora sobre outro fundo, e o esmaecido aparece como bloco; reabre a porta do fundo

**Onde:** `core-flow-ib`, PR `fix/ds-web-v0.130.0` (`ab896ae5`, 11/11), que sobe o pino para a `web-v0.130.0`
deste repo (avô `web-v3.27.0`). A peça chega pelo `BoldTabs`, que embrulha a `<diletta-tabs>`. Medido no mock
do IB, no Chrome, a 390 px, na marca BOLD, nos dois temas. O esmaecido que a peça pinta é
`linear-gradient(to left, <surface> 55%, transparent)`, com `surface` `#14151f` no escuro e `#ffffff` no claro.

**A medida.** O IB tem seis fileiras de abas. No telefone, duas rolam, e as duas moram sobre outro fundo:

| tela | fileira | quanto rola | fundo atrás da fileira | o que se vê |
|---|---|--:|---|---|
| Recebimentos | «Situação das cobranças» | 335 de 300 px | cartão translúcido (`rgba(22, 6, 10, 0.5)` no escuro), sobre a foto da marca | a seta num bloco, nos dois temas |
| Investimentos | «Investimentos» | 648 de 342 px | a própria página, sobre a foto da marca | a seta num bloco, nos dois temas |

As outras quatro não rolam a 390 px. «Notas ou contratos» (Antecipação) e «Ver por» (Risco sacado) moram em
cartão `surface`, onde o esmaecido se confunde com o fundo, como o veredito previu (no console, uma fileira
estreitada à mão num cartão `surface` confirmou isso nos dois temas). «Estados dos pagamentos» ainda está
atrás do menu dos estados. Quando a `14440ce6` subir sem o menu, ela vai rolar no telefone e no notebook até
1279 px (as medidas de 768 e 1024 estão no pedido, acima), também sobre a página. Pelo mesmo fundo, deve
mostrar o mesmo bloco.

**No `core-flow-wa`, com o mesmo pino:** a fileira das marcas de Ajustes › Botões mora sobre `background`
(`#0a0b12` no escuro, `#f4f3f6` no claro). Hoje ela não rola, porque só aparece com mais de uma marca.
Simulada com cinco marcas a 360 px, ela rola (442 de 336 px) e mostra o mesmo bloco.

**As imagens**, na pasta ao lado deste arquivo (`2026-11-04-a-fileira-de-abas-que-rola-nao-diz-que-ha-mais-abas/`):
- `ib-recebimentos-escuro.png` e `ib-recebimentos-claro.png`;
- `ib-investimentos-escuro.png` e `ib-investimentos-claro.png`;
- `console-marcas-escuro.png` e `console-marcas-claro.png`.

**O que reabre:** só a porta do fundo do esmaecido. A seta fica como está: o sinal e o alcance com o ponteiro
funcionam nas duas fileiras. A roda comum também fica de fora: não medimos ninguém que não achasse a seta.

**Não estou pedindo uma forma.** Duas que resolveriam:
- uma porta para a cor do esmaecido, que o hospedeiro declara;
- um esmaecido que não pinta cor nenhuma, como uma máscara no trilho, que vale sobre qualquer fundo,
  inclusive foto e cartão translúcido, sem o hospedeiro declarar nada.

**Se você disser não:** o IB sobe a seta assim mesmo, porque o sinal vale mais do que o bloco. O bloco fica em
Recebimentos e Investimentos no telefone e, depois da `14440ce6`, em Pagamentos no notebook. O filho não
remenda o esmaecido por fora.

**Como o pai vai saber que funcionou:** no e2e da fileira que rola, um hospedeiro com fundo diferente de
`surface`, por exemplo `background` ou uma imagem: o pixel da região do esmaecido, no fim da fileira, é o do
fundo do hospedeiro, e não `surface`, nos dois temas. Do lado do IB, Recebimentos e Investimentos a 390 px
sem o bloco.
