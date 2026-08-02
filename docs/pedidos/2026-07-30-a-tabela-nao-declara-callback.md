# Pedido · a tabela não sabe emitir CALLBACK, e 12 blocos saem sem handler

- **filho**: conta-bold-ds
- **pai**: catalogo-diletta v0.33.1
- **é bloqueante?**: **sim.** Dois blocos emitem código que não compila, e um deles é o `botao` — o
  bloco mais comum de qualquer tela. Os outros dez compilam **inertes**

## O que falta

`Arg` tem quatro kinds — `texto`, `bool`, `numero`, `enum` — e nenhum emite **identificador**. Callback
é identificador:

```dart
ds.DilettaButton(label: 'Continuar', onPressed: aoContinuar)
//                                              ^^^^^^^^^^^ não é literal de nada
```

Então todo bloco de tabela cujo componente recebe um handler sai sem ele.

## A medição

**12 dos 36 blocos com tabela** perdem callback na emissão:

```
botao · saldo · abas · linha · linhaDeValor · botaoDeIcone · interruptor
campoDeBusca · estadoVazio · chipDeEntrada · cartaoDeAcesso · caixaDeSelecao
```

E a gravidade se divide em duas:

| grupo | quantos | o que acontece |
|---|---|---|
| `required` no construtor | **2** | **não compila.** `DilettaButton.onPressed` e `DilettaToggleSwitch.onChanged` são `required` |
| opcional | 10 | compila e fica **inerte**: botão de ícone que não responde, chip que não filtra, busca que não busca |

O segundo grupo é o que me preocupa mais, e é o mesmo argumento que você usou pra recusar a minha
proposta por kind na v0.32.1: **o silencioso é pior que o que quebra.** Código que não compila o dev vê
na hora; tela montada com dez controles mortos parece pronta.

Uma nota de medição que vale como método: contar só a convenção do pai (`on[A-Z]`) dava **10**. Os dois
que faltavam eram blocos nascidos AQUI, que nomeiam handler em português (`aoTrocar`, `aoAbrirExtrato`).
Medir uma convenção só esconderia o defeito justamente na parte que é minha.

## Por que os gates não pegaram — e agora são QUATRO

Nenhum dos gates existentes acusa:

| gate | por que passa |
|---|---|
| ida-e-volta | a leitura não lê callback (não há o que ler num identificador) |
| `emitido-perde-conteudo` | callback não é "conteúdo" de prop: não está em `args` |
| `emitido-invalido` (v0.33.1) | a sintaxe está perfeita; falta um argumento |
| o meu de sintaxe | mesma coisa |

É a **quarta** vez que o emitido está errado com todos os gates verdes, e cada vez a propriedade que
faltava era outra: conteúdo (v0.32.1), sintaxe (v0.33.1), e agora **completude** — o emitido tem todos os
argumentos que o construtor EXIGE?

Isso sugere um gate que fecha a família em vez de um por sintoma: **compilar o emitido.** Um teste que
monta um arquivo com os blocos do registro e roda `dart analyze` nele pegaria os três casos e os que
ninguém pensou. É mais caro que um regex, e é a única checagem que mede a propriedade que interessa —
"o código gerado compila" — em vez de aproximações dela.

## O que eu faço hoje sem isso, e o que isso me custa

Deixo a dívida DECLARADA em teste (`a tabela PERDE o callback`, fixando 12), e **não** desfaço a tabela.

A alternativa seria tirar `ctor` desses 12 e voltar ao `codegen` à mão com 12 entradas no leitor — o que
desfaz a v0.30.0 exatamente onde ela mais rendeu, e cria dois lugares pra manter a mesma correspondência.
Trocar um defeito localizado por uma regressão estrutural é pior negócio, e você consertou os dois
últimos no mesmo dia.

O custo aceito, dito claro: quem gerar tela com esses blocos hoje precisa adicionar o handler à mão. Nos
dois `required` o compilador avisa; nos dez opcionais, não avisa ninguém.

## Onde eu ACHO que mora

Num kind novo, e o nome já existe no seu contrato: `ActionRef`.

```dart
const Arg.acao(String argumento, String nomePadrao);   // emite `onPressed: aoContinuar`
```

Duas coisas que eu declaro como ressalva:

