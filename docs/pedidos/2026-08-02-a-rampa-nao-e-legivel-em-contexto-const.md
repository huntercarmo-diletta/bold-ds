# Pedido · a rampa não é legível em contexto `const`, e por isso o app do cliente CONTINUA com a cópia dela

- **filho**: conta-bold-ds v0.2.0
- **pai**: ds-diletta v0.24.0 (`DilettaPalette`)
- **é bloqueante?**: **não pra compilar, sim pra a adoção terminar.** É o único motivo pelo qual o app do
  Conta BOLD ainda declara 84 constantes de cor em vez de ler as suas

## O que falta

`DilettaPalette` é uma classe com campos de instância. A paleta do produto viaja como uma **instância
const** (`BoldPalette.bold`), e é assim que o pai quer — o filho fornece a paleta, o pai deriva os papéis.

Só que instância const não é o mesmo que constante:

```dart
class BoldColors {
  static const Color primary04 = BoldPalette.bold.primary04;
  //                             ^^^^^^^^^^^^^^^^^^^^^^^^^^
  // error • The property 'primary04' can't be accessed on the type 'DilettaPalette'
  //         in a constant expression • const_eval_property_access
}
```

Acesso a campo de instância **não é expressão constante em Dart**, mesmo quando a instância é `const`.
Então o app que quiser derivar a rampa tem duas saídas, e as duas são piores que copiar:

| saída | custo medido no `app-newbold` |
|---|---|
| trocar as 84 constantes por `static final` | quebra as **51 linhas** do app que usam cor em contexto `const` |
| escrever `BoldPalette.bold.primary04` em cada ponto | são **427 chamadas** de `BoldColors.X`, e nenhuma pode ser `const` depois |

## A medição, e ela é do app de verdade

Rodei a Fase A da adoção hoje. O espaçamento derivou sem uma queixa — porque `DilettaSpacing.s1` é
`static const double`:

```dart
static const double x1 = DilettaSpacing.s1;   // compila
static const Color primary04 = BoldPalette.bold.primary04;   // não compila
```

**A diferença entre os dois não é de desenho, é de forma de declaração.** O espaçamento é uma classe de
constantes estáticas; a paleta é um objeto. E o resultado é que o token que o produto MAIS usa é o único
que o consumidor não consegue derivar.

Estado hoje no app, depois da Fase A:

| token | deriva do pacote? | chamadas |
|---|---|---|
| `BoldSpace` | **sim**, degrau a degrau | 1269 |
| `BoldRadius` | **sim**, por valor | 91 |
| `BoldColors` | **não** — cópia, com teste comparando | 427 |

## O que eu fiz enquanto isso, e por que não resolve

Escrevi um gate no app (`test/a_rampa_bate_com_o_pacote_test.dart`) que compara os **40 degraus** da cópia
com `BoldPalette.bold` e falha na primeira divergência. Ele funciona: pegou os três degraus que o pacote
tinha consertado por AA e o app ainda não (`primary03`, `success03`, `warning02`).

Mas ele é remendo, e é honesto dizer por quê: **um gate que compara duas fontes não faz delas uma.** Ele
avisa quando divergem; ele não impede alguém de declarar um hex novo e nunca o pôr no mapa do teste. A
classe que ele deixa passar é exatamente a que a sua limpa persegue.

## O que eu peço

Que a rampa seja legível em contexto `const`. O desenho é seu; o que eu preciso é da propriedade, não da
forma. Duas que resolvem, e nenhuma exige mudar `DilettaPalette`:

1. **o filho declara a rampa em constantes estáticas** e a instância passa a ser montada a partir delas
   (`primary04: BoldPalette.primary04`). Isso eu faço aqui sem pedir nada — mas então **cada filho reinventa
   a convenção**, e o consumidor de dois produtos aprende dois jeitos;
2. **o pai dá a forma**: um mixin, uma convenção declarada no `AVISO`, ou o gerador que emite a classe de
   constantes a partir da instância. Aí a resposta é a mesma nos dois filhos.

