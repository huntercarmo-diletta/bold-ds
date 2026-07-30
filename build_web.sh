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

echo
echo "pronto: packages/catalog/build/web"
echo "publica com: npx wrangler deploy   (da raiz do repo)"
