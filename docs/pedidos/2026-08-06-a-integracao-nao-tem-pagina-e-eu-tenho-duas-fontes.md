# Pedido · a INTEGRAÇÃO não tem página no motor, e eu já tenho duas fontes medindo a mesma coisa

- **para**: `catalogo-diletta` (pai da FERRAMENTA)
- **de**: `conta-bold-ds` (filho B) · catálogo v0.14.1 · motor v0.85.1
- **data**: 2026-08-06

## O que falta

Uma aba/página do motor que responda **"quanto deste produto já é o DS, e o que ainda não é"** —
alimentada por dados que o consumidor declara, do mesmo jeito que `Ds.blocos`, `contratos` e
`conformidade` já são declarados hoje.

O catálogo tem sete abas e nenhuma delas responde isso. Fundamentos, Styles, Componentes, Montar,
Specs, Telas e Conformidade descrevem **o que o DS tem**. Nenhuma descreve **o que o produto
adotou** — e essa é a única pergunta que o dono do app faz toda semana.

## A medição — eu já tenho DUAS fontes, e é isso que faz o pedido

O inventário existe hoje em dois lugares, medido, e nenhum dos dois é tela:

| onde | o que mede | número de hoje |
|---|---|---|
| `conta-bold-ds` (este repo) | o catálogo/DS-filho contra o pai da linguagem | 56 blocos · 55 com contrato · 12 componentes nascidos aqui · 21 papéis lidos |
| `app-newbold` (o app do cliente) | o app contra o DS-filho | **409 arquivos · 38 peças do pai em 1.262 chamadas · 65 classes locais (16 casca, 49 privadas) · 0 mortas** |

O segundo saiu hoje, e ele é o caso novo: subi o pacote de `v0.21.0` pra `v0.25.6` no app depois de
alinhar 162 commits, e a primeira pergunta do dono foi *"como estamos na adoção?"*. Eu respondi com
uma varredura de shell e uma tabela escrita à mão. **Isso é o sintoma: a resposta existe, e ela não
tem casa.**

Já deixei do meu lado o que não depende de você: `docs/INTEGRACAO.md` no app com o bloco `medido` e
um gate (`test/a_adocao_do_ds_tem_numero_test.dart`) que recalcula os seis números e reprova se a
prosa divergir do código. **O gate é a fonte; falta a página.**

> **Dois consumidores, e a régua é sua**: *promove no caso medido, não no imaginado.* O primeiro é
> este catálogo, o segundo é o app — e os dois querem a MESMA leitura com dados diferentes. Se a
> conta de filhos ainda for de um, o pedido continua valendo pelo bloqueio: sem a página, cada
> consumidor escreve a sua, e aí a família tem duas definições de "adotado".

## Onde eu ACHO que mora

No motor, como aba declarada — e o dado vem do consumidor, porque só ele sabe o que é dele:

```dart
AbaDeIntegracao(
  // o que o consumidor JÁ usa do DS, e quanto
  pecasDoDs: {'DilettaAppListRow': 190, 'DilettaIcon': 39, ...},
  // o que ele ainda desenha em casa, com o alcance de cada uma
  proprias: [
    PecaPropria(nome: 'BoldButton', arquivos: 50, temParNoDs: true),
    PecaPropria(nome: 'BoldToast', arquivos: 79, temParNoDs: false),
  ],
  // e o que é DELIBERADO, com a razão escrita — senão a lista de exceção cresce em silêncio
  excecoes: {'QuantumSeal': 'narrativa de marca, veredito do dono 29/07'},
)
```

Três leituras que eu quero da página, na ordem em que elas decidem algo:

1. **a FILA por alcance**, e com a coluna *tem par no DS?* — porque ela é o que ordena o trabalho.
   Peça com par é adoção; peça sem par é pedido ao pai primeiro, e pedido tem outro tempo. Hoje eu
   ordeno isso à mão e o critério não fica escrito em lugar nenhum;
2. **a diferença entre CASCA e PRIVADA**. Casca (o arquivo do app importa o pacote e delega) parece
   dívida numa contagem crua e é o oposto: é a peça que faz a próxima mudança do pai chegar em 87
   arquivos sem tocar em nenhum. Sem essa coluna, todo relatório de adoção subestima o que já foi
   feito e o dono cobra o que já está pago;
3. **zero peça MORTA como asserção**, não como observação. Classe sem consumidor mente duas vezes:
   no inventário (parece dívida ativa) e pra quem vai escrever tela nova, que acha o widget do app
   vivo e usa — e aí a adoção anda pra trás sem commit que diga isso. Achei **8** hoje no app e
   apaguei; nenhuma tinha teste, nenhuma tinha consumidor, e todas compilavam.

## O que eu faço hoje sem isso, e o que isso me custa

Tabela markdown escrita à mão + um gate que a confere. Funciona pra mim e não escala pra família:
o próximo filho vai escrever a dele com outras seis chaves, e aí "adotado" quer dizer duas coisas.
O custo não é o meu trabalho — é a **incomparabilidade** entre filhos, que é justamente o que uma
ferramenta central existe pra impedir.

## Como o pai vai saber que funcionou

Quando o dono do app abrir a aba e não me perguntar mais "como estamos na adoção?" — e quando o
número que ele vê ali for o mesmo que o `flutter test` do app cobra. **Uma fonte, duas telas.**

## E uma coisa que NÃO é pedido

Não estou pedindo que o motor MEÇA o consumidor. Varrer a fonte do app é trabalho do app: quem sabe
o que é `design_system/` do produto é o produto. O que eu peço é o **contrato de declaração e a
tela** — o mesmo desenho de `Ds.blocos`, onde o consumidor declara e o motor desenha.
