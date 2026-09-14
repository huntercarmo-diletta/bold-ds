#!/bin/sh
# A SAÍDA DA INSTÂNCIA WEB DESTE PRODUTO — uma tag cuja RAIZ é o pacote web, no mesmo repo.
#
#     sh tool/espelha_o_web.sh v0.103.0 [--seco]
#
# ## Por que existe
#
# O `npm` não tem o `path:` do `pub`: `git+ssh://…#tag` instala a RAIZ do que ele clonar. Com um
# monorepo, isso põe o repo inteiro no `node_modules` de quem queria um pacote, e o único import que
# funciona atravessa pastas que não são a do pacote. O avô mediu isso com a gente em 11/09 e
# respondeu com tag órfã (`v0.193.0`); este é o mesmo mecanismo um andar abaixo, porque o muro se
# repete de nós para quem nos consumir.
#
# A tag é EMISSÃO, não autoria: **ninguém commita nela**. Ela se refaz a partir da tag do monorepo.
#
# ## O que sai, e o que NÃO sai
#
# Sai o pacote: `index.js`, `tokens/`, o `README.md` e o `package.json` sem `private`.
#
# **NÃO saem `catalogo/` nem `exemplo/`**, e isso é conserto de um defeito medido no avô: as páginas
# dele foram junto na emissão apontando para `../../diletta_design_system/tokens/generated/`, que
# existe no monorepo e não na tag — o catálogo publicado dele renderiza SEM TINTA. As nossas páginas
# apontam para `../node_modules/`, que no `node_modules` de outro projeto depende de hoisting do npm.
# Ferramenta de desenvolvimento mora no repo; pacote publicado carrega o que o consumidor usa.
set -eu

cd "$(dirname "$0")/.."

tag=${1:-}
seco=${2:-}
[ -n "$tag" ] || { echo "uso: sh tool/espelha_o_web.sh <tag> [--seco]"; exit 2; }
git rev-parse -q --verify "refs/tags/$tag" >/dev/null || { echo "tag $tag não existe aqui"; exit 1; }

versao=${tag#v}
alvo="web-$tag"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

git archive "$tag" packages/coreflow_design_system_web | tar -x -C "$tmp" --strip-components=2
rm -rf "$tmp/catalogo" "$tmp/exemplo" "$tmp/package-lock.json"

# O `package.json` publicado NÃO é o de dentro do monorepo: deixa de ser privado e a versão passa a
# ser a da tag. A DEPENDÊNCIA do avô viaja como está — é ela que traz os 25 custom elements, e o
# `npm` resolve a tag órfã dele do mesmo jeito que o consumidor resolve a nossa.
python3 - "$tmp" "$versao" <<'PY'
import json, pathlib, sys
raiz, versao = pathlib.Path(sys.argv[1]), sys.argv[2]
p = raiz / "package.json"
d = json.loads(p.read_text())
d["version"] = versao
d.pop("private", None)
d["files"] = ["index.js", "tokens/"]
d["exports"] = {k: v for k, v in d["exports"].items() if not k.startswith("./catalogo")}
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + "\n")

fora = [v for v in d["exports"].values() if v.startswith("..")]
assert not fora, f"export aponta pra fora do pacote: {fora}"
assert d.get("dependencies", {}).get("diletta-design-system-web"), \
    "o pacote saiu sem a dependência do avô — sairia sem os 25 elementos"
for f in ("index.js", "tokens/bold-tokens.css"):
    assert (raiz / f).exists(), f"faltou {f} na emissão"
for proibido in ("catalogo", "exemplo", "node_modules"):
    assert not (raiz / proibido).exists(), f"{proibido}/ vazou pra emissão"
print(f"  pacote emitido: {d['name']}@{versao}")
PY

peso=$(du -sk "$tmp" | cut -f1)
arquivos=$(find "$tmp" -type f | wc -l | tr -d ' ')
echo "  $peso KB · $arquivos arquivos · alvo: $alvo"

if [ "$seco" = "--seco" ]; then
  cp -R "$tmp" "${TMPDIR:-/tmp}/espelho-$alvo"
  echo "SECO: nada foi commitado. A árvore ficou em ${TMPDIR:-/tmp}/espelho-$alvo"
  exit 0
fi

# Commit ÓRFÃO por plumbing: índice temporário, sem pai, sem tocar o HEAD nem o índice de trabalho.
idx=$(mktemp); rm -f "$idx"
export GIT_INDEX_FILE="$idx"
git --work-tree="$tmp" add -A
arvore=$(git write-tree)
commit=$(git commit-tree "$arvore" -m "$alvo — a instância web de $tag, com a raiz no pacote

Emitido por tool/espelha_o_web.sh. Ninguém commita aqui: esta árvore se refaz a partir
de $tag. Catálogo e exemplo ficam no monorepo — são ferramenta, não pacote.")
unset GIT_INDEX_FILE
rm -f "$idx"

git tag -f "$alvo" "$commit"
echo "  tag local $alvo criada. Publique com: git push origin $alvo"
