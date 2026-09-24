# RELEASE · o logo ganhou par por brilho, a curva passou a viajar, e a `pagination` parou de herdar tipo
**pai**: ds-diletta **v0.196.0** · irmã **web-v0.196.0** · **data**: 2026-09-16 · **para**: você

Os seus dois pedidos entregues na mesma tag, e um terceiro que caiu junto. **Nenhum produto move um
pixel sem declarar**: os campos novos são nulos por default e a emissão de motion só acrescenta.

## 1 · O logo, e o que você não tinha pedido

```dart
DilettaBrand(
  pacote: 'coreflow_design_system',
  logo: 'assets/logos/logo.svg',
  logoEscuro: 'assets/logos/logo-negativo.svg',        // novo, null por default
  logoFullEscuro: 'assets/logos/logo-full-negativo.svg',
)
```

**Dois campos, e não a convenção de sufixo que você apostou.** A razão está no veredito e no `///`: a
convenção vale nas 27 ilustrações porque a arte é minha; o logo é seu, e derivar nome de arquivo na
sua casa é falha de asset em runtime, no escuro, calada.

**O que o seu pedido não pedia:** o `DilettaLogo` tinha dois caminhos de tinta e os dois pintavam.
Sem isso, o negativo entraria repintado com a cor do positivo e você teria dois arquivos com um
desenho só. **Par declarado desliga o `srcIn`**, e a ordem está escrita: `color:` da chamada vence a
marca, a marca vence o arquivo.

O gate `o_logo_tem_par_por_brilho_test` tem cinco casos, e um deles é o seu contorno: sem par, o
mesmo arquivo nos dois brilhos.

## 2 · As curvas, e o seu diagnóstico estava curto

As quatro `--cps-ease-*` e os seis contextos como par, emitidos de `tokens/motion.tokens.json`:

```css
--cps-ease-enter: cubic-bezier(0, 0, 0.58, 1);
--cps-motion-sheet-duration: var(--cps-duration-medium);
--cps-motion-sheet-ease: var(--cps-ease-enter);
```

Você escreveu que a transcrição do IB *acertou as curvas e errou os nomes*. **Fui conferir no SDK: ela
errou as duas.** Os seus `cubic-bezier(0.33, 1, 0.68, 1)` e `cubic-bezier(0.65, 0, 0.35, 1)` não são
nenhuma das quatro — são o `easeOutCubic` e o `easeInOutCubic` de uma tabela pública de easings, com
os mesmos nomes e outros números. **Transcrição à mão não erra só o rótulo: troca a fonte quando a
fonte não está emitida**, e é o argumento mais forte que o seu pedido tinha.

O Dart segue escrevendo `Curves.*`, e `a_curva_emitida_e_a_do_dart_test` mede a igualdade das duas
grafias — provado por mutação com o seu próprio valor errado.

## 3 · A `pagination` declara `labelMd`

Você trouxe o número que faltava — 12/500/0,5 — e ele **é um degrau meu**, campo por campo. A catraca
estava de pé porque a régua comparava a peça contra `caption` e contra um 12/700 que a escada não tem,
e nenhum dos dois é o degrau de um número clicável. **Nenhum degrau novo entrou**, e o ativo continua
se distinguindo por papel de cor. O ratchet de tipo da instância web desceu de 1 para **0**: a sua era
a última.

## O que você faz

`ref: v0.196.0` nos dois pubspecs e `#web-v0.196.0` no `package.json`. Depois:

- declare o par de logo na marca do produto e no `CoreflowGramatica`, se o cliente mandar os dois
  arquivos — e o Berço pode oferecer o segundo envio na etapa 1, que é o que você desenhou;
- apague os dois tokens de curva do IB e aponte para `--cps-ease-*`. As suas duas entradas sem destino
  de linguagem fecham, e o seu critério de pronto (zero de 133) é o gate;
- adote a `diletta-pagination` sem escolher degrau: ela declara o dela agora.

E os cinco pedidos abertos foram julgados hoje, com a leitura pelos seis critérios em cada um. Os
blocos estão nos arquivos, do seu lado — o push deles é seu.
