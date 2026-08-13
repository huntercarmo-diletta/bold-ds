# RELEASE · duas peças que os DOIS DS declaram e a linguagem não tinha: abas e envio de arquivo

**de**: ds-diletta v0.87.0 · **para**: conta-bold-ds · **data**: 2026-08-12

## O que mudou

Cruzei os dois DS que esta linguagem serve — variáveis e componentes, por REST — e a interseção virou
regra: **o que está só num produto é inventário dele; o que está nos dois é o vocabulário da
categoria**, e a ausência aqui é dívida. De 216 nomes de componente cruzados sobraram cinco de dívida
real. Duas foram pagas nesta tag:

- **`DilettaTabs`** — as seções irmãs, com a régua fina embaixo de todas e a grossa na selecionada.
  `abas` é uma `List<String>`: o `Nº Tabs: 2…9` do Figma é a ferramenta enumerando combinação, não um
  eixo;
- **`DilettaUpload`** — envio de arquivo, com `arranjo: linha | area` (o `Upload-input` e o
  `Drop-file` são a mesma peça em duas arrumações) e cinco estados.

O desenho das duas **saiu do render**, não da lista de variantes — e foi olhando que apareceram duas
coisas que nenhum teste de contrato pega: uma régua com largura zero e o círculo de erro do
`DilettaSpotIcon` sem contorno, que as quatro telas de upload dos dois DS desenham com borda.
**`DilettaSpotIcon` com `type: outline, state: error` mudou de pixel** — é a única mudança visual em
peça que você já usa.

Razão inteira no [CHANGELOG](../../CHANGELOG.md) v0.87.0 e em `docs/O-CRUZAMENTO.md`.

## O que você faz

Nada obrigatório: é minor. Duas coisas valem o olhar quando você adotar:

1. se você desenha aba à mão em alguma tela, ela agora tem peça — e a peça vem com o estado
   desabilitado, que costuma faltar em aba feita na mão;
2. **confira o círculo de erro** nas telas que usam `DilettaSpotIcon(type: outline, state: error)`: ele
   ganhou o contorno vermelho que o seu Figma já desenhava.

## Como isso chega

troque o `ref:` pra v0.87.0

## Prazo

Sem prazo — minor. Se a mudança do círculo de erro não bater com o seu desenho, responda com o número
(qual tela, qual estado) antes da minha próxima tag, que é onde eu fecho o fio.
