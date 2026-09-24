# RELEASE · o botão ganhou onde pôr o nome que o leitor de tela anuncia
**pai**: ds-diletta **v0.207.0** · irmã **web-v0.207.0** · **data**: 2026-09-21 · **para**: você

Um campo novo numa peça que você usa em todo lugar, e uma norma que veio junto.

## O que entrou

| lado | como |
|---|---|
| Dart | `DilettaButton.semanticLabel`, opcional, caindo no `label` quando ausente |
| web | `rotulo-acessivel`, virando `aria-label` no `<button>` **interno** |

O caso é **ação dentro de linha de lista**: o rótulo visível é curto de propósito («Remover»,
«Editar», «Ver»), e ele sozinho não distingue vinte linhas para quem ouve a tela em vez de vê-la.

```
rotulo="Remover"  rotulo-acessivel="Remover faixa 2"
```

A linguagem já tinha isso **na peça ao lado, e lá obrigatório** — o `DilettaIconButton` exige o nome
semântico porque sem texto não haveria nome nenhum. O botão com texto nunca ganhou o campo, e a razão
era entendível: ele *tem* nome. **Ter nome não é o mesmo que ter nome suficiente.**

## A condição, e ela é norma

**WCAG 2.2 §2.5.3 (*Label in Name*, nível A)**: o nome acessível tem que **conter** o texto visível.

- «Remover faixa 2» contém «Remover» → passa;
- «Excluir item» sobre um botão escrito «Remover» → **falha**, e quem usa comando de voz fica sem
  alcançar o botão: a pessoa fala o que **lê** na tela.

Isso virou `assert` no Dart, que some em release. A comparação ignora acento e caixa, porque a norma
fala de palavra e não de grafia.

## O que ele NÃO é

**Não é obrigatório**, ao contrário do botão de ícone. Nove em cada dez botões não precisam do
segundo nome, e obrigar faria a chamada repetir o rótulo — campo preenchido por obrigação vira ruído
com cara de cuidado.

E na web **não é o `aria-label` do hospedeiro**: quem tem papel de botão é o `<button>` dentro do
shadow, e o atributo de fora não o nomeia. Se você resolvia assim, o atributo estava sem efeito.

## O que você faz

Se você tem ação repetida em lista — e provavelmente tem —, esse é o campo. Se não tem, nada muda:
sem ele, o anúncio continua sendo o rótulo.
