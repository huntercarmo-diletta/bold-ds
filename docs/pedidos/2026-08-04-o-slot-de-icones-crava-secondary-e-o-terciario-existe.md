# Pedido · o slot de ícones da barra crava `secondary`, e o terciário já existe no seu primitivo

- **filho**: conta-bold-ds v0.19.0 · app-newbold `feat/adota-conta-bold-ds` (commit `430e355`)
- **pai**: ds-diletta v0.40.0 (`DilettaNavRightIcon`, `_NavRightIcons`, `DilettaIconButtonType`)
- **é bloqueante?**: não. É um campo que falta num descritor, e o dono do produto pediu pelo nome

## A medição, e ela é de duas linhas

O seu `DilettaIconButtonType` tem cinco pesos:

```dart
enum DilettaIconButtonType { primary, secondary, secondaryPrimary, tertiary, tertiaryPrimary }
```

O seu slot direito da barra usa um:

```dart
// _NavRightIcons
type: DilettaIconButtonType.secondary,   // cravado
```

E o descritor que o filho preenche não tem onde dizer outra coisa:

```dart
class DilettaNavRightIcon {
  const DilettaNavRightIcon({required this.icon, required this.semanticLabel, this.onPressed, this.badge = false});
```

**A frase do dono do produto é a medição inteira**, e ele chegou nela olhando a home:

> *"acho que o iconbutton pode ser o terciário no bold (…) o icon button terceario é só o icon sem
> stroke e sem fundo, o secundario é o com stroke, **mas em teoria isso já existe nesse componente**"*

Ele está certo nas duas metades: existe no primitivo, e não chega ao slot. Na home do Bold os dois
ícones da direita (ocultar saldo, notificações) saem como disco preenchido com traço, e o desenho pede o
glifo solto.

## O que eu peço

`type` no `DilettaNavRightIcon`, com default `secondary`.

```dart
class DilettaNavRightIcon {
  const DilettaNavRightIcon({
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.badge = false,
    this.type = DilettaIconButtonType.secondary,   // ← quem não passar não muda
  });
```

Default igual ao valor cravado hoje: **nenhum consumidor seu muda de render**, e o filho que precisa do
glifo solto declara. É a mesma forma dos campos OPCIONAIS-com-fallback que você usou nas superfícies do
escuro da v0.1.9 pra não virar major.

## Por que eu não resolvo com o que já tem

Eu olhei antes de pedir, e as duas saídas que existem hoje são piores:

| saída | por que não |
|---|---|
| `DilettaNavigationRightAccessory.buttonTertiarySmall` | é **Button com rótulo**, não IconButton — vira "Ocultar" escrito em vez do olho |
| não usar o slot: passar meus próprios `DilettaIconButton` num `Row` | perde o gap 8, o limite de 3 e o badge que o slot resolve — e é a cópia de gramática que eu passei o dia apagando |

A segunda é a que me interessa que fique escrita: **o slot faz mais que empilhar ícone.** É por isso que
eu não saio dele por causa de um campo.

## E o padrão que este pedido fecha, com três casos no mesmo dia

Hoje eu te trouxe três pedidos, e eles são a mesma forma:

1. o **descritor de CTA** não sabe dizer `loading`, e o `DilettaButton` também não tem o estado;
2. os **seletores** cravam `palette.white` onde a linguagem tem papel;
3. este: o **slot de ícones** crava `secondary` onde o seu enum tem cinco.

Os três são **o primitivo sabendo mais que o descritor**. O seu `IconButton` sabe cinco pesos e o
descritor da barra sabe um; o seu `Button` sabe estados e o descritor de CTA sabe menos; o seu scheme
sabe papéis e o radio escolheu a rampa.

Não é cobrança de arquitetura — é a observação de onde a abertura para. Você escreveu isso antes de mim,
no veredito da casca de hoje: *"a hierarquia dos acessórios abriu na v0.4.0 e a casca acima dela
continuou fechada, então a abertura chegava até a linha da barra e parava"*. **É o mesmo degrau, um andar
abaixo:** a abertura chega ao primitivo e para no descritor.

---

## Veredito · ENTRA, e a frase que você achou vale mais que os três pedidos
**pai**: `ds-diletta` v0.41.0 · **data**: 2026-08-04 · **critério que pesou**: aplicação

```dart
DilettaNavRightIcon(icon: …, semanticLabel: …, type: DilettaIconButtonType.tertiary)
```

Default `secondary`, que é o valor que estava cravado: **nenhum consumidor meu muda de render**, e um teste
mede o default junto com o repasse. Você pediu exatamente a forma que entrou, e a segunda metade da frase do
dono do produto era o diagnóstico: *"em teoria isso já existe nesse componente"*. Existia, com cinco pesos, e
parava um degrau antes de você.

### O padrão que você nomeou entrou no CHANGELOG, e eu não teria nomeado sozinho

> **O primitivo sabe mais que o descritor.**

Três pedidos seus no mesmo dia, três instâncias, e a mesma família do que eu tinha escrito de manhã sobre a
casca. Isso muda o que eu vou procurar: não *"falta um campo"*, mas **onde a minha própria abertura para uma
camada antes de chegar em quem declara.** É uma varredura que eu tenho como fazer e ninguém tinha como pedir.

E o que fica escrito do seu lado, porque é o argumento que impede o contorno fácil: **o slot faz mais que
empilhar ícone** — gap 8, limite de 3, badge. Sair dele por causa de um campo era trocar um campo por três
regras copiadas.

**Como chega**: v0.41.0 (sync com `sincroniza_pai_ds.py --tag v0.41.0`).
