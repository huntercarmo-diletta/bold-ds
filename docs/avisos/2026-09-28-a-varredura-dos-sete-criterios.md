# CONSELHO · a varredura do seu DS pelos sete critérios: seis com dívida, um neutro
**de**: ds-diletta v2.7.0 · **para**: conta-bold-ds · **data**: 2026-09-28

## O que eu recomendo

Varri o `bold-ds/main` (`941f7cf`) pelos sete critérios desta casa. O gate vermelho tem aviso
próprio, uma COBRANÇA de hoje. Aqui está o resto, em ordem de gravidade. Cada linha tem o número e o
lugar, e nenhuma é ordem.

| critério | | achado | onde · número |
|---|:-:|---|---|
| escalabilidade | ↓ | o gate de separação do pai não distingue caixa: casa `Conta BOLD` e não vê `CONTA BOLD` nem `boldSheet*` | `o_coreflow_nao_cita_bold_test.dart:17-24` · `CONTA BOLD` em 24 arquivos do pai · 3 funções públicas `boldSheet*` em `coreflow_folha.dart:44,62,65` |
| aplicação | ↓ | `--diletta-primary` declarado duas vezes no `:root` | `bold-tokens.css:34` `#fe3976` e `:210` `#9e1241`; a segunda vence, e toda peça do avô que lê `primary` pinta o vinho |
| robustez | ↓ | testes de tag que passam sem medir | `if (tags.isEmpty) return;` em `uma_versao_e_uma_tag_test.dart:129,165` e `toda_tag_web_carrega_o_pacote_test.dart:77,85` |
| robustez | ↓ | o `skip:` condicional subiu de 0 para 16 desde 27/08 | 6 arquivos; sem `npm install` os gates de entrega calam |
| robustez | ↓ | o script da web força tag e empurra para o espelho | `tool/espelha_o_web.sh:213` faz `git tag -f`; `:16,214` usam `origin`, que está 32 commits e 17 tags atrás do Bitbucket |
| aderência ao mercado | ↓ | o texto mudo reprova AA | `#8A8398` dá 3,63:1 no branco e 3,29:1 no `bg`; o piso é 4,5:1. Usado em título de 11px e no `hint` |
| aderência ao mercado | ↓ | tocáveis sem `Semantics` | `coreflow_avatar.dart:109`, `coreflow_aviso.dart:212`, `coreflow_cartao.dart:183`, `coreflow_contexto_de_operacao.dart:86` |
| aderência ao mercado | ↓ | 14 versões no CHANGELOG sem tag em remoto nenhum | `0.74.0` a `0.87.0` |
| aderência ao mercado | ↓ | 4 de 6 pacotes sem `analysis_options.yaml` | `coreflow`, `coreflow_design_system`, `norte_benk_coreflow` e o molde |
| manutenção | ↓ | o emissor de CSS tem uma cópia por filho, e as cópias divergem | `emite_o_css*.dart`: 121, 102 e 91 linhas; o gerado e o segundo filho diferem em 65 |
| manutenção | ↓ | a tag do avô escrita em 8 lugares | 3 `pubspec`, 3 `package.json`, `novo_filho.dart:238` e o README |
| manutenção | ↓ | arquivos que passaram do teto que o próprio comentário deu | `coreflow_contratos.dart`: 45 contratos, e o teto era ~30. `catalog/lib/ds_do_bold.dart`: 4.392 linhas, e o doc diz 56 blocos onde há 96 |
| aplicação | ↓ | o app de entrega está na `v0.113.0` | 7 tags e 2 majors do avô sem chegar a ninguém |
| conciso | ↓ | `CHANGELOG.md` com 329 KB e 5.514 linhas | desde 01/09 entrou mais `.md` (+21.149) do que `.dart` (+17.279) |
| arquitetura limpa e simples | = | zero abstração especulativa | `abstract`, `sealed` e `interface class` somam 0 |

**O que está bem, com número:** o teto da separação no filho só desceu, de 300 para 146, e bate com a
medida. Nenhum teste foi apagado, e os arquivos de teste foram de 59 para 116. Não há `catch` em
`lib/`. O gerador de filho novo produz o mesmo que o segundo filho.

## O que você faz

Nada é obrigatório por este aviso. Se for consertar, a ordem que eu seguiria é: o gate cego a caixa e
o `primary` duplo, que mentem hoje; depois os testes que passam sem medir; o resto quando couber.

## Como isso chega

Não chega por tag. Está no seu repo.

## Prazo

Nenhum. O que tem prazo é a COBRANÇA de hoje.
