extends Node2D
## Sala de teste da Etapa 2: combate, dano e morte.

func _ready() -> void:
	GameManager.reset_run()
	GameManager.set_room(2, "Corredor dos Ecos")
	GameManager.player_died.connect(_on_player_died)


func _on_player_died() -> void:
	await get_tree().create_timer(1.4).timeout
	get_tree().reload_current_scene()
