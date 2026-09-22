# PEDIDO · A paginação não tem alvo de toque — 30×30 no dedo, e a peça não publica eixo

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.0`, pela tag `web-v0.114.0` deste repo
- **bloqueante?**: **não bloqueia a adoção** — a peça já está em uso e funciona. Bloqueia o
  webadmin cumprir a própria regra de 44px no telefone, em seis telas, e não há conserto
  possível do lado de cá.

> **Nota de procedência.** Achado no **core-flow-wa** (o webadmin), medindo todo controle
> interativo do console a 390×844 com `hasTouch` — a varredura que nasceu de um defeito
> real do dia: o `<diletta-button>` pintava 36px no dedo porque a regra global de ponteiro
> grosso é de ELEMENTO e não atravessa shadow root. Os botões e o botão de ícone passaram;
> a paginação foi a única que não.

## O caso, em uma linha

Três das peças interativas da família declaram `const ALVO = 44` e o aplicam no `:host`; a
paginação não tem a constante nem o eixo, e mede 30 no dedo.

## Medido no elemento instalado

```
diletta-button.js       PORTE { sm 28, md 36, lg 56 }   const ALVO = 44   :host min-height 44
diletta-icon-button.js  PORTE { sm 32, md 40, lg 56 }   const ALVO = 44   :host min-height 44
diletta-input-chip.js   ALTURA { sm 24, md 32 }         const ALVO = 44   :host min-height 44

diletta-pagination.js   const ALTURA = 30               (sem ALVO)        (sem min-height)
                        nav { height: 30px; gap: 4px }
                        button { min-width: 30px; height: 30px }
                        observedAttributes = ['paginas', 'atual', 'janela']
                        part="nav"   (os botões não são expostos)
```

E medido no navegador, no projeto `celular` do Playwright (390×844, `hasTouch`,
`pointer: coarse`), na tela de Acessos:

```
hospedeiro <diletta-pagination>   30px de altura
"Página anterior"                 30 × 30
"Página 1"                        30 × 30
"Próxima página"                  30 × 30
distância entre alvos             4px
```

**O arranjo que as três irmãs usam — alvo maior que o desenho, no `:host` — resolveria
sozinho**: desenho continua 30, alvo vira 44. É o mecanismo que a família já tem, na peça
que não o publica.

## A peça está fazendo o que a spec dela manda, e é por isso que o pedido é ao pai

A spec publicada (`design-system-pagination`) diz, com todas as letras:

> *"O controle de página das tabelas do BackOffice. **22 instâncias visíveis, todas em
> 270×30.** É uma das **cinco peças web-nativas** do censo: no celular a mesma necessidade
> se resolve por rolagem infinita, que é outra gramática."*

Ou seja: o elemento não esqueceu o dedo — **a spec decidiu que o dedo não é caso dele.** Não
há defeito de implementação aqui, e não é remendo de consumidor que resolve.

O que mudou é que existe um consumidor em que a decisão não fecha. No webadmin **o telefone
é requisito, não adaptação** (maquete aprovada, prancha 2): a mesma tela serve mesa e
celular, a tabela densa vira lista de registros no estreito, e **a paginação continua lá** —
porque a lista de registros não virou rolagem infinita, e trocar a gramática de paginação
por rolagem em seis telas é decisão de produto, não de folha de estilo.

## Onde isso aparece, tela por tela

Seis telas do console paginam, e todas as seis são alcançáveis no telefone:

| tela | o que pagina |
|---|---|
| Acessos · Gestores | a lista de gestores |
| Acessos · Trilha do gestor | os eventos de auditoria |
| Conversas · Histórico | as conversas seladas |
| KYC · Mesa de onboarding | a fila de análise |
| Relatórios · Diagnóstico | os eventos de erro |
| Relatórios · descida aos lançamentos | os lançamentos da fatia |

## O que NÃO estamos afirmando

**30×30 não reprova na WCAG 2.5.8** (AA pede 24×24). O que ele contraria é o piso de 44 que
este produto adotou e que a própria família declara em três peças — a 2.5.5 (AAA), que é a
régua do `const ALVO = 44` das irmãs.

E não estamos pedindo número: a escala é da linguagem. Qualquer arranjo que ponha o alvo em
44 sem mexer no desenho de 30 resolve.

## Uma segunda saída, se a primeira não couber

Se a decisão for manter a peça só de mesa, o pedido vira outro e é igualmente útil: **diga
no contrato o que um consumidor deve usar quando pagina no dedo.** Hoje a spec nomeia a
alternativa ("rolagem infinita") sem publicar peça para ela, e o censo não tem entrada
correspondente — então o consumidor que segue a orientação sai da família.

## O que o consumidor está fazendo enquanto isso

**Nada, e de propósito.** Não há como corrigir daqui: a altura é constante no código do
elemento, não há atributo de porte, e os botões não são expostos como `part` — só o `nav`
é. Furar o shadow root por folha de documento não funciona, e injetar folha construída no
shadow seria exatamente a cópia divergente que o `D1` proíbe.

Fica registrado no console como achado conhecido, sem remendo.
