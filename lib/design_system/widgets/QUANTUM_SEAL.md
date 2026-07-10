# Conta BOLD — Selo de Autorização Quântica

Marca animada que confirma a etapa de **Autorização Quântica** (criptografia
pós-quântica) de uma transação. Aparece como **marca-d'água / overlay** sobre a
tela da transação, logo após a animação do Face ID.

> Fluxo no app: **Face ID** → (transação em processamento) → **Selo Quântico**.
> Enquanto o servidor confirma, o selo fica em "securing" (loop); ao confirmar,
> ele toca a conclusão (chave → check, verde) e some. Se o servidor **rejeitar**,
> ele toca a falha (chave → X, vermelho, "negada").

---

## Arquivos

```
design_system/
├─ widgets/bold_quantum_seal.dart   ← widget Flutter (USE ISTO no app)
├─ assets/quantum-seal.png          ← APNG transparente — SUCESSO (preview/lembrete)
├─ assets/quantum-seal-failed.png   ← APNG transparente — FALHA
└─ assets/quantum-seal-preview.html ← preview interativo (sucesso + falha) + exportar .webm
```

- **No app, use SEMPRE o widget Flutter** `BoldQuantumSeal` — transparência real
  sobre qualquer conteúdo, escala vetorial, dirigido pelo estado da transação.
- O **APNG** (`quantum-seal.png`) é o asset transparente pronto para usos fora do
  Flutter (lembrete, web, e-mail, documentação). 240×300, ~3s, loop infinito,
  fundo transparente. Use em `<img src="quantum-seal.png">`.
- O **preview HTML** mostra o selo sobre uma transação fake (xadrez = transparência)
  e tem um botão para gravar um **WebM com canal alpha**, caso precise de vídeo.

---

## Widget Flutter — API

```dart
BoldQuantumSeal({
  bool waiting = false,        // true = loop "securing"; false = toca a finalização
  bool failed = false,         // finalização: false = sucesso (check verde), true = falha (X vermelho)
  VoidCallback? onCompleted,   // dispara ao terminar o SUCESSO
  VoidCallback? onFailed,      // dispara ao terminar a FALHA (cai em onCompleted se null)
  double size = 160,           // lado do selo (px lógicos)
  bool showLabel = true,       // mostra o rótulo abaixo do selo
  String label = 'Autorização Quântica',
  String failLabel = 'Autorização negada',
})
```

### Uso 1 — espera enquanto a transação confirma (recomendado)

```dart
bool _pending = true; // vire para false quando o backend confirmar

Stack(
  alignment: Alignment.center,
  children: [
    TransactionScreen(),
    // scrim opcional para destacar o selo:
    Positioned.fill(child: ColoredBox(color: Colors.black54)),
    BoldQuantumSeal(
      waiting: _pending,
      onCompleted: () => Navigator.of(context).pop(), // fecha o overlay
    ),
  ],
)
```

- `waiting: true` → roda o estado "securing" **indefinidamente** (anel girando,
  nós orbitando, chave pulsando). Dura o tempo que a transação precisar.
- Ao setar `waiting: false`, toca a finalização (~1,2s) e chama o callback:
  - **sucesso** (`failed: false`) → chave → check verde, `onCompleted`.
  - **falha** (`failed: true`) → chave → X vermelho + leve tremor + rótulo
    "negada", `onFailed` (ou `onCompleted` se `onFailed` for nulo).

```dart
// resolvendo com falha:
setState(() { _pending = false; _failed = true; });
BoldQuantumSeal(waiting: _pending, failed: _failed, onFailed: _showRetry);
```

### Uso 2 — conclusão direta (sem espera)

Se a autorização já está confirmada, construa com `waiting: false` desde o
início — ele toca a animação completa (~2s) uma vez e chama `onCompleted`.

```dart
BoldQuantumSeal(onCompleted: _continue); // ~2s e pronto
```

---

## Regras de uso

- **Sempre sobre conteúdo** — o selo é transparente por natureza; coloque-o num
  `Stack`. Para legibilidade, adicione um scrim escuro translúcido (`black54`)
  por baixo, opcional.
- **Depois do Face ID, não no lugar dele** — o Face ID autentica o usuário; o
  selo comunica que o canal pós-quântico foi estabelecido para aquela transação.
- **Não use como botão** — é puramente informativo/confirmatório.
- **Cor = estado:** roxo/laranja durante o "securing", verde na conclusão. Não
  troque essas cores — seguem os tokens do design system.
- **Tamanho:** 120–200px cobre a maioria dos casos. Abaixo de 100px o rótulo
  perde legibilidade — nesse caso use `showLabel: false`.

---

## APNG / vídeo transparente (fora do Flutter)

- `assets/quantum-seal.png` é um **APNG** — anima em qualquer navegador moderno e
  em `Image.asset` do Flutter ele aparece como estático (use o widget para animar
  no app). Ótimo para lembrete/web/e-mail.
- Para **vídeo** transparente, abra `assets/quantum-seal-preview.html` e use o
  botão "Gravar vídeo transparente" → gera um `.webm` com canal alpha.
- **Atenção:** GIF **não** serve aqui — só tem transparência de 1 bit e os brilhos
  do selo ficariam serrilhados. Use APNG ou WebM-alpha.
