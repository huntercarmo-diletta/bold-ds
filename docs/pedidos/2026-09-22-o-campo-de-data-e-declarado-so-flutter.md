# PEDIDO · O campo de DATA é declarado só Flutter — e na web ele sai mais barato

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.0`, pela tag `web-v0.114.0` deste repo
- **bloqueante?**: **não** — o consumidor tem `<input type="date">` cru e ele funciona. O
  que se perde é a tinta e a moldura: dois campos de data na mesma tela de dois campos de
  texto do DS, com aparências diferentes.

> **Nota de procedência.** Achado no **core-flow-wa** (o webadmin), fechando a adoção. Ao
> listar os 21 campos que ainda são crus, três tipos não tinham para onde ir —
> `date`, `color` e `range`. Este pedido é só do primeiro: é o único dos três que **já
> existe na linguagem**, e a pergunta da designer foi exatamente essa — «não sei se é um
> componente que existe na web».

## O caso, em uma linha

A peça existe, está especificada, e a spec diz que a web não a tem.

## O que a spec declara

```
design-system-date-field   destino = codigo
  «Contrato do DilettaDateField — a escolha de data: um DilettaInput readOnly +
   ícone de calendário que abre o DilettaCalendar num bottomsheet. Formata a
   data; o usuário não digita dd/mm/aaaa à mão.»

design-system-calendar     destino = codigo
  «Contrato do DilettaCalendar — o grid mensal de seleção de data (Flutter puro,
   sem lib externa). É o miolo aberto pelo DilettaDateField.»
```

E a legenda da própria spec: *«quais instâncias esta peça exige: `codigo` (Flutter),
`web`, `ambos`»*.

**Então isto NÃO é o caso do diálogo nem do dropdown.** Naqueles a spec dizia `ambos` e a
web não tinha a metade dela — era cobrança de emissão. Aqui houve uma decisão, e o pedido
é para revê-la: **`destino: codigo` → `ambos`**, nas duas peças.

## Por que na web ela é MAIS barata que no Flutter

O `///` do `<diletta-dropdown>` já estabeleceu o princípio desta casa, e ele se aplica
inteiro aqui:

> *«o `<select>` do sistema traz busca por digitação, rolagem com teclado e o painel do
> sistema operacional no celular — coisas que um dropdown desenhado à mão perde e quase
> nunca recupera»*

`<input type="date">` é o mesmo arranjo: o navegador entrega o calendário do sistema,
navegação por teclado, formatação por locale e o painel nativo no celular. É a instância
web de um contrato que já existe — não um componente novo.

A assimetria é o argumento: **o Flutter precisou construir o grid mensal à mão** («Flutter
puro, sem lib externa», diz o `///` do `DilettaCalendar`) porque lá não há controle de
plataforma. A web tem. A metade que falta é a fácil.

E o ADR-007 já cobre a diferença de mecanismo: «a spec é uma, o mecanismo de cada
plataforma é o dela — no Flutter o painel é uma folha, aqui é o controle do sistema».
O `DilettaCalendar` seguiria `destino: codigo` se a web usar o nativo; quem muda de
destino é o `date-field`.

## Onde isso dói, medido

No webadmin: **2 campos de data em 1 tela** (o recorte de período do histórico de
conversas). Não é volume — é a mesma razão do campo de seleção: vocabulário. Um produto da
família que precise de "escolha uma data" na web hoje escolhe entre o campo cru sem tinta
ou desenhar o seu.

Vale dizer o que NÃO pedimos: `color` e `range`, os outros dois tipos que ficaram sem
destino aqui, **não existem na linguagem em nenhum dos dois lados**. Esses continuam
nossos, e não viraram pedido — pedir vocabulário que ninguém especificou é diferente de
pedir a metade de um contrato que já está escrito.

## O que o consumidor está fazendo enquanto isso

`<input type="date">` cru, com a nossa moldura por cima. Funciona e é acessível; o que
não é é consistente — na mesma barra ele conviverá com um `<diletta-input>` de 48px e
raio 16, e a diferença aparece.
