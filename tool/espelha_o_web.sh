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
#
# ## E sai TAMBÉM o pacote do avô, copiado — desde 18/09/2026
#
# Até a `web-v0.109.0` a emissão deixava a dependência do avô viajar como estava
# (`bitbucket:diletta/ds-diletta#web-vX`), e quem instalasse ESTE pacote caminhava até o repo dele.
# O dono do produto trancou o `ds-diletta` — só quem faz DS entra —, e aí a linha vira um muro: o
# `npm install` de quem nos consome pede uma chave que o time do produto não tem, e a CI nunca tem.
#
# A frase é do adendo de 18/09 no `ADR-003` do avô: *«acesso ao artefato não é acesso à fonte — e
# usar git como registry funde os dois»*. Enquanto o transporte for tag de git, **o artefato tem de
# embutir o que declara**. Então a emissão copia o pacote dele para `avo/` e apaga a dependência.
#
# **A cópia se faz UMA vez, e se faz aqui.** Não é cada produto materializando o DS dentro de si —
# isso seria a mesma entrega escrita N vezes, com N recibos e N caminhos de upgrade que divergem
# calados. É uma cópia, no DS, e todo consumidor volta a precisar de UMA chave só: a nossa.
#
# Três coisas que fazem a cópia não virar dívida:
#
# - a cópia sai do `node_modules`, e a emissão REPROVA se o que está instalado não for o que o
#   `package.json` da tag pina — cópia sem conferência é a versão de ninguém;
# - sai com RECIBO (`avo/ORIGEM.json`): pacote, versão, tag e o commit resolvido do `package-lock`.
#   A cópia que o app fez em 04/09 não tinha marca de origem, e ninguém sabia dizer de onde veio;
# - o `index.js` NÃO é reescrito. Ele diz `#avo` nos dois lados: aqui o apelido resolve pra
#   dependência, na tag resolve pra `./avo/index.js`. Emissão que reescreve texto de import é
#   divergência que não aparece em diff nenhum.
#
# Os `exports` do avô entram prefixados com `./avo`, DERIVADOS do `package.json` dele — não uma
# lista cravada aqui, pela mesma razão que a nossa lista de arquivos é a que o pacote declara.
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

# A CÓPIA DO AVÔ. Sai do `node_modules` deste pacote, que é o que o `npm` já filtrou pelo `files`
# dele — copiar do repo do avô traria `test/` e `catalogo/`, que não são o pacote.
avo=packages/coreflow_design_system_web/node_modules/diletta-design-system-web
[ -d "$avo" ] || { echo "sem $avo — rode \`npm install\` em packages/coreflow_design_system_web"; exit 1; }
mkdir -p "$tmp/avo"
tar -cf - -C "$avo" . | tar -xf - -C "$tmp/avo"
rm -rf "$tmp/avo/catalogo" "$tmp/avo/node_modules"

# O `package.json` publicado NÃO é o de dentro do monorepo: deixa de ser privado, a versão passa a
# ser a da tag, a dependência do avô SAI (ele viaja copiado em `avo/`) e o apelido `#avo` passa a
# apontar pra cópia.
python3 - "$tmp" "$versao" "$avo" <<'PY'
import json, pathlib, sys
raiz, versao, ondeOAvoMora = pathlib.Path(sys.argv[1]), sys.argv[2], pathlib.Path(sys.argv[3])
p = raiz / "package.json"
d = json.loads(p.read_text())
d["version"] = versao
d.pop("private", None)
# A lista de arquivos é a QUE O PACOTE DECLARA, não uma cravada aqui: cravar é como o `fontes/`
# ficou de fora da v0.104.0 — o pacote ganhou uma pasta e a emissão não soube.
assert d.get("files"), "o pacote não declara `files` — a emissão não sabe o que levar"
d["exports"] = {k: v for k, v in d["exports"].items() if not k.startswith("./catalogo")}

