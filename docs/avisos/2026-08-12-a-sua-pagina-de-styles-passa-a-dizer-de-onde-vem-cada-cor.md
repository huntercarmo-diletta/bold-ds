# RELEASE · a sua página de Styles passa a dizer DE ONDE VEM cada cor

- **pais**: `ds-diletta` **`v0.76.0`** (a cadeia como dado) + `catalogo-diletta` **`v0.104.0`** (a cadeia
  como página)
- **é bloqueante?**: **não.** Nada seu quebra, e a conformidade não cobra nada de quem não declarou
- **o que custa**: **cinco linhas**, uma vez, no fim do seu `_papeisDoBold()`

## A pergunta que a sua página fazia sem responder

Alguém abre Styles, vê `bg` com um hex ao lado, e não sabe **se pode trocá-lo**. Metade dos papéis é uma
entrada da sua paleta (troca a entrada e o papel segue) e a outra metade é uma conta do DS pai que existe
justamente pra ninguém escolher.

| natureza | o que é | quem pode mover |
|---|---|---|
| **alias** | o papel **é** uma entrada da sua paleta | **você** |
| **derivação** | o valor é **calculado** (contraste, fallback, alpha) | o **pai** |

> **Alias é porta, derivação é parede.** Mostrar as duas iguais convida alguém a trocar `white` esperando
> mover a tinta de `onPrimary`.

## O que você ganha declarando

- em **Styles**, dentro de cada célula de modo: um selo `alias`/`derivado` com o token ou a expressão. E
  como é **por modo**, aparece lado a lado que `fg` vem de `neutral01` no claro e de `neutral10` no escuro
  — o que mostra que **o modo escuro não é o claro invertido**;
- na **gramática** (a página das cinco camadas): a proporção, com o número de cada natureza. Ela é a
  informação, não a lista — um vocabulário em que quase tudo é derivado é um que você não consegue mover.

## As cinco linhas

O seu `p(...)` recebe VALORES, não o nome do papel, então mudar a assinatura dele custaria ~50 chamadas.
Não faça isso — o motor ganhou `comOrigem` pra a ligação ser uma passada no mapa já montado:

```dart
({String? alias, String? derivacao})? _o(String papel, {required bool escuro}) {
  final o = origemDoPapel(papel, escuro: escuro);   // vem do DS pai
  return o == null ? null : (alias: o.alias, derivacao: o.derivacao);
}

// no fim de _papeisDoBold(), no lugar do `return {...}`:
final base = {  /* o seu mapa de hoje, sem tocar em nada */ };
return base.map((papel, v) => MapEntry(
    papel, v.comOrigem(clara: _o(papel, escuro: false), escura: _o(papel, escuro: true))));
```

O adaptador de três linhas existe porque o registro do DS carrega o `papel` dentro e o do motor não — a
chave do mapa já é o papel, e guardá-lo duas vezes seria o segundo lugar que divergiria.

## E o que a conformidade passa a cobrar — só depois de você declarar

| regra | quando | por que é erro |
|---|---|---|
| `alias-fantasma` | o token nomeado não está em `estilos.cores` | a página mostraria uma origem que não existe |
| `alias-com-cor-outra` | o token existe e a cor **não bate** | **o pior dos dois**: a página fica plausível, alguém troca o token esperando mover o papel, e nada acontece |

O **alpha entra na comparação**: branco a 8% não é branco.

Se você declarar e alguma dessas aparecer, **provavelmente é achado seu e não erro de digitação** — quer
dizer que o `estilos.cores` e a paleta que o `Scheme` usa divergiram em algum ponto. Vale olhar antes de
assumir que foi a ligação.

## O que eu NÃO estou pedindo

- que você declare agora. **Papel sem `origem` não é violação de nada** — gate que exige declaração nova de
  quem estava certo é o gate que se aprende a ignorar, e a página já diz o que declarar quando está vazia;
- que você escreva a origem à mão. **Não escreva.** Origem escrita à mão é um segundo lugar dizendo o que a
  fábrica do tema já diz, e os dois divergem no primeiro conserto. O pai entrega pronto;
- nada sobre a camada de COMPONENTE. Ela é a próxima pergunta (o terceiro filho tem 196 slots aliasando
  papel), e não está decidida.

## Uma coisa que talvez interesse ao seu produto

Você é white-label. A proporção alias-vs-derivação é literalmente **o mapa do que um parceiro novo pode
mudar sem falar com ninguém** — e antes disso ela não estava escrita em lugar nenhum, nem no código.
