#!/usr/bin/env bash
# Build do catálogo do Conta BOLD para web. A saída é `packages/catalog/build/web`, que é
# exatamente o que o `wrangler.jsonc` serve.
#
# Roda na MÁQUINA de quem publica, e isso é decisão medida, não preguiça: o catálogo depende
# dos dois pais por `git:` sobre SSH do Bitbucket, e nenhum contêiner de CI tem essa chave.
# Build local + `wrangler deploy` publica sem credencial nova em lugar nenhum.
set -euo pipefail

cd "$(dirname "$0")"

# Usa o Flutter da máquina quando existe. Só baixa o SDK quando não há nenhum — o caso de um
# agente Linux de CI. Sem esta checagem, o script baixa o tarball Linux e explode no macOS
# com "cannot execute binary file" (defeito medido no primeiro filho).
FLUTTER_VERSION="3.44.4"
if ! command -v flutter >/dev/null 2>&1; then
  if [ ! -x flutter/bin/flutter ]; then
    curl -sL -o flutter.tar.xz \
      "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
    tar xf flutter.tar.xz
    rm flutter.tar.xz
  fi
  export PATH="$PWD/flutter/bin:$PATH"
fi

flutter config --enable-web --no-analytics

cd packages/catalog
flutter pub get

# SOURCE MAPS no release, de propósito.
#
# Sem eles o console mostra `main.dart.js:34970` com nomes minificados, que não localizam nada
# — os nomes mudam a cada build. O `.map` só é baixado com o devtools aberto, e este catálogo é
# ferramenta interna atrás do Access: custo zero pra quem usa, diferença enorme pra quem conserta.
flutter build web --release --source-maps

# O GATE DO CUSTO, e ele roda DEPOIS do build porque metade do que ele mede é a pasta gerada.
#
# A trava é estrutural: a `wrangler.jsonc` é assets-only (`assets.directory`, sem `main`), e servir
# asset estático não é invocação de Worker. O gate vigia a linha que quebraria isso — um commit que
# acrescente `main`, binding de armazenamento ou produto pago publica sem o wrangler reclamar.
#
# E mede o que faria o DEPLOY falhar: o teto de 20.000 arquivos do Workers Assets e arquivo acima de
# 25 MB. Hoje: 464 arquivos, 48,6 MB.
#
# Ferramenta do pai, roda apontando pra cá — igual à limpa e à auditoria. Se o caminho não existir na
# máquina, o build não morre: o gate avisa e quem publica decide.
cd ../..
PAI_DS="${PAI_DS:-../ds-diletta}"
if [ -f "$PAI_DS/tool/nunca_pagar.py" ]; then
  python3 "$PAI_DS/tool/nunca_pagar.py" .
else
  echo "AVISO: nunca_pagar.py não encontrado em $PAI_DS — o gate de custo NÃO rodou."
fi

echo
echo "pronto: packages/catalog/build/web"
echo "publica com: npx wrangler deploy   (da raiz do repo)"
