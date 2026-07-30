# Pedido · a VOLTA não tem estrutura, só primitivos

- **filho**: conta-bold-ds
- **pai**: catalogo-diletta v0.28.0
- **é bloqueante?**: não. Escrevi o meu à mão e funciona — o pedido é sobre o segundo filho que
  vai escrever o mesmo à mão, e sobre o buraco que nenhum dos dois vê

## O que falta

O motor entrega os primitivos de leitura (`ehCtor`, `argString`, `argBool`, `membroDeEnum`…) e
não entrega a ESTRUTURA que os organiza. Então cada filho escreve a própria cadeia de `if`.

## A medição

| filho | entradas no leitor | forma |
|---|---|---|
| este | 15 | cadeia de `if` à mão |
| outro filho (li o repo dele pra medir) | **66** | cadeia de `if` à mão |

O motor não conhece componente do DS, e **não pode** — ele não depende do design system. Isso está
certo e não é o que eu peço. O mapa construtor → bloco é vocabulário, é meu, e o nome do bloco e
das props são escolha minha: `ds.DilettaButton` vira `botao` aqui e viraria outra coisa noutro
filho.

O que se repete não é o vocabulário, é a MECÂNICA:

```dart
if (ehCtor(expr, 'ds.DilettaButton') || ehCtor(expr, 'DilettaButton')) {
  return _mk('botao', {
    'label': argString(expr, 'label') ?? '',
    'larguraTotal': argBool(expr, 'fullWidth') ?? false,
  });
}
```

Cada bloco é a mesma forma: construtor (com e sem prefixo `ds.`), tipo, e uma lista de
`prop ← argumento, com tipo e default`. Oitenta e uma dessas, entre dois filhos, escritas na mão.

### O buraco que a falta de estrutura esconde

**Bloco declarado no registro e ausente no leitor não falha em lugar nenhum.** A tela abre, e ele
vira `cru` — aparece como se alguém tivesse escrito código à mão naquele ponto. Não há erro, não
há aviso, e o sintoma (um bloco cru inesperado) parece decisão de quem montou a tela.

Eu só descobri que os meus 15 estavam completos porque escrevi o gate: percorre o registro,
gera o `codegen` de cada bloco com os defaults, passa pelo leitor e exige o mesmo tipo de volta.
São 12 linhas, achou o meu buraco (zero, felizmente), e **todo filho vai reescrever essas 12
linhas** — ou não vai, e aí não tem gate.

## O que eu faço hoje sem isso, e o que isso me custa

O leitor à mão, com o gate à mão. Custo: 15 entradas hoje, e o produto tem 69 componentes pra
adotar — então a cadeia vai pra perto de 60. Cada componente novo é uma entrada a mais em DOIS
lugares (registro e leitor) sem nada ligando os dois além do gate que eu mesmo escrevi.

## Onde eu ACHO que mora

No motor — e o argumento mais forte não é meu, é o que você já escreveu no `NomesNoCodigo`:

> *"Strings e não funções de propósito: o motor mantém a FORMATAÇÃO porque isso é decisão do
> gerador; o DS só diz como suas peças se chamam. Knob de função aqui devolveria ao DS a
> responsabilidade de formatar código, e aí cada DS formataria diferente."*

O `BlockDef.codegen` é exatamente o knob de função que essa frase recusa, um nível abaixo: cada
filho escreve o próprio gerador de string por bloco. E o `leCodigoComoSpec` é o mesmo knob na volta.
Então hoje **cada filho formata diferente E lê diferente**, o que é o problema que a frase existe
pra impedir.

A saída que a sua própria regra sugere: o bloco declara a CORRESPONDÊNCIA, não o código.

```dart
BlockDef(
  type: 'botao',
  ctor: 'ds.DilettaButton',            // como a peça se chama
  args: {                              // prop ← argumento
    'label': Arg.texto('label'),
    'larguraTotal': Arg.bool('fullWidth'),
    'tipo': Arg.enumeracao('type', 'ds.DilettaButtonType'),
  },
)
```

Com isso o motor emite (mantendo indentação, ordem e quebras — decisão dele) e **lê de volta**, com
a mesma tabela. A volta deixa de ser artefato: ela é a ida invertida. E "cada filho lê de um jeito"
deixa de ser possível — todo filho lê do mesmo jeito, com vocabulário diferente.

Duas coisas que ficam de fora e devem ficar, senão isto vira motor que conhece produto:

- **bloco de forma irregular** continua com escape de função. O meu `barraDeBaixo` aninha
  (`BottomApp(button: NavigationButton(primary: NavigationAction(label:)))`) porque o rótulo mora
  três níveis abaixo — tabela declarativa não cobre isso, e forçar cobriria mal;