Prefiro a 2 e não tenho apego. Se a sua leitura for que isso é do filho, eu declaro aqui e a resposta é
"NASCE NO FILHO" — o que eu não quero é os dois filhos resolvendo diferente, que é o sinal que você mesmo
nomeou: **duas pessoas resolvendo igual o mesmo problema é peça faltando; duas resolvendo diferente é pior,
porque nem sinal fica.**

## Critério de pronto

O app do Conta BOLD apaga as 84 constantes de `bold_colors.dart`, mantém as 51 linhas `const` como estão, e
o teste de rampa vira desnecessário — não porque alguém o apagou, porque **não há duas fontes pra
comparar**.

## Veredito · ENTRA COMO FORMA — a convenção é minha, e a Aurora passa a prová-la
**versão**: `ds-diletta` **v0.25.0** · **data**: 2026-08-02 · **critério que pesou**: aplicação

Você pediu a propriedade e não a forma, e a forma é a sua opção 1 — **com a diferença que muda tudo**:
ela deixa de ser sua e passa a ser a convenção do pai, escrita e provada. A sua frase é o motivo:

> *"O que eu não quero é os dois filhos resolvendo diferente, que é o sinal que você mesmo nomeou:
> duas pessoas resolvendo igual o mesmo problema é peça faltando; **duas resolvendo diferente é pior,
> porque nem sinal fica.**"*

### O que entrou

**1 · A regra, no `O-QUE-O-FILHO-FORNECE.md` (seção 1), onde o filho lê antes de escrever a paleta:**

> **A rampa é a fonte; a paleta é derivada dela.** Inverter compila igual e tira do consumidor a única
> forma de derivar sem copiar.

Com o seu custo medido junto, porque número convence e regra não: 84 constantes copiadas, 51 linhas
`const` que quebrariam, 427 chamadas que perderiam o `const`.

**2 · A Aurora convertida** — os **55 degraus** dela saíram de dentro do construtor e viraram
`AuroraColors`, com a paleta montada a partir deles. A Aurora é o critério de fechamento deste repo
(*"se ela compila, o contrato é verdade"*), e ela estava fazendo exatamente o que o seu app não podia
fazer.

**3 · O gate, e ele quase não tem corpo:** `rampa_legivel_em_const_test` declara

```dart
static const Color acao = AuroraColors.primary04;
static const BoxDecoration caixa = BoxDecoration(color: AuroraColors.primary08);
```

**A asserção é a COMPILAÇÃO.** Se alguém "simplificar" a Aurora de volta pro inline, o arquivo não
compila — e falhar em compilação é o mais alto que um gate falha. As igualdades contra
`AuroraPalette.aurora` são a segunda metade: elas provam que a paleta é a mesma coisa que a rampa, e
não uma cópia que combina por enquanto.

### Por que NÃO mexi no `DilettaPalette`

Nenhuma das saídas boas exige. Mixin não carrega `const` por produto; um gerador teria que ler o Dart do
filho; e mudar a classe pra estática mataria a coisa que a torna útil — **o filho tem a instância, o pai
tem o tipo**, e é isso que impede paleta de produto de morar aqui. O que faltava era **ordem de
declaração**, não tipo.

### O que você faz

Declare `BoldColors` com os degraus e monte `BoldPalette.bold` a partir dele. Aí o app apaga as 84, mantém
as 51 linhas `const`, e o `a_rampa_bate_com_o_pacote_test` **fica desnecessário pelo motivo certo** — não
porque alguém o apagou, porque não há duas fontes pra comparar. Era o seu critério de pronto, e ele é o
meu também.

### Uma coisa que eu devo registrar

Você escreveu o gate de comparação e disse na mesma linha por que ele não resolve: *"um gate que compara
duas fontes não faz delas uma."* É a frase mais curta que eu tenho pra distinguir remendo de conserto, e
ela vale além de cor — o `sem_drift_do_pai_test` do outro filho é a mesma classe, e continua sendo remendo
pelo mesmo motivo.
