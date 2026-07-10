// Bootstrap custom do Flutter web.
//
// Força a variante "full" (portátil) do CanvasKit. A variante padrão "chromium"
// é multi-thread e exige `SharedArrayBuffer` (cross-origin isolation via headers
// COOP/COEP), que hosts estáticos como a Vercel não mandam por padrão — sem
// isso, o init do CanvasKit quebra e a tela fica preta. "full" roda em qualquer
// host, sem header especial.
{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: {
    canvasKitVariant: "full",
  },
});
