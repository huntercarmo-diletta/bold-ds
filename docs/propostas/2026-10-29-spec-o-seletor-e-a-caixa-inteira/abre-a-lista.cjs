// Abre a lista do <diletta-dropdown> num Chrome com janela, captura a tela (o painel nativo não sai
// em page.screenshot) e mede o contraste das opções sobre o fundo do painel. Só Windows (a captura e
// o primeiro plano são do user32), numa tela com escala 100%.
//   WA=<node_modules com playwright e pngjs> node abre-a-lista.cjs <pasta-servida> <saida>
// A pasta servida tem `v3250/` (o `src` da web-v3.25.0), `fix/` (o `src` com o patch ao lado) e
// `tokens/` (o `tokens/generated` do avô). O `node_modules` do console serve como WA.
const path = require('path');
const fs = require('fs');
const http = require('http');
const { execFileSync } = require('child_process');
const WA = (process.env.WA || 'node_modules').replace(/\/?$/, '/');
const { chromium } = require(WA + 'playwright');
const { PNG } = require(WA + 'pngjs');

const [raiz, saida] = process.argv.slice(2);
fs.mkdirSync(saida, { recursive: true });

const PONTE_206 = `
diletta-dropdown::part(controle) { background-color: var(--diletta-surface); }
select option { background-color: var(--diletta-surface); color: var(--diletta-textPrimary); }`;

const pagina = (q) => `<!doctype html><html data-theme="${q.tema}"><head><meta charset="utf-8"><title>lista-${q.nome}</title>
<link rel="stylesheet" href="/tokens/diletta-tokens.css"><link rel="stylesheet" href="/tokens/diletta-papeis.css">
<style>
  body { margin: 0; padding: 40px; background: var(--diletta-bg); font-family: system-ui; }
  ${q.cs ? `:root { color-scheme: ${q.tema}; }` : ''}
  ${q.ponte ? PONTE_206 : ''}
</style></head><body>
<diletta-dropdown style="width:240px" moldura="${q.moldura}" porte="md" valor="ativo">
  <option value="ativo">Ativo</option><option value="inativo">Inativo</option>
  <option value="bloqueado">Bloqueado</option><option value="pendente">Pendente de aprovação</option>
  <option value="encerrado">Encerrado</option><option value="suspenso">Suspenso</option>
</diletta-dropdown>
<script type="module">await import('/${q.v}/diletta-dropdown.js');</script></body></html>`;

const srv = http.createServer((req, res) => {
  const u = new URL(req.url, 'http://x');
  if (u.pathname === '/p') {
    const q = Object.fromEntries(u.searchParams);
    res.writeHead(200, { 'content-type': 'text/html; charset=utf-8' });
    return res.end(pagina({ ...q, cs: q.cs === '1', ponte: q.ponte === '1' }));
  }
  const f = path.join(raiz, decodeURIComponent(u.pathname));
  if (!fs.existsSync(f)) { res.writeHead(404); return res.end(); }
  res.writeHead(200, { 'content-type': f.endsWith('.js') ? 'text/javascript' : 'text/css' });
  fs.createReadStream(f).pipe(res);
});

const lum = ([r, g, b]) => {
  const c = (v) => { v /= 255; return v <= 0.03928 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4; };
  return 0.2126 * c(r) + 0.7152 * c(g) + 0.0722 * c(b);
};
const contraste = (a, b) => { const [x, y] = [lum(a), lum(b)].sort((m, n) => n - m); return (x + 0.05) / (y + 0.05); };
const hex = (c) => '#' + c.map((v) => v.toString(16).padStart(2, '0')).join('');

function primeiroPlano(titulo) {
  execFileSync('powershell', ['-NoProfile', '-Command', `
    Add-Type @"
using System; using System.Runtime.InteropServices;
public class U { [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int c);
  [DllImport("user32.dll")] public static extern void keybd_event(byte k, byte s, uint f, UIntPtr e); }
"@
    $p = Get-Process chrome | ? { $_.MainWindowTitle -like '${titulo}*' } | select -First 1
    if (-not $p) { throw 'janela ${titulo} nao achada' }
    [U]::keybd_event(0x12, 0, 0, [UIntPtr]::Zero); [U]::keybd_event(0x12, 0, 2, [UIntPtr]::Zero)
    [U]::ShowWindow($p.MainWindowHandle, 9) | Out-Null
    [U]::SetForegroundWindow($p.MainWindowHandle) | Out-Null`]);
}

function capturaTela(arq) {
  execFileSync('powershell', ['-NoProfile', '-Command', `
    Add-Type -AssemblyName System.Windows.Forms, System.Drawing
    $b = New-Object System.Drawing.Bitmap 1920, 1080
    $g = [System.Drawing.Graphics]::FromImage($b)
    $g.CopyFromScreen(0, 0, 0, 0, $b.Size)
    $b.Save('${arq.replace(/\//g, '\\')}', [System.Drawing.Imaging.ImageFormat]::Png)`]);
}

