extends Area2D
## Sino de checkpoint: salva o ponto de retorno e cura o jogador.

@export var room_id := 1

var respawn := Vector2.ZERO
var _used := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if _used or not body.is_in_group("player"):
		return
	_used = true
	GameManager.set_checkpoint(room_id, respawn)
	GameManager.heal_full()
	AudioManager.play("bell")
	Fx.light_burst(get_parent(), global_position + Vector2(0, -22), Color(0.878431, 0.643137, 0.345098), 22)
	var tween := create_tween()
	tween.tween_property($Visual, "modulate", Color(1.5, 1.5, 1.5, 1.0), 0.12)
	tween.tween_property($Visual, "modulate", Color.WHITE, 0.5)
