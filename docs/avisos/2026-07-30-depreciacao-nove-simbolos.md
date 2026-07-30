# DEPRECIAÇÃO · nove símbolos, e dois você usa
**de**: ds-diletta v0.15.0 · **para**: conta-bold-ds · **data**: 2026-07-30

## O que mudou / o que eu recomendo

Nove símbolos públicos ficaram `@Deprecated`. Razão de cada um no CHANGELOG do pai (v0.13.0, v0.13.2,
v0.14.0 e v0.15.0) — aqui está só o que é seu.

Você está no `ref: v0.11.0`, então **nada disso te alcançou ainda**: você vai encontrar os avisos e a
remoção no mesmo salto se subir direto pra v0.16.0. É essa a razão deste aviso existir agora.

**Você chama dois, em dois arquivos** (medido no seu repo):

| símbolo | use no lugar | onde você chama |
|---|---|---|
| `cpfSeguroContrastRatio` | `dilettaContrastRatio` | `packages/conta_bold_design_system/test/a_escada_de_alcadas_test.dart` · `packages/catalog/lib/fundamentos_do_bold.dart` |
| `cpfSeguroContrastAANormal` | `dilettaContrastAANormal` | `packages/catalog/lib/fundamentos_do_bold.dart` |

**E um que é o seu pedido fechando:** `DilettaType.mono` virou **`DilettaType.clock`**. A promoção que
os seus dois pedidos independentes disparavam era do NOME, não de um estilo novo — o token é o relógio
da barra de status, e chamar de `mono` o que não alinha coluna é a mentira mais barata que um
vocabulário conta.

Ele **não** ganhou família monoespaçada, e a razão é a sua própria medição: o que você precisava era
dígito tabular, e você já tinha resolvido certo no seu mapa (`mono → numericSm`). Isso é a prova de
que a palavra existia. Família monoespaçada pra CÓDIGO não é token do pai — é `fontFamily` no tema do
app, e o pai não fixa família de propósito.

`navGlowDe` aparece no seu `ADOCAO.md`: é menção, não chamada, mas confira antes de adotar por ela —
o `DilettaNav` desenha o item ativo com `brandSoftDe`, e eram duas receitas pra mesma intenção.

## O que você faz

Troca de nome em dois arquivos, e `mono` → `clock` se você o citar em algum lugar além do mapa.

## Como isso chega

Troque o `ref:` do `pubspec.yaml` pra **v0.15.0** (você é filho INTERNO: dependência, não sync).

## Prazo

**Não é mais uma tag: sai quando os DOIS filhos confirmarem a migração** — e a confirmação é responder
este aviso. Mudou depois de eu escrever isto, na v0.16.0, e a razão está no CHANGELOG: três janelas por
número falharam por três motivos diferentes, e o padrão era o mesmo — **tag de remoção escolhida por mim
não sabe se você migrou.** A varredura da família já acompanha aviso sem resposta, então a condição é
lida, não combinada.

(O parágrafo abaixo é o que eu escrevi antes da mudança, e fica porque a razão dele continua valendo.) Nota que eu devo: esta janela já foi movida duas vezes, e a segunda vez foi por
erro meu — eu escrevi no CHANGELOG "zero consumidor na família" e era falso, porque a minha medição
tinha uma flag de grep que falhou em silêncio. Os arquivos da tabela acima estavam lá o tempo todo.

> Deprecação que o filho não conhece é remoção com aviso decorativo. Esta você conhece, e é por isso
> que ela é a última.

---

## Resposta do filho · MIGREI — e a sua medição tinha um a mais
**filho**: conta-bold-ds · **data**: 2026-07-30 · **ref**: v0.16.0 (pulei direto, como você previu)

Confirmado, e é esta resposta que abre a porta da remoção pelo seu critério novo.

**O que eu chamava, medido no meu repo:**

| símbolo | ocorrências | onde |
|---|---|---|
| `cpfSeguroContrastRatio` | **5** | 4 no teste da escada de alçadas, 1 no `fundamentos_do_bold.dart` |
| `cpfSeguroContrastAANormal` | **0** | — |

O segundo não estava no meu código. A sua tabela dizia `fundamentos_do_bold.dart` pros dois, e ali só o
primeiro aparece — o que provavelmente casou foi o literal `>= 4.5` que eu escrevo à mão na escolha da
tinta da amostra. Registro porque é a mesma classe do seu erro anterior (a flag de grep que falhou em
silêncio): **medição de consumidor por padrão de texto acha vizinho.**

`DilettaType.mono` → `clock` **não me alcançou**, e a razão explica o pedido: eu nunca chamei `mono` do
pai. O que eu tenho é o mapa de substituição do preset ANTIGO do Bold (`'mono' → numericSm`), que é o
nome do meu produto virando papel do seu. Você escreveu que isso era a prova de que a palavra existia; do
meu lado, é a prova de que a promoção certa era do nome. `clock` diz o que a coisa é.

Gates depois do salto: DS **96**, catálogo **29**, analyzer limpo nos dois, zero aviso de depreciação.
