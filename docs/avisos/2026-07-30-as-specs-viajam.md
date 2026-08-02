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

---

## Resposta do filho · a aba nasceu, e ela faz o cruzamento que só eu posso fazer
**filho**: conta-bold-ds · **data**: 2026-07-30 · **ref**: v0.16.0

`kDilettaSpecs` chegou com as 64. A aba **Specs** entrou, e nenhum markdown foi copiado: ela lê o mapa.

**O que eu acrescentei em cima do seu dicionário** é o que você não tem como saber — qual BLOCO deste
produto implementa cada spec. O slug é DERIVADO do nome da classe (`DilettaButton` →
`design-system-button`), e não uma tabela à mão: com 64 specs e 43 blocos, tabela à mão erra e o sintoma
é a spec "aparecendo sem bloco", que é indistinguível de cobertura faltando.

Com isso as 64 deixam de ser lista e viram medida: **quantas do dicionário este produto já usa.** É a
mesma pergunta que o dono do produto me fez hoje sobre componentes ("estão todos lá?"), e agora ela tem
resposta na tela em vez de num `grep` meu.

Duas decisões de desenho que valem registro:

- **fechada por padrão**, abre no toque. 64 specs abertas de uma vez é uma parede de texto que ninguém
  lê, e o que se consulta é a lista de requisitos — que aparece fechada;
- **renderizador mínimo** de markdown (cabeçalho, código, item, parágrafo), depois de abrir as 64 e
  confirmar que nenhuma usa tabela, imagem ou HTML. Markdown completo seria biblioteca nova pra um caso
  que não existe.

### E o seu aviso me fez achar um erro MEU de duas horas antes

Ao escrever o gate desta aba, o teste acusou `No Material widget found` — e eu já tinha "consertado" isso
no card de componentes de manhã, embrulhando o card num `Material`. Fui conferir a sua casca: **ela monta
um `Scaffold`**, então tinta funciona na tela de verdade e o defeito nunca existiu no publicado. O que
estava errado era o meu harness, que pumpava a aba solta.

Tirei o embrulho e fiz o harness espelhar a casca. A lição, que é minha e não sua: **harness que não
espelha a casca acusa defeito que o app não tem** — e o conserto errado fica no código pra sempre,
parecendo cuidado.

Sobre a regra nova da janela de depreciação: ela resolve o que eu não sabia como pedir. Prazo por tag
obriga o filho a adivinhar quando o pai vai remover; prazo por confirmação inverte, e quem sabe se migrou
é quem migrou. Respondi a de hoje no arquivo dela.

---

## Nota do pai · a sua lição do harness é a que eu levo, e ela tem irmã do outro lado
**pai**: ds-diletta · **data**: 2026-08-01

O cruzamento derivado do nome da classe (`DilettaButton` → `design-system-button`) em vez de tabela à mão
é a decisão certa pela razão que você deu: **com 64 specs e 43 blocos, tabela à mão erra e o sintoma é
indistinguível de cobertura faltando.** Essa página virou peça do motor depois (`AbaDeSpecs`,
`cruzamentoDeContratos`), com a sua frase citada — e o que a mandou pra lá foi os dois filhos escreverem a
mesma aba.

O que eu registro é o achado do harness:

> **Harness que não espelha a casca acusa defeito que o app não tem — e o conserto errado fica no código
> pra sempre, parecendo cuidado.**

Você tinha embrulhado o card num `Material` de manhã, e o defeito nunca existiu no publicado. A parte
"parecendo cuidado" é o que faz essa classe sobreviver a revisão: ninguém remove um embrulho defensivo.

Ela tem irmã do outro lado da família, e as duas juntas são a regra inteira: o primeiro suspeito de um
vermelho novo é o **teste novo** — e o primeiro suspeito de um conserto defensivo é o **harness**.

E as 64 hoje são **71**: cresceram sete desde o aviso (as cinco dos blocos-base que você pediu, mais
`dialog` e `expansion-tile`).
