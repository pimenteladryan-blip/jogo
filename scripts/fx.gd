class_name Fx
extends RefCounted
## Efeitos visuais reaproveitáveis (partículas de luz).

const LIGHT := Color(0.878431, 0.643137, 0.345098, 1.0)


static func light_burst(parent: Node, position: Vector2, color: Color = LIGHT, amount: int = 16) -> void:
	if parent == null or not parent.is_inside_tree():
		return
	var particles := CPUParticles2D.new()
	particles.amount = amount
	particles.one_shot = true
	particles.emitting = true
	particles.lifetime = 0.55
	particles.explosiveness = 1.0
	particles.direction = Vector2.UP
	particles.spread = 180.0
	particles.initial_velocity_min = 40.0
	particles.initial_velocity_max = 120.0
	particles.gravity = Vector2(0.0, 140.0)
	particles.scale_amount_min = 1.5
	particles.scale_amount_max = 3.5
	particles.color = color
	parent.add_child(particles)
	particles.global_position = position
	particles.finished.connect(particles.queue_free)
