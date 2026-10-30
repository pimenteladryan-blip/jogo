# Templo de Memórias

Mini-metroidvania 2D de ação-plataforma sobre memórias perdidas, feito em **Godot 4** (GDScript)
para projeto escolar.

Um espírito desperta num templo soterrado e descobre que cada sala guarda uma memória perdida.
Para avançar, ele recupera habilidades antigas e enfrenta o **Guardião** que sela a última lembrança.

## Status

Em desenvolvimento — **Etapa 0 (projeto base)** concluída.

O planejamento completo está em [`PLANO.md`](PLANO.md).

## Controles

| Ação | Tecla |
|---|---|
| Mover | `←` `→` ou `A` `D` |
| Pular / pulo duplo | `Espaço` ou `Z` |
| Ataque | `J` ou clique esquerdo |
| Dash | `Shift` ou `K` |
| Interagir | `E` ou `Enter` |
| Pausar | `Esc` ou `P` |
| Mapa | `M` |
| Reiniciar | `R` |

## Como rodar

1. Abra o Godot 4.7+ e importe `project.godot`.
2. Pressione `F5`.

Pela linha de comando:

```bash
godot --path .
```

## Estrutura

```
project.godot
scenes/        # main.tscn e, futuramente, player, inimigos, UI
scripts/       # GDScript
assets/        # arte e efeitos sonoros
planejamento/  # mockups e materiais de planejamento
```

## Créditos

Projeto escolar de Adryan Pimentel.
Feito com Godot 4, Git e GitHub.
