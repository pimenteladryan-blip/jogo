# Templo de Memórias — Plano do Jogo

> Mini-metroidvania 2D de ação-plataforma, inspirado na *sensação* de Hollow Knight.
> Melancólico, silencioso e adequado a todos os públicos: os inimigos se desfazem em luz.

---

## 1. Conceito

Um espírito desperta num templo soterrado e descobre que cada sala guarda uma memória
perdida. Para avançar, ele recupera habilidades antigas e enfrenta o **Guardião** que
sela a última lembrança.

**Pilares:** explorar → ganhar habilidade → abrir caminho → memória → chefe.

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
| Distribuição | Exportação Web + GitHub Pages |

---

## 3. Controles

| Ação | Tecla |
|---|---|
| Mover | `←` `→` ou `A` `D` |
| Pular | `Espaço` ou `Z` |
| Ataque | `J` ou clique esquerdo |
| Dash | `Shift` ou `K` |
| Interagir / ler memória | `E` ou `Enter` |
| Pausar | `Esc` ou `P` |
| Ver mapa | `M` |
| Reiniciar | `R` |

Extras opcionais: suporte a gamepad e botões na tela para tablet.

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

---

## 5. Progressão

1. Começa apenas com **pulo** → salas 1–5
2. Pega **dash** (sala 6) → atravessa a sala 7
3. Pega **pulo duplo** (sala 8) → alcança o chefe (sala 9)
4. Derrota o Guardião → **vitória** + cena final curta

---

## 6. Regras de combate

| Regra | Valor |
|---|---|
| Vida do jogador | 5 máscaras |
| Dano do golpe | 1 |
| Intervalo entre golpes | 0,35 s |
| Invencibilidade após dano | 1 s + piscar |
| Knockback | leve, para dar respiro |
| Perseguidor | 2 de vida; anda devagar e acelera ao ver o jogador |
| Atirador | 2 de vida; parado, dispara em linha com aviso de 0,5 s |
| Guardião (fase 1) | 10 de vida: golpe no chão telegrafado + projéteis em leque |
| Guardião (fase 2, 50%) | 10 de vida: mais rápido e invoca 1 perseguidor |

**Regra de justiça:** todo ataque inimigo tem aviso visual antes — nada de dano surpresa.

---

## 7. Telas e estados

```
Menu → Introdução → Jogando → Pausa → Mapa (M) → Game Over → Vitória → Créditos
```

- **Menu:** título, "Começar", "Controles"
- **Game Over:** "Retomar do sino" (último checkpoint) ou "Menu"
- **Vitória:** texto curto + opção de reiniciar

---

## 8. Memórias (identidade emocional)

Ao entrar em salas-chave, uma frase curta aparece no fundo, por exemplo:

> "Aqui alguém esperou por muito tempo."

São baratas de implementar e dão personalidade ao jogo na apresentação.

---

## 9. Etapas de execução

| # | Etapa | Entrega | Tempo |
|---|---|---|---|
| 0 | Projeto + git | Godot configurado, cena base, `.gitignore` | 1 h |
| 1 | Movimento do jogador | andar, pular, colisão, câmera | 4 h |
| 2 | Salas 1–2 + combate | golpe, vida, inimigos básicos | 5 h |
| 3 | Checkpoint + UI | vida, sino, game over | 3 h |
| 4 | Dash + salas 6–7 | habilidade e passagem selada | 4 h |
| 5 | Pulo duplo + salas 8 | segunda habilidade e atalhos | 3 h |
| 6 | Chefe | 2 fases, telegrafia, vitória | 5 h |
| 7 | Memórias + arte + som | paralaxe, frases, efeitos | 4 h |
| 8 | QA + build web | testes, correções, exportar | 3 h |
| | **Total** | | **~32 h** |

---

## 10. Critérios de pronto

- [ ] Ir da sala 1 ao chefe sem travar
- [ ] Dash e pulo duplo abrem exatamente os caminhos previstos
- [ ] Morrer volta ao sino sem perder habilidades
- [ ] Chefe avisa antes de cada ataque e morre em ~60–90 s
- [ ] Roda no navegador e no PC da escola, sem instalar nada
- [ ] Sem erros no console

---

## 11. Cortes de emergência (nesta ordem)

1. Remover pulo duplo (chefe passa para a sala 8)
2. Reduzir para 6 salas
3. Usar apenas um tipo de inimigo
4. Remover o mapa (`M`)
5. Chefe com apenas 1 fase

---

## 12. Ferramentas

| Ferramenta | Uso | Custo |
|---|---|---|
| Godot 4 (Flatpak) | motor, física, exportação web | grátis |
| VS Code | scripts e arquivos | grátis |
| Git + GitHub | versionamento e publicação | grátis |
| GIMP / Inkscape | arte e vetores | grátis (já instalados) |
| Piskel / LibreSprite | pixel art | grátis |
| jsfxr | efeitos sonoros | grátis |
| Tiled | edição de mapas por tiles | grátis |
| Navegador (F12 DevTools) | teste e depuração | grátis |

**Kit mínimo:** Godot 4 + VS Code + Git/GitHub + navegador.

---

## 13. Ambiente verificado

| Item | Situação |
|---|---|
| Sistema | Linux Mint 22.3, x86_64 |
| GPU | Intel UHD 630 — Vulkan 1.4 / OpenGL 4.6 |
| Godot | não instalado → instalar 4.x via Flatpak |
| Flatpak/Flathub | funcionando |
| Disco livre | ~194 GB |
| Renderer recomendado | **Compatibility** (OpenGL) |

```bash
flatpak install flathub org.godotengine.Godot
flatpak run org.godotengine.Godot --version
```

---

## 14. Referências de estilo

Hollow Knight, Ori and the Blind Forest, Ender Lilies, Celeste, Hyper Light Drifter.

---

*Plano criado para o projeto escolar `jogo`.*
