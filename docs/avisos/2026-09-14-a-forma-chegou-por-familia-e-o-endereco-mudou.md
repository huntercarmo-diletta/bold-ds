# RELEASE · a forma chegou por família — e o endereço que eu te dei hoje de manhã mudou
**pai**: ds-diletta **v0.194.0** · **data**: 2026-09-14 · **para**: você, e é a entrega do veredito de hoje

## O que declarar, e é uma tabela

```dart
DilettaTheme.resolve(
  palette: BoldColors.paleta.comMaterial(medidas: const {
    DilettaMedida.formaDeCartao: 24,
    DilettaMedida.formaDeVidro: 16,
    DilettaMedida.formaDeNav: 24,
    // e as três que você já declarava continuam valendo como estão
  }),
)
```

Seis papéis: `formaDeBotao · formaDeFolha · formaDeCampo · formaDeCartao · formaDeVidro · formaDeNav`.
Três getters novos no esquema — `formaDoCartao`, `formaDoVidro`, `formaDaNav` — e os três de sempre
passaram a ler a tabela antes do campo.

## RETIFICAÇÃO DO PAI, e ela é do mesmo dia: a tabela mora na PALETA, não no tema

No veredito de hoje eu te mandei declarar em `DilettaTheme.resolve(medidas: …)`. **Está errado, e o
erro apareceu na primeira linha de código que eu escrevi depois de assinar:** o `DilettaScheme` — quem
responde `formaDoBotao` e as irmãs — é construído a partir da PALETA e **não enxerga o tema**. Uma
tabela no tema seria uma tabela que a peça não alcança, que é literalmente o defeito que eu te escrevi
na nota do ciX quatro dias atrás: *eixo que a minha própria peça não lê não é eixo, é vocabulário*.

Então `DilettaPalette.medidas`, com um dono só, do lado de quem declara. `DilettaTheme.medidaDe(context,
…)` continua com a mesma assinatura — o que mudou foi de onde ele lê. **Você não escreveu nada ainda;
eu preferi mudar o endereço a te dar uma porta que não abre.**

## O que NÃO mudou, e é o item 4 do seu «não estou pedindo»

`null` desenha o que desenhava: botão pílula, folha 24, campo 16, cartão 24, vidro 16, nav 24. **Nenhum
produto existente move um pixel**, e há teste medindo os seis sem declaração e os seis declarados.

E o alias: com `raioDeBotao` e `formaDeBotao` declarados ao mesmo tempo, **a tabela ganha**. Não é
hierarquia por gosto — alias que vence a forma nova faz a migração andar pra trás.

## O que eu não entreguei, e está escrito pra você não medir de novo

**Os meus 86 sítios de raio em 58 componentes continuam cravados.** A família dá a porta ao produto; a
migração dos meus é ratchet meu, como o do tipo. Quando eu a fizer, um cartão seu e um `DilettaSurface`
meu lado a lado passam a concordar sozinhos — que é o defeito que você descreveu na saída 1 e a razão
de eu ter recusado que a família morasse do seu lado.

## O que eu preciso de você

1. **suba o `ref:` pra `v0.194.0`** — entre a sua `v0.193.0` e esta há uma `0.193.1` que não te cobra
   nada;
2. **declare as três e me diga o que sobrou cravado** dos seus 22 sítios. O número que sobrar é a
   próxima medição, e é ela que decide se falta família ou se falta eu migrar as minhas;
3. e o `CoreflowRadius.sheet` das suas cinco folhas **é seu e você já achou** — não espera nada de mim.

Sem prazo. Se a resposta for *"declarei e sobrou zero"*, isso fecha o fio e eu registro.
