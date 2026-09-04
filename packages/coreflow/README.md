# coreflow — o pai

A linguagem de produto **sem produto**: os componentes `Coreflow*`, os contratos e a forma dos
esquemas. Cor, fonte, logo, arte e nome de produto são do filho — o primeiro é o Bold, em
`packages/coreflow_design_system`, que continua com o nome, o `path:` e os símbolos que o app importa.

Por que existe, o que fica onde e em que ordem se move:
[`docs/2026-09-04-adr-o-coreflow-e-o-pai.md`](../../docs/2026-09-04-adr-o-coreflow-e-o-pai.md).

## Estado — fase 0

Vazio de propósito: só re-exporta `diletta_design_system` na mesma tag que o filho pina. Mover
componente pra cá espera o veredito do dono do DS
(`docs/pedidos/2026-09-04-o-coreflow-e-o-pai-e-o-bold-e-o-primeiro-filho.md`).

## O gate

```bash
flutter analyze && flutter test
```

`o_coreflow_nao_cita_bold`: a mesma regex de `packages/coreflow_design_system/tool/levanta_a_separacao.sh`
sobre `lib/` tem que dar **zero**. Comentário e doc **não** são isentos — o pai não conta a história do
filho nem em prosa.
