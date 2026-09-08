#!/usr/bin/env bash
# Levanta, arquivo a arquivo, o que em `lib/` ainda fala do Bold — a régua da separação
# descrita em `docs/2026-09-04-adr-o-coreflow-e-o-pai.md`.
#
# Saída: uma linha por arquivo com linhas, número de referências ao Bold, as classes que
# define e as duas referências mais frequentes. Zero na coluna `refs` é o que o pai
# precisa mostrar em TODO arquivo que ficar nele.
#
#   bash tool/levanta_a_separacao.sh            # tabela (refs de NOME e de VALOR por arquivo)
#   bash tool/levanta_a_separacao.sh --total    # só o número de NOME
#   bash tool/levanta_a_separacao.sh --valor    # só o número de VALOR
#
# DUAS colunas desde 08/09 (achado 3 do veredito do pai): a régua de NOME é uma lista de símbolos e
# fecha em zero com identidade que subiu como VALOR — degrau é número, hex é número, caminho é string.
# A coluna de VALOR conta, fora de comentário, hex cru (`0x` com 6-8 dígitos), `TextStyle(` cru e
# caminho `assets/`. No pai as duas têm que dar zero; no filho a de valor é onde a identidade nasce.
#
# Só `grep -E`, `awk` e `sort`: roda em qualquer máquina com o Flutter, sem ferramenta extra.
set -euo pipefail
cd "$(dirname "$0")/.."

# `vinho(Marca|Lavagem|Tinta)` SAIU da régua em 04/09, e a razão é medida: `vinhoTinta` e `vinhoLavagem`
# são CAMPOS do `CoreflowScheme` que o app lê (6 sítios de `.vinhoTinta`), e o esquema é forma que vai
# pro pai. Contar o nome do campo como referência ao Bold faria o gate do pai reprovar a API que o app
# consome. O que a régua ainda pega do vinho é `BoldVinho` — a casa dos três valores do Bold.
P='BoldColors|BoldPalette|BoldSeloQuantico|BoldSeloEstado|BoldFonts|BoldVinho|ContaBold|marcaDoBold|CoreflowProduto\.bold\b|Conta BOLD|hexesDaArte|assets/logos'

V='0x[0-9A-Fa-f]{6,8}|TextStyle\(|assets/'
semComentario() { grep -vE '^\s*//' "$1"; }
valor() { (semComentario "$1" | grep -oE "$V" || true) | wc -l | tr -d ' '; }

if [[ "${1:-}" == "--total" ]]; then
  (grep -rhoE "$P" lib || true) | wc -l | tr -d ' '
  exit 0
fi
if [[ "${1:-}" == "--valor" ]]; then
  t=0; while read -r f; do t=$((t + $(valor "$f"))); done < <(find lib -name '*.dart'); echo "$t"
  exit 0
fi

printf "%-36s %6s %5s %5s  %-44s %s\n" arquivo linhas refs valor classes amostra
find lib -name '*.dart' | sort | while read -r f; do
  n=$( (grep -oE "$P" "$f" || true) | wc -l | tr -d ' ')
  v=$(valor "$f")
  l=$(wc -l < "$f" | tr -d ' ')
  c=$( (grep -oE '^(abstract |sealed )?(class|enum|mixin) [A-Za-z_][A-Za-z0-9_]*' "$f" || true) | awk '{print $NF}' | head -3 | tr '\n' ',' | sed 's/,$//')
  s=$( (grep -oE "$P" "$f" || true) | sort | uniq -c | sort -rn | head -2 | awk '{printf "%s×%s ", $2, $1}')
  printf "%-36s %6s %5s %5s  %-44s %s\n" "$(basename "$f")" "$l" "$n" "$v" "${c:0:44}" "$s"
done