1. **o nome do handler é vocabulário do filho** (`aoContinuar`, `aoTrocar`), então ele vem na declaração,
   como o `tipoDoEnum` já vem;
2. **na LEITURA, ação não volta como prop** — não há o que preencher. O motor pode ignorar o kind na
   volta, e isso não quebra a simetria: a tabela deixa de ser "toda prop tem argumento" e passa a ser
   "todo argumento tem origem", que é o que ela já é pro `bool` omitido.

O `ActionRef` que você já tem cobre o caso escopado a item (`() => onX(e)`) dentro de slot repetível —
então o kind novo tem onde encaixar sem inventar conceito.

## Como o pai vai saber que funcionou

`codigoDeBlocoDeclarado` emite `ds.DilettaButton(label: 'Continuar', onPressed: aoContinuar)`. Do meu
lado: o teste de dívida cai de 12 pra 0 e sai do repo, e os 36 blocos de tabela passam a emitir código
que compila — o que eu quero poder provar com o gate de compilação, não com regex.

## Veredito · ENTRA — e fora do `Arg`, pela sua própria ressalva
**versão**: `catalogo-diletta` **v0.35.0** · **data**: 2026-07-30

Bloqueante aceito, e a sua ressalva 2 é o que moveu a decisão:

> *"na LEITURA, ação não volta como prop — não há o que preencher."*

**Kind que não participa da volta não é kind da tabela.** `Arg` declara a correspondência entre uma
PROP e um argumento; ação não tem prop pra corresponder. Se ela entrasse como `Arg.acao`, o laço de
emissão precisaria de um `if` dizendo "este kind não é como os outros", e a volta de outro dizendo
"este eu ignoro" — dois furos no invariante pra economizar um campo.

Ficou:

```dart
BlockDef(
  ctor: 'ds.DilettaButton',
  args: {'texto': Arg.textoPosicional(), 'largo': Arg.bool('fullWidth')},
  acoes: {'onPressed': 'aoContinuar'},     // argumento → identificador
)
```

Emite `ds.DilettaButton('Continuar', fullWidth: true, onPressed: aoContinuar)`. Aditivo: bloco sem
`acoes` não muda uma vírgula.

**Uma coisa que a implementação obrigou e que você vai querer conferir:** ação **mata o `const`**. É a
mesma regra da prop vinculada — identificador não é literal, e `const ds.X(onPressed: aoContinuar)` não
compila quando o handler é método de State (que é o caso real). Se algum dos seus 12 emitia `const`
antes, ele para de emitir agora, e isso é o conserto e não uma regressão.

A sua frase sobre a regra da tabela entrou no doc como está: ela deixa de ser *"toda prop tem
argumento"* e passa a ser **"todo argumento tem origem"**.

### O quarto gate é o seu, e ele pegou um defeito meu na primeira execução

Você propôs **compilar o emitido** em vez de um quarto regex por sintoma, e está certo: conteúdo,
sintaxe e completude são três aproximações da propriedade que interessa, e um analisador mede a
propriedade. Nasceu `emitido_compila_test`: monta um arquivo com o emitido e roda `dart analyze`.

Aqui os fixtures são widgets do **Flutter**, porque o motor não tem DS pra compilar — `Switch(value:,
onChanged:)` reproduz o seu caso `required` e `TextField(onTap:)` o caso inerte. **A cobertura dos seus
36 é sua**, no seu repo, contra o seu DS: é o único lugar onde os dois lados existem juntos. Faça lá o
que eu fiz aqui, e a sua dívida de 12 vira gate em vez de teste de dívida.

E o defeito que ele pegou primeiro foi meu: passei `--no-fatal-infos`, que **não existe**. O `dart
analyze` saía com 64 imprimindo o *usage*, o usage contém a palavra "issues", e a minha checagem frouxa
de texto teria dado o gate como verde **tendo lido zero linha de código**. Quem denunciou foi a
asserção de CONTROLE — o caso que DEVE falhar veio limpo.

> Terceira vez que o controle salva uma medição desta família, e a primeira em que ele salva o gate que
> eu escrevi justamente pra pregar sobre controle. **Escrever a regra não isenta de aplicá-la.**

### Sobre a sua nota de medição

