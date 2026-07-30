# CONSELHO · faz a limpa, e a ferramenta pra rodar
**de**: ds-diletta v0.11.0 · **para**: você · **data**: 2026-07-30

## O que eu recomendo

Rotina nova pedida pelo dono do produto, com nome próprio: **"faz a limpa"** — de tempos em tempos,
revisar os MDs e o repo pra não carregar coisa desatualizada e lixo.

A frase que a justifica: **doc que mente é pior que doc ausente.** Ausente manda a pessoa perguntar;
mentindo, ela planeja em cima e descobre depois.

```bash
python3 <caminho-do-ds-diletta>/tool/faz_a_limpa.py .
```

Seis classes de apodrecimento, com arquivo e linha: link quebrado · símbolo fantasma (nome em backtick
que não existe em fonte nenhuma) · pendência declarada que já foi feita · número afirmado (toda
contagem envelhece) · md órfão · lixo (`.DS_Store`, arquivo de merge, árvore suja antes de taggear).

Ela **não conserta e não é gate**: falso positivo é barato, silêncio é caro. Quem decide é você.

## O que ela achou em MIM, na primeira execução

Pra você calibrar o que esperar — não foi pouco:

- os **64 specs** do meu repo nomeavam os componentes com o prefixo do PRIMEIRO FILHO
  (`CpfSeguroButton`), e o código é `Diletta` desde a partição. 390 identificadores renomeados;
- 3 specs linkavam um doc que nunca existiu aqui;
- uma "decisão aberta" que já tinha FECHADO por medição, e um ADR dizendo que os repos Diletta não
  existem — eles recebem tag há dois dias;
- no motor: dois links mortos pra doc de filho, e um documento se chamando "proposta de arquitetura
  (v0)" que descreve o motor que existe desde a v0.19.0.

## Duas regras que eu aprendi consertando

1. **histórico não é mentira.** CHANGELOG e ADR guardam o que era verdade naquela data — pendência
   vencida ganha NOTA DE RESOLUÇÃO, não reescrita. Quem reescreve histórico perde o registro de por que
   a decisão foi tomada;
2. **gate ruidoso é gate morto.** A minha checagem de pendência casava "TODO" em minúscula e devolvia
   30 falsos positivos por causa de "Todo componente" — 2 achados de verdade sumiam no meio.

## O que você faz

Roda quando eu ou o dono do produto disser "faz a limpa". Contrato completo:
`ds-diletta/docs/FAZ-A-LIMPA.md`.

## Como isso chega

Nada a sincronizar: a ferramenta é do repo do pai e recebe o caminho do seu por parâmetro. Ceiling
declarado: hoje isso exige os dois repos na mesma máquina. Quando o loop virar online, ela vai junto.
