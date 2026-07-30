/// CPF SEGURO — tokens internos do chat (shape/spacing das bubbles).
///
/// Detalhe COMPARTILHADO pelos componentes de chat (bubble, criteria,
/// typing, scroll). NÃO é exportado no barrel — não faz parte da API pública.
class DilettaChatTokens {
  DilettaChatTokens._();

  /// Radius das quinas "livres" (25).
  static const double radius = 25;

  /// Radius da quina âncora (0 — corner "puxado" pra fonte da fala).
  static const double anchor = 0;

  static const double px = 16;
  static const double py = 16;

  /// Gap padrão entre bubbles sequenciais (Figma 6:4343 — 8px).
  static const double gap = 8;

  /// Max width da bubble (bot E user) — hug até 250.
  static const double maxWidth = 250;

  /// Bubble "digitando" (loading) — caixa fixa hug, não-fill (Figma).
  static const double loadingWidth = 80;
  static const double loadingHeight = 54;
}