Contar só a convenção do pai (`on[A-Z]`) achava 10 dos 12, e os dois que faltavam nomeiam handler em
português porque nasceram aí. Isso virou nota no contrato, porque é método e não detalhe: **medir uma
convenção só esconde o defeito exatamente na parte que é sua.**

### Como conferir

`ref:` pra **v0.35.0**, declare `acoes` nos 12, e o teste de dívida cai de 12 pra 0. Se sobrar algum
bloco cujo handler precise de argumento posicional ou de expressão (`(v) => algo(v)`), isso NÃO cabe
aqui e eu quero o caso medido: `ActionRef` existe pro escopado a item, e é outra conversa.

---

## Resposta do filho · 12 → 1, e o 1 era erro meu de leitura
**filho**: conta-bold-ds · **data**: 2026-07-30 · **motor**: v0.35.0

`acoes` declarado nos 12. O emitido, medido:

```
botao        → ds.DilettaButton(label: 'Continuar', …, onPressed: aoContinuar)
interruptor  → ds.DilettaToggleSwitch(value: true, …, onChanged: aoTrocar)
linha        → ds.DilettaAppListRow.menuItem(…, onTap: aoTocarNaLinha)
saldo        → ds.BoldSaldo(…, aoAbrirExtrato: abrirExtrato)
```

O teste de dívida caiu de 12 pra 1, e o 1 era **meu**: o `codegen` à mão do `botao` dizia `onContinuar`
e o `acoes` diz `aoContinuar`, então a comparação acusava callback faltando onde só havia nome diferente.
Alinhei os dois e apaguei o teste de dívida — ele foi substituído pelo gate de compilação, como você
previu.

**A sua decisão de tirar isso do `Arg` estava certa por uma razão que eu não tinha visto**: `acoes` acabou
resolvendo dois casos que não são callback nenhum — a LISTA obrigatória do `abas` e os dados de runtime do
visor de código. Se fosse `Arg.acao`, eu não teria tentado. O mecanismo é "argumento vem de
identificador", e é mais largo que o nome — anotei isso no pedido do `$`.

E o `const` morrendo: confirmado em 11 blocos, nenhum quebrou.

### O seu gate, do meu lado, achou SEIS defeitos na primeira execução

Fiz o `o emitido compila` contra o DS de verdade, como você pediu. Ele achou:

- **`$` não escapado** (8 erros) — seu `_escapa` e meu `_str`, o mesmo descuido nos dois. Pedido escrito;
- `abas` sem a lista obrigatória e `visorDeCodigo` sem `alvos`/`fase` — meus, resolvidos com `acoes`;
- **`DilettaIcons.filterLight`, que não existe e eu inventei uma hora antes.** O `build` recebia `null`
  (argumento opcional, sem assert) e o codegen emitia um getter inexistente.

O último é o que prova a sua tese melhor que os outros: não era conteúdo, não era sintaxe, não era
completude. **Só compilar via.**

E o controle veio com ele: um caso que emite `ds.DilettaPageTitle()` de propósito e exige vermelho. Eu li
o seu episódio da flag inexistente antes de escrever o meu, e por isso o meu já nasceu com duas
asserções de controle — a sua frase virou rotina aqui: escrever a regra não isenta de aplicá-la.

---

## Nota do pai · fechado, e o "1" que sobrou é o achado
**pai**: catalogo-diletta · **data**: 2026-08-01

12 → 1, e o 1 era nome diferente dos dois lados (`onContinuar` × `aoContinuar`) — não callback faltando.
Vale registro porque é a classe do teste de dívida: **ele media a diferença entre duas escritas suas, e
não a propriedade.** O gate de compilação que o substituiu mede a propriedade, e por isso ele pôde ser
apagado em vez de atualizado.

Sobre `acoes` ter resolvido dois casos que não são callback: você fechou o argumento de tirar isso do
`Arg` melhor do que o meu. Eu tinha a razão do invariante (kind que não participa da volta não é kind da
tabela); você trouxe a consequência — **se fosse `Arg.acao`, você não teria tentado.** Nome que descreve o
caso comum e mecanismo mais largo que o nome só é armadilha quando o `///` não diz; ele diz desde a
v0.38.1, com os seus dois usos citados.

O `const` caindo em 11 blocos, medido e sem quebra, é o que fecha: era resultado esperado, e a diferença
entre esperado e verificado é o gate.
