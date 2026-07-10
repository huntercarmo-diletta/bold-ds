# Conta BOLD — Animações da Autorização Quântica (preservadas)

Estas animações foram criadas à parte e **preservadas** dentro do design system
v2. Não fazem parte do "visual da marca" (rosa/pôr-do-sol) — o tema quântico é
intencionalmente **violeta/PQC**, então mantêm a identidade própria. Se quiser
re-tingir para o rosa da marca, troque os `const _violet/_purple` no topo de
cada arquivo.

## O que está incluído

- **`widgets/bold_quantum_pairing.dart`**
  - `BoldQuantumPairingScreen` — tela cheia de pareamento do aparelho + troca de
    chaves pós-quânticas (BLE → ML-KEM keygen → encapsulamento → ML-DSA → pronto).
    Dirija com `progress` (0..1) do fluxo real; sem `progress`, roda em loop demo.
  - `BoldQuantumCore` — só a animação pintada, para compor seu próprio layout.

- **`widgets/bold_quantum_seal.dart`**
  - `BoldQuantumSeal` — selo/marca-d'água de fundo transparente que confirma a
    autorização quântica de uma transação (mostre após o Face ID).
    - `waiting: true` → loop "securing" enquanto o servidor confirma.
    - `waiting: false` → toca a finalização: **sucesso** (check verde, `onCompleted`)
      ou **falha** (`failed: true` → X vermelho, `onFailed`).
  - Doc completa em **`widgets/QUANTUM_SEAL.md`**.

- **Assets** (`assets/`): `quantum-seal.png` (APNG sucesso), `quantum-seal-failed.png`
  (APNG falha), `quantum-seal-preview.html` (preview + exportar WebM transparente).
  São para usos fora do Flutter; no app, use os widgets.

## Já exportadas no barrel

`bold_design_system.dart` já reexporta as duas — basta
`import '.../bold_design_system.dart';` e usar `BoldQuantumPairingScreen` /
`BoldQuantumSeal`.

## Fluxo recomendado da transação

Face ID → `BoldQuantumPairingScreen` (se o aparelho ainda não está pareado) →
na transação, `BoldQuantumSeal(waiting: pending, failed: rejected, …)` como
overlay num `Stack`.
