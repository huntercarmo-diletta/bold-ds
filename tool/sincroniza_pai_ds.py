#!/usr/bin/env python3
"""Traz a LINGUAGEM (ds-diletta) pra dentro deste repo — sync, não dependência.

O ADR-003 decidiu que o DS pai não chega no cliente por `git:`, e a razão é política:
fazer o build do app do CLIENTE depender da infra privada do FORNECEDOR é passivo real
(fim de relação, indisponibilidade, chave revogada — e o cliente não builda o produto
dele). O catálogo pode ser dependência porque é FERRAMENTA da Diletta; o DS não, porque
é ENTREGA.

Então `packages/diletta_design_system/` é código DESTE repo, produzido a partir do pai.
É o modelo de vendoring que o shadcn/ui tornou dominante: "não é dependência, é o seu
código".

O medo legítimo do sync é DRIFT — alguém edita a cópia e ela descola do pai, em silêncio.
Este script grava a procedência (`.sync.json`) e `sem_drift_do_pai_test.dart` falha se a
cópia for editada. Drift deixa de ser risco e passa a ser gate.

Uso:
    python3 tool/sincroniza_pai_ds.py --tag v0.1.0
    python3 tool/sincroniza_pai_ds.py --tag v0.2.0 --de ~/Desktop/Docs/ds-diletta

Sem `--de`, clona o pai num diretório temporário (precisa da credencial de leitura).
"""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

REPO_PAI = 'git@bitbucket.org:diletta/ds-diletta.git'
CAMINHO_NO_PAI = 'packages/diletta_design_system'
DESTINO = Path('packages/diletta_design_system')

# O que NÃO viaja: artefato de build, lock de library, e o EXEMPLO.
#
# O exemplo (a Aurora) é a prova de que o pai é pai, e ela pertence ao pai — roda na CI
# dele. Trazer pra cá encheria o repo do cliente com um segundo produto fictício.
IGNORAR = {'.dart_tool', 'build', 'node_modules', 'pubspec.lock', '.DS_Store', 'exemplos'}


def arquivos(raiz: Path) -> list[Path]:
    """Todo arquivo que faz parte da cópia, em ordem estável."""
    out: list[Path] = []
    for p in sorted(raiz.rglob('*')):
        if any(parte in IGNORAR for parte in p.relative_to(raiz).parts):
            continue
        if p.is_file():
            out.append(p)
    return out


def impressao_digital(raiz: Path) -> str:
    """Hash do CONTEÚDO da cópia — caminho + bytes de cada arquivo.

    É o que o gate de drift compara. Inclui o caminho de propósito: renomear arquivo é
    drift tanto quanto editar.
    """
    h = hashlib.sha256()
    for f in arquivos(raiz):
        h.update(str(f.relative_to(raiz)).encode())
        h.update(b'\0')
        h.update(hashlib.sha256(f.read_bytes()).digest())
    return h.hexdigest()


def git(*args: str, cwd: Path | None = None) -> str:
    return subprocess.run(
        ['git', *args], cwd=cwd, check=True, capture_output=True, text=True
    ).stdout.strip()


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--tag', required=True, help='tag do pai a sincronizar (ex.: v0.1.0)')
    ap.add_argument('--de', help='clone local do ds-diletta (evita clonar de novo)')
    args = ap.parse_args()

    if not Path('packages').is_dir():
        print('rode da RAIZ do repo do cliente', file=sys.stderr)
        return 2

    tmp = None
    try:
        if args.de:
            pai = Path(args.de).expanduser()
            # `--de` é conveniência de dev, então confere que a tag está lá: sincronizar
            # de um clone desatualizado é a forma mais fácil de trazer o pai errado.
            git('rev-parse', f'{args.tag}^{{commit}}', cwd=pai)
        else:
            tmp = Path(tempfile.mkdtemp(prefix='ds-pai-'))
            pai = tmp / 'ds-diletta'
            print(f'clonando o pai em {args.tag}…')
            git('clone', '--quiet', '--branch', args.tag, '--depth', '1', REPO_PAI, str(pai))

        commit = git('rev-parse', f'{args.tag}^{{commit}}', cwd=pai)
        origem = pai / CAMINHO_NO_PAI
        if not origem.is_dir():
            print(f'não achei {CAMINHO_NO_PAI} no pai', file=sys.stderr)
            return 1

        antes = impressao_digital(DESTINO) if DESTINO.is_dir() else None

        # Apaga e recopia: sync tem que ser IDEMPOTENTE. Copiar por cima deixaria pra
        # trás arquivo que o pai removeu, e aí a cópia teria coisa que o pai não tem.
        if DESTINO.is_dir():
            preservar = {p.name for p in DESTINO.iterdir() if p.name in IGNORAR}
            for p in DESTINO.iterdir():
                if p.name in preservar:
                    continue
                shutil.rmtree(p) if p.is_dir() else p.unlink()
        DESTINO.mkdir(parents=True, exist_ok=True)

        for f in arquivos(origem):
            rel = f.relative_to(origem)
            alvo = DESTINO / rel
            alvo.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(f, alvo)

        digital = impressao_digital(DESTINO)
        (DESTINO / '.sync.json').write_text(
            json.dumps(
                {
                    'origem': REPO_PAI,
                    'tag': args.tag,
                    'commit': commit,
                    'impressaoDigital': digital,
                    'comoRegerar': 'python3 tool/sincroniza_pai_ds.py --tag <tag>',
                },
                indent=2,
                ensure_ascii=False,
            )
            + '\n'
        )
        # A impressão digital é calculada ANTES do `.sync.json` existir, senão ela
        # dependeria de si mesma. Por isso o gate também ignora esse arquivo.

        print(f'sincronizado: {args.tag} ({commit[:8]})')
        print(f'  arquivos: {len(arquivos(DESTINO))}')
        print(f'  digital:  {digital[:16]}…')
        if antes and antes != digital:
            print('  a cópia MUDOU — revise o diff como se fosse código seu, porque é')
        elif antes:
            print('  nada mudou')
        return 0
    finally:
        if tmp:
            shutil.rmtree(tmp, ignore_errors=True)


if __name__ == '__main__':
    raise SystemExit(main())
