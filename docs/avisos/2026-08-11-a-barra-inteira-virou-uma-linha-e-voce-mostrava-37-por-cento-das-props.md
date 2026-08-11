# RELEASE · a barra inteira virou uma linha, e o seu catálogo mostrava 37% das props

- **pai**: catalogo-diletta **v0.93.0**
- **é bloqueante?**: não. Nada do que você tem hoje mudou de comportamento. **Mas duas coisas suas
  ficaram redundantes e uma terceira era um buraco que ninguém tinha medido.**

## 1 · `abasDoMotor()` — a sua barra são 8 declarações e podia ser uma linha

O seu `main.dart` declara oito abas à mão. Seis delas são exatamente as de série, com **os mesmos ids**:

```dart
abas: [
  ...abasDoMotor(exceto: {'conformidade'}, medicoesDoFilho: const [PainelDeMedicao()]),
  AbaDoCatalogo(id: 'telas', label: 'Telas', constroi: (_) => HandoffLayout(…)),
  AbaDoCatalogo(id: 'adocao', label: 'Adoção', constroi: (_) => const AbaDeAdocao(inventario: inventarioDoBold)),
]
```

— ou, melhor ainda, **sem o `exceto`**: o `medicoesDoFilho:` já põe o seu `PainelDeMedicao` no rodapé da
Conformidade do motor, que é onde ele estava.

Os ids são os seus (`fundamentos`, `styles`, `componentes`, `specs`, `montar`, `conformidade`), então
**nenhum link salvo quebra.** A ordem do motor é a sua ordem de hoje — comparei linha por linha antes de
escolher a ordem da constante.

O que você ganha em não escrever a lista: quando o motor tiver a sétima aba, ela aparece no seu catálogo
no upgrade em vez de nascer fora da sua barra em silêncio. É a mesma razão do `derivadasJaDesenhadas` do
Foundations, e você já a aceitou uma vez.

## 2 · O seu `_AbaConformidade` agora é do motor

A checagem 8 da auditoria pegou: **você e o `exemplos/filho_minimo` desenhavam a mesma página**, cada um
a sua, contando as mesmas violações e pintando as mesmas duas cores. Duas implementações independentes
da mesma página é evidência de que ela é gramática — foi o mesmo argumento que trouxe Specs e
Componentes, e eu não achei razão pra não aplicá-lo contra mim.

> **Capacidade do pai que exige tela do filho não é capacidade entregue: é capacidade disponível.**

`AbaDeConformidade(extras: [...])`. O `extras` existe exatamente por causa do seu `PainelDeMedicao`: sem
ele, trazer a página te obrigaria a escolher entre perder a medição ou manter a tela à mão, e as duas
seriam respostas erradas. Ele vai **embaixo** das violações, porque a pergunta da aba é *"o pai ainda
cobra alguma coisa?"* e a sua medição responde outra.

Se você adotar, saem ~55 linhas do seu `main.dart` (`_AbaConformidade` + `_CardDeViolacao`).

## 3 · A tabela de VARIÁVEIS — e este é o item que muda o que o seu catálogo É

Fui atender um pedido do dono do produto (*"a aba de spec da CPF mostra as variáveis de um componente,
TODAS"*) achando que era a matriz de novo. Não era. Medi o seu registro:

| kind | quantas | a matriz desenha? |
|---|---|---|
| `text` | **91** | não |
| `enum` | 47 | **sim** |
| `bool` | 22 | **sim** |
| `number` | **13** | não |
| `multiline` | **11** | não |

`eixosDoBloco` pega enum e bool e mais nada, e a regra continua certa **pra matriz** — variar texto não
mostra variante, mostra texto. O efeito colateral é que ninguém tinha contado:

> **A matriz responde "como esta prop muda a peça?". Ela nunca respondeu "que props existem?" — e essa
> era a pergunta de quem vai INTEGRAR o componente, não de quem vai olhar pra ele.**

**Das suas 184 props, o catálogo mostrava 69.** Em 115 delas ele não dizia sequer que a variável existe,
e quem integra ia ler o `.dart` — que é exatamente o que o catálogo existe pra evitar.

`TabelaDeVariaveis` entra sozinha na sua aba de Componentes ao subir de versão: nome, tipo, valores,
default, com marca de `eixo` e de `bindable`. Nada a declarar.

**Confere uma coisa quando subir**: os defaults aparecem como texto, cortados em 60 caracteres. Se algum
`multiline` seu ficar ilegível na célula, é caso medido e eu quero o número.

## 4 · A FOLHA DE SPEC — a segunda vista da sua aba de Specs

A sua aba de Specs mede cobertura (o cruzamento contrato × bloco). A do outro filho é outra coisa: **todo
componente, de uma vez, por camada atômica**, com a matriz e as variáveis de cada um. É a página de
handoff, a que se rola inteira e se entrega. Lá ela tem 3.744 linhas escritas à mão.

Agora é uma pílula na aba que você já tem — `Cobertura` | `Folha de spec` — e ela se deriva do seu
registro. Duas vistas e não duas abas: a pergunta é a mesma e a diferença é a direção (a cobertura conta,
a folha mostra).

A matriz dentro dela continua sendo **por eixo**, com custo de soma. O produto cartesiano de quatro props
de cinco opções são 625 componentes renderizados numa página, e isso não muda por estar noutra vista.

## 5 · O índice de Foundations diz o que cada seção responde

Suas quatro derivadas diziam todas *"derivado do registro"*. Agora dizem `o que consome o quê · derivado`,
`o vocabulário do editor · derivado`, e assim por diante. Quatro itens com o mesmo subtítulo obrigam a
clicar nos quatro pra descobrir qual serve, que é o que o índice existia pra evitar.

## O que você faz

`ref: v0.93.0`. Os itens 3, 4 e 5 chegam sozinhos. Os itens 1 e 2 são adoção sua, e nenhum dos dois é
obrigatório — o formato longo continua valendo, e a regra 2 deste repo (*upgrade acrescenta, não
reorganiza*) segue de pé: eu não toco na barra que você declarou.

Se o `medicoesDoFilho` não couber no seu `PainelDeMedicao` por alguma razão que eu não vi daqui, me diz —
o slot é novo e nasceu medindo o seu caso, não um caso geral.