- **o nome do bloco e das props** seguem meus. É vocabulário, e é o que o pai não pode saber.

E o **gate** vem junto, senão a estrutura organiza o mapa e deixa aberto o buraco que ela deveria
fechar: bloco declarado sem leitura não falha em lugar nenhum.

### O que eu peço se a saída acima for caro demais

A versão menor: a estrutura declarativa só pra VOLTA (tabela `ctor → tipo + args`), mantendo o
`codegen` como está. Ganho parcial — a mecânica para de ser copiada, mas continuo declarando a
mesma correspondência em dois lugares, e a divergência entre ida e volta continua possível (só
detectável pelo gate).

A ressalva declarada: eu não sei o custo do caminho grande pro motor, e ele é uma quebra de formato
do `BlockDef` — o que pelo ADR-002 pede migrador.

## Como o pai vai saber que funcionou

Meu leitor encolhe (15 entradas viram 15 linhas de declaração), o gate sai do meu repo porque vem
do motor, e o teste que hoje é meu (`TODO bloco declarado tem entrada no leitor`) passa a ser da
conformidade. E o número que interessa: adicionar componente volta a mexer em um lugar, não dois.

---

## Veredito · ENTRA, e menor do que você pediu
**pai**: catalogo-diletta · **data**: 2026-07-30 · **critério que pesou**: manutenção

Saiu na v0.30.0: `BlockDef.ctor` + `BlockDef.args` com `Arg.texto/bool/numero/enumeracao`. O bloco
declara a correspondência, e o motor emite **e lê** com a mesma tabela.

**O argumento que decidiu foi o seu, e ele é o melhor que eu recebi até agora:** você citou uma frase
deste repo contra ele mesmo. `NomesNoCodigo` recusa knob de função *"porque aí cada DS formataria
diferente"*, e `BlockDef.codegen` é exatamente esse knob um nível abaixo, com `leCodigoComoSpec` sendo
ele na volta. Não havia como defender a assimetria depois disso.

**Menor do que você pediu, e a diferença é a sua ressalva caindo.** Você declarou que isto seria quebra
de formato do `BlockDef` e pediria migrador pelo ADR-002. Não pede: `ctor` e `args` são **opcionais** e
o `codegen` continua valendo. Bloco antigo não muda, e a forma irregular — o seu `barraDeBaixo` que
aninha três níveis — fica no `codegen` de propósito, que foi você mesmo quem propôs.

Então não é preciso escolher entre o caminho grande e o menor que você ofereceu no fim: o grande **é**
aditivo.

**O gate veio junto**, com a sua frase como razão: *"todo filho vai reescrever essas 12 linhas — ou não
vai, e aí não tem gate."* `bloco-sem-leitura` gera o código de cada bloco com os defaults, embrulha na
coluna do seu DS (o motor sabe o nome por `nomesNoCodigo.coluna`) e exige o mesmo tipo de volta.

### O seu gate achou três defeitos MEUS na primeira execução

Vale registrar, porque é o argumento a favor de gate vir do pai:

1. **`ehCtor` e `membroDeEnum` cravavam o prefixo `ds.`** — quem passasse o tipo já qualificado montava
   `ds.ds.X` e não casava nada, e código colado sem prefixo **nunca era lido**. Era isso que te obrigava
   a escrever o `if` duas vezes por bloco. Os dois primitivos agora aceitam as duas formas;
2. **a tabela não lia a própria emissão**: o motor emite `const ds.MeuBotao()` pra bloco literal e o
   `ehCtor` não tolerava o `const`. Defeito de meia hora de vida, achado pelo teste que existe pra isso;
3. **a minha regra chamava de incompleto quem estava completo**: `temTabela` exigia `args` não-vazio, e
   bloco sem prop nenhuma é legível só pelo construtor.

### Como chega

v0.30.0 · troque o `ref:` de `diletta_catalog_core`.

Migração das suas 15: declare `ctor` + `args` e **apague** o `codegen` e o `if` correspondente. Exemplo
com o seu próprio botão:

```dart
BlockDef(
  type: 'botao',
  ctor: 'ds.DilettaButton',
  args: {
    'label': Arg.texto('label'),
    'larguraTotal': Arg.bool('fullWidth'),
    'tipo': Arg.enumeracao('type', 'ds.DilettaButtonType'),
  },
  // codegen: continua obrigatório no contrato por compatibilidade, mas a tabela vence.
  codegen: (p) => '',
)
```

Duas medições que eu quero de volta: **quantas das 15 entradas sobraram** no seu leitor (a minha
expectativa é 1 ou 2, o `barraDeBaixo` entre elas), e se o `bloco-sem-leitura` acusa algo que você não
esperava. A segunda é a que interessa: se ele acusar zero, seu gate à mão estava certo e o meu só
mudou de dono.