# ── O AVÔ, COPIADO ────────────────────────────────────────────────────────────────────────────
# O pino é o que a TAG declara; o instalado é o que a cópia carrega. Se divergirem, a emissão sai
# com uma versão que o repo não declarou em lugar nenhum — que é a cópia sem dono.
pino = d.get("dependencies", {}).pop("diletta-design-system-web", None)
assert pino, "a tag não declara a dependência do avô — não há o que copiar, nem pino pra conferir"
avo = json.loads((ondeOAvoMora / "package.json").read_text())
esperado = "bitbucket:diletta/ds-diletta#web-v" + avo["version"]
assert pino == esperado, (
    f"o pino da tag é `{pino}` e o INSTALADO é {avo['version']} (`{esperado}`). "
    "Rode `npm install` em packages/coreflow_design_system_web antes de emitir")
if not d["dependencies"]:
    d.pop("dependencies")
d["imports"] = {"#avo": "./avo/index.js"}
# Os exports dele, prefixados — DERIVADOS do que ele declara, não uma lista nossa. Peça nova na
# tag dele aparece aqui sozinha; o catálogo dele fica de fora porque é ferramenta, como o nosso.
for chave, destino in avo.get("exports", {}).items():
    if chave.startswith("./catalogo"):
        continue
    nova = "./avo" if chave == "." else "./avo/" + chave[2:]
    d["exports"][nova] = "./avo/" + destino[2:]
d["files"] = list(d["files"]) + ["avo/"]

# O RECIBO. A cópia que o app fez em 04/09 não tinha marca de origem: ninguém sabia dizer de que
# tag ela veio, e "olhe o conteúdo" não é resposta. O commit sai do lock, que é quem o resolveu.
trava = json.loads(pathlib.Path("packages/coreflow_design_system_web/package-lock.json").read_text())
resolvido = next((v.get("resolved") for k, v in trava.get("packages", {}).items()
                  if k.endswith("node_modules/diletta-design-system-web")), None)
assert resolvido, "o `package-lock.json` não resolve o avô — a cópia sairia sem commit no recibo"
(raiz / "avo" / "ORIGEM.json").write_text(json.dumps({
    "porque": "acesso ao artefato nao e acesso a fonte — ADR-003 do avo, adendo de 2026-09-18",
    "pacote": avo["name"],
    "versao": avo["version"],
    "tag": "web-v" + avo["version"],
    "pino": pino,
    "resolvido": resolvido,
    "copiado_por": "tool/espelha_o_web.sh",
    "nao_edite": "esta pasta e COPIA. Conserto de peca do avo se pede a ele, em docs/pedidos/",
}, ensure_ascii=False, indent=2) + "\n")

p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + "\n")

fora = [v for v in d["exports"].values() if v.startswith("..")]
assert not fora, f"export aponta pra fora do pacote: {fora}"
assert "diletta-design-system-web" not in json.dumps(d.get("dependencies", {})), \
    "a dependência do avô sobreviveu — quem instalar este pacote vai precisar da chave dele"
for f in ("index.js", "tokens/bold-tokens.css", "avo/index.js", "avo/ORIGEM.json"):
    assert (raiz / f).exists(), f"faltou {f} na emissão"
for f in d["files"]:
    assert (raiz / f.rstrip("/")).exists(), f"`files` promete {f} e a emissão não tem"
for proibido in ("catalogo", "exemplo", "node_modules", "avo/catalogo", "avo/node_modules"):
    assert not (raiz / proibido).exists(), f"{proibido}/ vazou pra emissão"
# O apelido tem de resolver: `#avo` é a ÚNICA linha que liga o nosso `index.js` ao pacote dele.
alvo = d["imports"]["#avo"]
assert (raiz / alvo[2:]).exists(), f"`#avo` aponta pra {alvo} e o arquivo não existe"
assert "'#avo'" in (raiz / "index.js").read_text(), \
    "o `index.js` não fala pelo apelido — a cópia iria junto e ninguém a leria"
print(f"  pacote emitido: {d['name']}@{versao} · avô {avo['version']} COPIADO em avo/")
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
