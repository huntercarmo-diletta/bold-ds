# PEDIDO · O badge do SpotIcon não atravessa, e a web acaba marcando com tarja

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.194.3` · `web-v0.194.3`
- **bloqueante?**: **não** — o consumidor está com uma faixa local, na forma que você mesmo definiu
  para o `diletta-data-row`, e marcada como provisória apontando para cá.

## O caso

O Internet Banking marca notificação **não lida** com uma faixa vertical à esquerda da linha. Foi
assim porque não havia outra coisa disponível na web — e a resposta certa já existe do seu lado.

No app, uma notificação não lida é um **ponto no ícone**:

```dart
BoldLeftAccessory.spotIcon(icon: icon, tone: tone, badge: !n.lida)
```

E o comentário da tela mostra que o lugar do ponto é decisão tomada, não acaso:

> *A seta vai no canto INFERIOR direito porque o superior já é do dot de não-lida do próprio
> `BoldSpotIcon` — numa linha não lida os dois dividem o mesmo círculo de 38 px, e é esse o limite de
> quanta informação cabe ali.*

## O que existe no Flutter e não existe na web

`DilettaIconAccessory` declara o badge como **papel**, com quatro valores e a razão escrita:

```dart
enum DilettaBadge { none, primary, danger, secure }

/// O badge é PAPEL, não cor: "primary" quer dizer a cor de ação da marca, e é o
/// scheme que sabe qual é. Antes isto lia a primitiva do primeiro filho, então o dot
/// vinha azul-CPF em qualquer filho — e no escuro não clareava.
```

O `DilettaSpotIcon` passa esse badge adiante em três lugares do arquivo.

O elemento web, não:

```js
// diletta-spot-icon.js
static observedAttributes = ['type', 'state', 'forma', 'size', 'rotulo'];
```

**Cinco atributos, e badge não é um deles.** O recurso existe, é papel, foi pensado para mudar de cor
por scheme — e para no Dart.

## O pedido

`badge` como atributo do `<diletta-spot-icon>`, com os mesmos quatro valores do enum e a mesma
resolução por papel. Sem inventar nada: é a porta web de uma decisão que já é sua.

## O que fizemos enquanto isso, e por que não inventamos forma

A faixa local seguiu a **sua** forma, a do `diletta-data-row`:

```css
.tarja { position: absolute; inset: 2px auto 2px 0; width: 3px; border-radius: 999px; }
```

E foi você quem nos disse que a nossa estava errada, no `///` do mesmo arquivo:

> *A tarja é uma FAIXA e não uma borda: os papéis dela são da família Surface/Feedback, e borda
> esquerda de 4px arredondaria errado no canto.*

A nossa era exatamente `border-left: 4px`. O número que você cita como errado, pelo mecanismo que
você cita como errado — e achamos isso lendo o seu componente, não olhando a tela. Corrigido no
filho em 16/09.

Quando o badge atravessar, a notificação volta para o ponto no ícone, que é a resposta do app, e a
faixa fica só para o que ela é: **estado da linha** (aviso, erro, sucesso). Não lida não é estado da
linha — é outro eixo, e usar a tarja para ele foi acomodação, não decisão.
