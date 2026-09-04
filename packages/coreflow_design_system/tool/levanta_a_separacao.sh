#!/usr/bin/env bash
# Levanta, arquivo a arquivo, o que em `lib/` ainda fala do Bold — a régua da separação
# descrita em `docs/2026-09-04-adr-o-coreflow-e-o-pai.md`.
#
# Saída: uma linha por arquivo com linhas, número de referências ao Bold, as classes que
# define e as duas referências mais frequentes. Zero na coluna `refs` é o que o pai
# precisa mostrar em TODO arquivo que ficar nele.
#
#   bash tool/levanta_a_separacao.sh            # tabela
#   bash tool/levanta_a_separacao.sh --total    # só o número
#
# Só `grep -E`, `awk` e `sort`: roda em qualquer máquina com o Flutter, sem ferramenta extra.
set -euo pipefail
cd "$(dirname "$0")/.."

# `vinho(Marca|Lavagem|Tinta)` SAIU da régua em 04/09, e a razão é medida: `vinhoTinta` e `vinhoLavagem`
# são CAMPOS do `CoreflowScheme` que o app lê (6 sítios de `.vinhoTinta`), e o esquema é forma que vai
# pro pai. Contar o nome do campo como referência ao Bold faria o gate do pai reprovar a API que o app
# consome. O que a régua ainda pega do vinho é `BoldVinho` — a casa dos três valores do Bold.
P='BoldColors|BoldPalette|BoldSeloQuantico|BoldSeloEstado|BoldFonts|BoldVinho|marcaDoBold|CoreflowProduto\.bold\b|Conta BOLD|hexesDaArte|assets/logos'

if [[ "${1:-}" == "--total" ]]; then
  (grep -rhoE "$P" lib || true) | wc -l | tr -d ' '
  exit 0
fi

printf "%-36s %6s %5s  %-44s %s\n" arquivo linhas refs classes amostra
find lib -name '*.dart' | sort | while read -r f; do
  n=$( (grep -oE "$P" "$f" || true) | wc -l | tr -d ' ')
  l=$(wc -l < "$f" | tr -d ' ')
  c=$( (grep -oE '^(abstract |sealed )?(class|enum|mixin) [A-Za-z_][A-Za-z0-9_]*' "$f" || true) | awk '{print $NF}' | head -3 | tr '\n' ',' | sed 's/,$//')
  s=$( (grep -oE "$P" "$f" || true) | sort | uniq -c | sort -rn | head -2 | awk '{printf "%s×%s ", $2, $1}')
  printf "%-36s %6s %5s  %-44s %s\n" "$(basename "$f")" "$l" "$n" "${c:0:44}" "$s"
done
