extends Area2D
## Item de habilidade: ao tocar, libera dash ou pulo duplo.

@export var ability := "dash"

var _taken := false
var _time := 0.0

@onready var visual: Node2D = $Visual


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_time = randf() * TAU


func _process(delta: float) -> void:
	if _taken:
		return
	_time += delta
	visual.position.y = sin(_time * 3.0) * 4.0
	visual.modulate.a = 0.75 + 0.25 * sin(_time * 4.0)


func _on_body_entered(body: Node2D) -> void:
	if _taken or not body.is_in_group("player"):
		return
	_taken = true
	GameManager.unlock_ability(ability)
	Fx.light_burst(get_parent(), global_position, Color(0.878431, 0.643137, 0.345098), 28)
	var tween := create_tween()
	tween.tween_property(visual, "scale", Vector2(1.8, 1.8), 0.25)
	tween.parallel().tween_property(visual, "modulate:a", 0.0, 0.25)
	tween.tween_callback(queue_free)
