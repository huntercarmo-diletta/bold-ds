# Ícones do Conta BOLD (base CPF Seguro)

Largue aqui os **SVGs exportados do DS do CPF Seguro**. Eu monto o componente
`BoldIcon` em cima deles (o "accessory de tamanho" do Figma vira o parâmetro
`size`).

## Como exportar (Figma)
1. No arquivo do DS do CPF Seguro, selecione o set de ícones (ou cada ícone).
2. Export → **SVG** (escala 1x).
3. Joga os arquivos nesta pasta.

## Convenção de nomes
- **kebab-case, minúsculo, sem prefixo**: `home.svg`, `pix.svg`, `receipt.svg`,
  `credit-card.svg`, `bell.svg`, `qr-code.svg`, `arrow-right.svg`,
  `eye.svg`, `eye-off.svg`, `gear.svg`, `fingerprint.svg`, `lock.svg`…
- 1 arquivo por ícone. Sem espaços/acentos no nome.

## Cor (importante)
Pra o ícone trocar de cor com o tema (light/dark, ativo/inativo), o SVG precisa
ser **monocromático e herdar a cor**. Duas opções, qualquer uma serve:
- `fill="currentColor"` (ou `stroke="currentColor"`) nos paths, **ou**
- deixar a cor original — eu aplico um `colorFilter` por cima no `BoldIcon`
  (funciona pra ícones de 1 cor só).

Se algum ícone for **multicolor** (ex.: a marca do Pix, que já temos), ele fica
fora dessa regra — uso como ilustração, não como ícone de UI.

## O que eu faço depois que os SVGs estiverem aqui
- Registro a pasta no `pubspec.yaml` (`assets: - .../assets/icons/`).
- Crio `widgets/bold_icon.dart` → `BoldIcon('home', size: 22, color: …)`
  (usa `flutter_svg`, já é dep do projeto).
- Troco os `Icons.*` (Material) das telas pelos `BoldIcon('…')`.
- Mantenho um mapa de nomes pra não quebrar se faltar algum.
