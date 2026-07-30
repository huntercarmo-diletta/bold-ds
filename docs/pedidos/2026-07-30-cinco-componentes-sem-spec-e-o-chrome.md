# Pedido · cinco componentes que eu declaro não têm spec, e o gate cobra contrato de chrome

- **filho**: conta-bold-ds
- **pais**: ds-diletta v0.16.1 (as specs) · catalogo-diletta v0.36.0 (o gate)
- **é bloqueante?**: não. É baseline de 6 chaves, declarada e datada

## O que falta

A v0.36.0 trouxe `bloco-sem-contrato`, e ele está certo em cobrar: sem contrato a aba de componentes
desenha nome e matriz e para ali. Liguei o gancho `contratos` derivando o slug do construtor, e o gate
acusa **18 blocos**. Deles, **seis não são meus pra consertar**:

### 1 · Cinco componentes do pai sem spec no conjunto de 64

| meu bloco | componente | slug que eu tentei |
|---|---|---|
| `texto` | `DilettaText` | `design-system-text` |
| `icone` | `DilettaIcon` | `design-system-icon` |
| `ritmo` | `DilettaGap` | `design-system-gap` |
| `divisor` | `DilettaDivider` | `design-system-divider` |
| `ilustracao` | `DilettaIllustrationAccessory` | `design-system-illustration` |

Os cinco existem no pacote e não existem em `kDilettaSpecs`. As 64 specs cobrem 64 dos ~127 componentes
públicos, e a interseção com o que um filho declara como bloco não é aleatória: **texto, ícone, espaço e
divisor são a base de qualquer tela.** Estão entre os primeiros blocos que qualquer catálogo declara, e
são os que não têm dicionário.

Não é urgente — o cabeçalho degrada pro nome, como você desenhou. Mas se a régua é "guideline é parte do
contrato do componente", então componente sem spec é componente sem contrato, e esses cinco são os mais
usados de todos.

### 2 · O gate cobra contrato de CHROME DE APARELHO

`barraDeStatus` é `tiposDeChromeDeDispositivo`: por contrato **não emite código** e não entra em tela
montada. Cobrar contrato dele é pedir dicionário pra coisa que não é vocabulário de tela.

E isto é a **segunda vez** que a mesma classe aparece: o `bloco-sem-leitura` da v0.30.0 também mandava
chrome de aparelho pra leitura, e você consertou dizendo *"gate que obriga todo filho a declarar baseline
pro que o contrato chama de legítimo é gate que ensina a ignorar baseline"*. A frase vale igual aqui.

## O que eu faço hoje sem isso, e o que isso me custa

Baseline de **6 chaves** (as cinco nominais mais a linha de resumo), declarada com o grupo de cada uma e
com teste anti-fantasma: item que deixa de acusar tem que sair da lista.

Os outros **12** são dívida minha e não entram em pedido nenhum: são os componentes NASCIDOS aqui, e o seu
`COMPONENTE-DO-FILHO.md` passou a pedir contrato como parte do mínimo na v0.16.1 — depois de eles nascerem.
Doze specs é trabalho de ciclo, e é meu.

## Uma nota sobre o gancho, que é elogio com medição

`contratos` sendo `tipo → markdown` (e não "o motor busca a spec") é o que me deixou derivar o mapa do
`ctor` em 20 linhas, e ainda declarar cinco exceções onde a convenção classe→slug não vale: a row e a
coleção do `app-list` compartilham UMA spec (correto — o contrato fala das duas juntas porque a coleção é
dona do separador), e dois blocos meus não têm `ctor` (o `barraDeBaixo` aninha três níveis; o
`indicadorDeHome` é chrome).

Se o motor buscasse a spec sozinho, essas cinco exceções seriam cinco `if` dentro dele — ou eu ficaria sem
elas.

## Como o pai vai saber que funcionou

As cinco specs existem em `kDilettaSpecs`, o `barraDeStatus` sai do gate, e a minha baseline cai de 6 pra
0 — sobrando só a dívida dos 12, que é minha e some quando eu escrever os contratos.
