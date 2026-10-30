extends Area2D
## Projétil inimigo: viaja em linha reta e causa dano ao tocar o jogador.

var direction := Vector2.RIGHT
var speed := 150.0
var damage := 1
var lifetime := 3.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	rotation = direction.angle()


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage, global_position.x)
	queue_free()
