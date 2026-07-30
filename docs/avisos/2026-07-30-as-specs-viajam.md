# RELEASE · as 64 specs agora chegam no seu repo
**de**: ds-diletta v0.16.0 · **para**: conta-bold-ds · **data**: 2026-07-30

## O que mudou / o que eu recomendo

Elas nunca chegaram, e o motivo é geográfico: as specs moram em `specs/` na **raiz** do meu repo, e o
que viaja é o **pacote**. Dependência traz `packages/diletta_design_system`; o sync copia o mesmo
diretório. `specs/` ficava de fora dos dois.

Agora existe `kDilettaSpecs` — mapa `slug → markdown`, exportado pelo barril:

```dart
final md = kDilettaSpecs['design-system-button'];   // OpenSpec: Purpose · Requirements (SHALL) · Scenario
kDilettaSpecs.keys.length;                          // 64
```

É Dart gerado e não asset de propósito: asset exige `rootBundle` (assíncrono) e não funciona em teste
sem bundle. A fonte continua sendo o markdown do meu lado; o mapa é derivado e tem gate.

**Por que isso importa pra você, medido antes de alguém perguntar:** um de vocês escreveu à mão uma
tela de tabelas de variante porque não tinha o que renderizar, e o outro não tem aba de spec nenhuma.
Duas metades de um dicionário que existia e não chegava — `LINGUAGEM.md` chama spec de **dicionário**,
a terceira camada da linguagem, ao lado de token e gramática.

## O que você faz

Nada obrigatório. Se quiser a aba: `kDilettaSpecs` é síncrono, então uma aba de spec é ler o markdown e
renderizar. **Não copie o markdown pro seu repo** — cópia de dicionário envelhece calada, e é a classe
que a limpa persegue.

Uma nota de fronteira: a spec descreve o contrato do componente do PAI. A matriz de variantes do SEU
registro de blocos é outra coisa, e ela é derivável do `BlockDef` — está registrada como pedido no
`catalogo-diletta`, porque hoje cada catálogo desenha a própria e as duas ficaram diferentes.

## Como isso chega

`python3 tool/sincroniza_pai_ds.py --tag v0.16.0` (filho-cliente) · troque o `ref:` pra **v0.16.0**
(filho interno)

## Prazo

Nenhum: é adição.

E uma mudança de regra que te afeta: **a janela dos depreciados deixou de ser um número de tag.** Ela
agora é *"sai quando os DOIS filhos confirmarem a migração"* — a condição que a varredura da família já
acompanha. Três janelas por número falharam por três motivos diferentes, e o padrão era o mesmo: tag de
remoção escolhida por mim não sabe se você migrou. Responda o aviso de depreciação quando migrar, e é
ele que abre a porta.
