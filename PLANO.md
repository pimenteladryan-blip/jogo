# Templo de Memórias — Planejamento Completo

> Mini-metroidvania 2D de ação-plataforma, inspirado na *sensação* de Hollow Knight.
> Melancólico, silencioso e adequado a todos os públicos: os inimigos se desfazem em luz.
>
> **Versão 2** — planejamento completo (substitui a versão anterior).

---

## Sumário

1. [Conceito](#1-conceito)
2. [Ficha técnica](#2-ficha-técnica)
3. [Controles](#3-controles)
4. [Mapa — 9 salas](#4-mapa--9-salas)
5. [Progressão](#5-progressão)
6. [Combate](#6-combate)
7. [Telas e estados](#7-telas-e-estados)
8. [Memórias (identidade emocional)](#8-memórias-identidade-emocional)
9. [Arte e áudio](#9-arte-e-áudio)
10. [Arquitetura do projeto](#10-arquitetura-do-projeto)
11. [Etapas de execução](#11-etapas-de-execução)
12. [Critérios de pronto](#12-critérios-de-pronto)
13. [Cortes de emergência](#13-cortes-de-emergência)
14. [Riscos](#14-riscos)
15. [Ferramentas](#15-ferramentas)
16. [Ambiente verificado](#16-ambiente-verificado)
17. [Publicação](#17-publicação)
18. [Apresentação na escola](#18-apresentação-na-escola)
19. [Referências de estilo](#19-referências-de-estilo)

---

## 1. Conceito

Um espírito desperta num templo soterrado e descobre que cada sala guarda uma memória
perdida. Para avançar, ele recupera habilidades antigas e enfrenta o **Guardião** que
sela a última lembrança.

**Pilares:** explorar → ganhar habilidade → abrir caminho → memória → chefe.

**Promessa ao jogador:** um jogo curto (15–20 min), bonito, sem sustos e com um final
que emociona.

---

## 2. Ficha técnica

| Item | Definição |
|---|---|
| Gênero | Metroidvania 2D de ação-plataforma |
| Tema | Templo de Memórias |
| Ataque | Golpe curto melee — tecla `J` |
| Movimento | Dash `Shift` + Pulo duplo `Espaço ×2` |
| Estrutura de mapa | Linear com atalhos (9 salas) |
| Inimigos | Perseguidor + Atirador + Guardião (mini-chefe) |
| Chefe | Lento e telegrafado, 2 fases |
| Arte | Silhuetas + paralaxe, paleta pedra/azul |
| Áudio | Silêncio ambiente + efeitos pontuais |
| Motor | **Godot 4** (renderer Compatibility) |
| Linguagem | GDScript |
| Distribuição | Exportação Web + GitHub Pages |
| Público | Todos os públicos (livre) |
| Duração | ~15–20 minutos de jogo |

---

## 3. Controles

| Ação | Tecla |
|---|---|
| Mover | `←` `→` ou `A` `D` |
| Pular | `Espaço` ou `Z` |
| Pulo duplo | `Espaço` novamente no ar |
| Ataque | `J` ou clique esquerdo |
| Dash | `Shift` ou `K` |
| Interagir / ler memória | `E` ou `Enter` |
| Pausar | `Esc` ou `P` |
| Ver mapa | `M` |
| Reiniciar | `R` |

Extras opcionais: suporte a gamepad e botões na tela para tablet.

Ações do Input Map no Godot: `move_left`, `move_right`, `jump`, `attack`, `dash`,
`interact`, `pause`, `map`, `restart`.

---

## 4. Mapa — 9 salas

| # | Sala | Função | Conteúdo |
|---|---|---|---|
| 1 | Entrada | tutorial | andar e pular; sem perigo |
| 2 | Corredor dos Ecos | primeiro combate | 1 perseguidor, 1 atirador |
| 3 | Sala do Sino | checkpoint 1 | sino que salva e cura |
| 4 | Poço Vertical | plataforma | subir com pulos, 1 atirador no topo |
| 5 | Jardim Interno | tensão | 2 perseguidores, atalho trancado |
| 6 | Câmara do Selo | **ganha DASH** | sala de recompensa, sem inimigos |
| 7 | Passagem Selada | **usa o dash** | vão largo que só o dash atravessa |
| 8 | Antessala do Guardião | checkpoint 2 | **ganha PULO DUPLO** |
| 9 | Santuário da Memória | chefe | Guardião do Templo |

**Atalhos**

- Após o dash: porta na sala 7 volta à sala 3.
- Após o pulo duplo: atalho da sala 8 volta à sala 5.

**Fluxo**

```
1 → 2 → 3 (sino) → 4 → 5 → 6 (dash) → 7 → 8 (sino + pulo duplo) → 9 (chefe)
                ↑                     │                      │
                └──── atalho ─────────┴── atalho ────────────┘
```

---

## 5. Progressão

1. Começa apenas com **pulo** → salas 1–5
2. Pega **dash** (sala 6) → atravessa a sala 7
3. Pega **pulo duplo** (sala 8) → alcança o chefe (sala 9)
4. Derrota o Guardião → **vitória** + cena final curta

Nenhuma habilidade é perdida ao morrer ou reiniciar do sino.

---

## 6. Combate

| Regra | Valor |
|---|---|
| Vida do jogador | 5 máscaras |
| Dano do golpe | 1 |
| Alcance do golpe | ~40 px à frente |
| Intervalo entre golpes | 0,35 s |
| Invencibilidade após dano | 1 s + piscar |
| Knockback | leve, para dar respiro |
| Perseguidor | 2 de vida; anda devagar e acelera ao ver o jogador |
| Atirador | 2 de vida; parado, dispara em linha com aviso de 0,5 s |
| Guardião fase 1 | 10 de vida: golpe no chão telegrafado + projéteis em leque |
| Guardião fase 2 (50%) | 10 de vida: mais rápido e invoca 1 perseguidor |
| Duração alvo do chefe | 60–90 s |

**Regra de justiça:** todo ataque inimigo tem aviso visual antes — nada de dano surpresa.

**Regra de público livre:** inimigos não sangram; ao morrer, se desfazem em partículas de luz.

---

## 7. Telas e estados

```
Menu → Introdução → Jogando → Pausa → Mapa (M) → Game Over → Vitória → Créditos
```

| Tela | Conteúdo |
|---|---|
| Menu | título, "Começar", "Controles", "Sair" |
| Introdução | 2–3 linhas de texto, pulável com `E` |
| Jogando | HUD: máscaras de vida, sala atual, habilidades |
| Pausa | "Continuar", "Reiniciar", "Menu" |
| Mapa | visão simples das salas visitadas |
| Game Over | "Retomar do sino" ou "Menu" |
| Vitória | texto final + "Jogar novamente" |
| Créditos | nome, escola, ferramentas usadas |

---

## 8. Memórias (identidade emocional)

Ao entrar em salas-chave, uma frase curta aparece no fundo. Rascunhos:

| Sala | Frase |
|---|---|
| 1 | "Toda memória começa com um passo." |
| 2 | "Os ecos repetem o que ninguém quis ouvir." |
| 3 | "O sino ainda espera por quem o toque." |
| 5 | "Aqui alguém cuidou de algo que crescia." |
| 6 | "O selo guardava mais que uma passagem." |
| 8 | "Ele contou os dias até perder a conta." |
| 9 | "No fim, lembrar é uma forma de ficar." |

São baratas de implementar e dão personalidade ao jogo na apresentação.

---

## 9. Arte e áudio

**Paleta (5 cores)**

| Cor | Uso |
|---|---|
| `#0d1b2a` | fundo escuro |
| `#1b263b` | pedra |
| `#415a77` | detalhes |
| `#9db4c0` | luz/realce |
| `#e0a458` | dourado (memórias e itens) |

**Arte**

- Silhuetas com 2–3 camadas de paralaxe
- Formas geométricas (sem sprite complexo no início)
- Partículas para pulo, dano e morte de inimigo

**Áudio**

- Efeitos gerados no **jsfxr**: pulo, golpe, dano, sino, chefe, vitória
- Música ambiente opcional e bem baixa
- Silêncio é parte da atmosfera

---

## 10. Arquitetura do projeto

```
Projetos/jogo/
├── project.godot
├── PLANO.md
├── README.md
├── .gitignore
├── scenes/
│   ├── main.tscn
│   ├── player.tscn
│   ├── enemy_chaser.tscn
│   ├── enemy_shooter.tscn
│   ├── boss.tscn
│   ├── room.tscn
│   └── ui/
│       ├── hud.tscn
│       ├── menu.tscn
│       └── game_over.tscn
├── scripts/
│   ├── player.gd
│   ├── enemy_chaser.gd
│   ├── enemy_shooter.gd
│   ├── boss.gd
│   ├── game_manager.gd
│   ├── checkpoint.gd
│   └── memory_trigger.gd
└── assets/
    ├── sfx/
    └── art/
```

**Autoloads:** `GameManager` (vida, sala, habilidades, checkpoint) e `AudioManager` (sons).

---

## 11. Etapas de execução

### Etapa 0 — Projeto base (1 h)
- Criar `project.godot` com renderer **Compatibility**
- Janela 640×360, stretch `canvas_items`, aspect `keep`
- Pastas `scenes/`, `scripts/`, `assets/`
- `.gitignore` do Godot
- Abrir no editor sem erros
- Commit: *"Configura projeto Godot 4"*

### Etapa 1 — Movimento do jogador (4 h)
- `Player` com `CharacterBody2D`, colisão e corpo visível
- Andar com `move_left` / `move_right`
- Pulo com `jump` (somente no chão)
- Gravidade e colisão
- Câmera com limites
- Sala de teste
- Commit: *"Adiciona movimento e pulo do jogador"*

### Etapa 2 — Salas 1–2 e combate (5 h)
- Sistema de vida (5 máscaras) + HUD
- Ataque melee com `attack` (cooldown 0,35 s)
- Perseguidor e Atirador
- Dano, knockback e invencibilidade
- Morte com partículas de luz
- Commit: *"Adiciona combate e inimigos básicos"*

### Etapa 3 — Checkpoint e telas (3 h)
- Sino que salva e cura
- Game Over com opção de retomar
- Menu inicial e pausa
- Commit: *"Adiciona checkpoints e telas de menu"*

### Etapa 4 — Dash e passagem selada (4 h)
- Desbloqueio do dash na sala 6
- Efeito visual + `dash`
- Vão da sala 7 e atalho para a sala 3
- Commit: *"Adiciona habilidade de dash"*

### Etapa 5 — Pulo duplo e atalhos (3 h)
- Desbloqueio na sala 8
- Atalho para a sala 5
- HUD de habilidades
- Commit: *"Adiciona pulo duplo e atalhos"*

### Etapa 6 — Chefe (5 h)
- Guardião com 2 fases
- Ataques telegrafados
- Arena com portas
- Vitória e cena final
- Commit: *"Adiciona chefe Guardião e vitória"*

### Etapa 7 — Memórias, arte e som (4 h)
- Frases de memória
- Paralaxe e paleta
- Efeitos sonoros
- Commit: *"Adiciona ambientação, memórias e sons"*

### Etapa 8 — QA e publicação (3 h)
- Teste completo do início ao fim
- Correção de bugs
- Exportação Web
- GitHub Pages + README
- Commit: *"Publica versão web do jogo"*

**Total estimado: ~32 h**

---

## 12. Critérios de pronto

- [ ] Ir da sala 1 ao chefe sem travar
- [ ] Dash e pulo duplo abrem exatamente os caminhos previstos
- [ ] Morrer volta ao sino sem perder habilidades
- [ ] Chefe avisa antes de cada ataque e morre em ~60–90 s
- [ ] Roda no navegador e no PC da escola, sem instalar nada
- [ ] Sem erros no console
- [ ] Controles funcionam apenas com teclado
- [ ] Conteúdo adequado a todos os públicos

---

## 13. Cortes de emergência (nesta ordem)

1. Remover pulo duplo (chefe passa para a sala 8)
2. Reduzir para 6 salas
3. Usar apenas um tipo de inimigo
4. Remover o mapa (`M`)
5. Chefe com apenas 1 fase

---

## 14. Riscos

| Risco | Probabilidade | Mitigação |
|---|---|---|
| Movimento travando em quinas | alta | implementar e testar o player antes de tudo |
| Chefe injusto/difícil | média | telegrafia clara + ajuste de vida |
| Escopo crescendo | alta | só adicionar extras depois do MVP |
| Falta de tempo | média | aplicar cortes de emergência |
| Exportação Web falhando | baixa | testar export cedo (etapa 1) |
| Arte demorando | média | usar formas geométricas primeiro |

---

## 15. Ferramentas

| Ferramenta | Uso | Custo |
|---|---|---|
| Godot 4 | motor, física, exportação web | grátis |
| VS Code | scripts e arquivos | grátis |
| Git + GitHub | versionamento e publicação | grátis |
| GIMP / Inkscape | arte e vetores | grátis (já instalados) |
| Piskel / LibreSprite | pixel art | grátis |
| jsfxr | efeitos sonoros | grátis |
| Tiled | edição de mapas por tiles | grátis |
| Excalidraw | desenhar o mapa das salas | grátis |
| Navegador (F12 DevTools) | teste e depuração | grátis |

**Kit mínimo:** Godot 4 + VS Code + Git/GitHub + navegador.

---

## 16. Ambiente verificado

| Item | Situação |
|---|---|
| Sistema | Linux Mint 22.3, x86_64 |
| GPU | Intel UHD 630 — Vulkan 1.4 / OpenGL 4.6 |
| Godot | **4.7.2.stable** instalado em `~/Applications/godot` |
| Instalação | portátil (sem root), `godot` no PATH |
| Teste headless | aprovado |
| Flatpak/Flathub | funcionando (instalação system bloqueada sem root) |
| Disco livre | ~194 GB |
| Renderer recomendado | **Compatibility** (OpenGL) |

```bash
godot --version
# 4.7.2.stable.official.ed1daf0bf
```

---

## 17. Publicação

- Exportar para **Web** (HTML5)
- Publicar no **GitHub Pages** (branch `gh-pages` ou pasta `docs/`)
- README com: descrição, controles, como jogar, créditos
- Repositório: <https://github.com/pimenteladryan-blip/jogo>

---

## 18. Apresentação na escola

**Roteiro de 5 minutos**

1. O que é o jogo (30 s)
2. Mostrar o mapa das 9 salas (30 s)
3. Jogar ao vivo: sala 1 → dash → chefe (3 min)
4. Explicar uma decisão técnica: movimento preso à grade ou IA do chefe (45 s)
5. O que aprendi e o que faria diferente (45 s)

**Perguntas prováveis**

| Pergunta | Resposta curta |
|---|---|
| "Você copiou Hollow Knight?" | "Usei como referência de clima; o jogo, o mapa e o chefe são originais." |
| "Quanto tempo levou?" | "Cerca de 32 horas, divididas em 9 etapas." |
| "Funciona no celular?" | "A versão web roda no navegador; controles por teclado." |

---

## 19. Referências de estilo

Hollow Knight, Ori and the Blind Forest, Ender Lilies, Celeste, Hyper Light Drifter.

---

## Histórico

| Versão | Data | Mudança |
|---|---|---|
| 1 | 23/10/2026 | Planejamento inicial |
| 2 | 23/10/2026 | Planejamento completo: arquitetura, arte/áudio, riscos, ambiente, publicação e apresentação |

---

*Plano criado para o projeto escolar `jogo`.*