// O painel: as linhas abaixo da primeira (a destacada), na largura do select. Fundo = a cor mais
// comum; texto = o pixel de maior contraste contra ele.
function mede(png, r) {
  const conta = new Map();
  const px = [];
  for (let y = Math.round(r.y); y < Math.round(r.y + r.h); y++) for (let x = Math.round(r.x); x < Math.round(r.x + r.w); x++) {
    const i = (y * png.width + x) * 4, c = [png.data[i], png.data[i + 1], png.data[i + 2]];
    px.push(c); const k = c.join(','); conta.set(k, (conta.get(k) || 0) + 1);
  }
  const fundo = [...conta.entries()].sort((a, b) => b[1] - a[1])[0][0].split(',').map(Number);
  let texto = fundo, max = 1;
  for (const c of px) { const k = contraste(c, fundo); if (k > max) { max = k; texto = c; } }
  return { fundo: hex(fundo), texto: hex(texto), contraste: +max.toFixed(2) };
}

(async () => {
  await new Promise((ok) => srv.listen(0, '127.0.0.1', ok));
  const porta = srv.address().port;
  const casos = [];
  for (const v of ['v3250', 'fix']) for (const moldura of ['caixa', 'silencioso']) {
    if (v === 'v3250') {
      casos.push({ v, moldura, tema: 'dark', cs: 0, ponte: 0, nome: `pura-${moldura}-escuro` });
      casos.push({ v, moldura, tema: 'dark', cs: 1, ponte: 0, nome: `pura-cs-${moldura}-escuro` });
      casos.push({ v, moldura, tema: 'dark', cs: 1, ponte: 1, nome: `ponte206-${moldura}-escuro` });
    } else {
      casos.push({ v, moldura, tema: 'dark', cs: 0, ponte: 0, nome: `fix-${moldura}-escuro` });
      casos.push({ v, moldura, tema: 'dark', cs: 1, ponte: 0, nome: `fix-cs-${moldura}-escuro` });
      casos.push({ v, moldura, tema: 'light', cs: 0, ponte: 0, nome: `fix-${moldura}-claro` });
    }
  }
  const navegador = await chromium.launch({
    headless: false, executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe',
    args: ['--window-position=0,0', '--window-size=900,700', '--force-device-scale-factor=1'],
  });
  const resultado = {};
  for (const c of casos) {
    const ctx = await navegador.newContext({ viewport: null });
    const page = await ctx.newPage();
    await page.goto(`http://127.0.0.1:${porta}/p?${new URLSearchParams(c)}`);
    await page.waitForFunction(() => document.querySelector('diletta-dropdown')?.shadowRoot?.querySelector('select'));
    await page.bringToFront();
    primeiroPlano(`lista-${c.nome}`);
    await page.waitForTimeout(400);
    const geo = await page.evaluate(() => {
      const s = document.querySelector('diletta-dropdown').shadowRoot.querySelector('select').getBoundingClientRect();
      return { x: s.x, y: s.y, w: s.width, h: s.height,
        ox: window.screenX + (window.outerWidth - window.innerWidth) / 2,
        oy: window.screenY + (window.outerHeight - window.innerHeight) };
    });
    await page.click('diletta-dropdown >> select');
    await page.waitForTimeout(700);
    const arq = path.join(saida, `${c.nome}.png`);
    capturaTela(arq);
    await page.keyboard.press('Escape');
    const png = PNG.sync.read(fs.readFileSync(arq));
    const sx = geo.ox + geo.x, sy = geo.oy + geo.y + geo.h;
    // corta a região do seletor + painel para o registro
    const corte = new PNG({ width: 360, height: 260 });
    PNG.bitblt(png, corte, Math.max(0, Math.round(sx - 40)), Math.max(0, Math.round(geo.oy + geo.y - 30)), 360, 260, 0, 0);
    fs.writeFileSync(path.join(saida, `${c.nome}-corte.png`), PNG.sync.write(corte));
    // linhas 3 a 6 do painel (a 1ª é a destacada), descontando 4px de cada lado
    resultado[c.nome] = mede(png, { x: sx + 4, y: sy + 2 * geo.h + 4, w: geo.w - 8, h: 3 * geo.h });
    console.log(c.nome.padEnd(28), JSON.stringify(resultado[c.nome]));
    await ctx.close();
  }
  await navegador.close();
  srv.close();
  fs.writeFileSync(path.join(saida, 'medida.json'), JSON.stringify(resultado, null, 2));
})().catch((e) => { console.error(e); process.exit(1); });
