class_name EnemyBase
extends CharacterBody2D
## Base comum dos inimigos: vida, gravidade, dano por contato e morte em luz.

signal died

@export var max_health := 2
@export var contact_damage := 1
@export var gravity := 1000.0
@export var max_fall_speed := 600.0

var health := 2
var player: Node2D = null
var facing := -1.0
var dead := false

@onready var visual: Node2D = $Visual
@onready var touch_damage: Area2D = get_node_or_null("TouchDamage")


func _ready() -> void:
	health = max_health
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("player")
	if touch_damage:
		touch_damage.body_entered.connect(_on_touch_damage_body_entered)


func _physics_process(delta: float) -> void:
	if dead:
		return
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	_apply_gravity(delta)
	_update_ai(delta)
	move_and_slide()
	_update_facing()


func _apply_gravity(delta: float) -> void:
	velocity.y = minf(velocity.y + gravity * delta, max_fall_speed)


func _update_ai(_delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0.0, 400.0)


func _update_facing() -> void:
	if absf(velocity.x) > 5.0:
		facing = 1.0 if velocity.x > 0.0 else -1.0
	visual.scale.x = facing


func take_damage(amount: int, from_x: float) -> void:
	if dead:
		return
	health -= amount
	if health <= 0:
		_die()
		return
	velocity.x = (1.0 if global_position.x >= from_x else -1.0) * 150.0
	velocity.y = -110.0
	_flash()


func _flash() -> void:
	visual.modulate = Color(1.8, 1.8, 1.8, 1.0)
	var tween := create_tween()
	tween.tween_property(visual, "modulate", Color.WHITE, 0.18)


func _die() -> void:
	dead = true
	died.emit()
	Fx.light_burst(get_parent(), global_position + Vector2(0, -10))
	if touch_damage:
		touch_damage.set_deferred("monitoring", false)
	queue_free()


func _on_touch_damage_body_entered(body: Node2D) -> void:
	if dead:
		return
	if body.has_method("take_damage"):
		body.take_damage(contact_damage, global_position.x)
