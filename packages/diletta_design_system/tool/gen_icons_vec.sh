#!/usr/bin/env bash
# Gera os ícones pré-compilados (.vec) a partir do source SVG.
#
# Source of truth = svg_src/icons/*.svg (NÃO vai no bundle).
# Saída = assets/icons/*.svg.vec (binário vector_graphics, ESSE vai no bundle).
#
# Os .vec são commitados: o build web não roda dart, então regenerar e commitar
# é obrigatório.
#
#   ./tool/gen_icons_vec.sh
#
# DÍVIDA DECLARADA (2026-07-29, achada respondendo um pedido de ícone novo):
# só as fontes dos ícones NASCIDOS aqui moram aqui. As 354 originais estão em
# `cpf_seguro_design_system/svg_src/icons` do PRIMEIRO FILHO — o pai ship o
# binário e não tem como regerar o próprio vocabulário. Isso é o pai dependendo
# da ferramenta de um filho, e é o inverso da regra de conhecimento. Mover as
# 354 pra cá é item do pai, não do filho.
set -euo pipefail
cd "$(dirname "$0")/.."

SRC=svg_src/icons
OUT=assets/icons

if [ ! -d "$SRC" ]; then
  echo "source ausente: $SRC" >&2
  exit 1
fi

echo "compilando $SRC/*.svg -> $OUT/*.svg.vec ..."
dart run vector_graphics_compiler --input-dir "$SRC" --out-dir "$OUT"
echo "ok: $(ls "$SRC"/*.svg | wc -l | tr -d ' ') fonte(s) compilada(s)"
