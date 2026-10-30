extends EnemyBase
## Atirador: parado, avisa por 0,5 s e dispara na direção do jogador.

@export var shoot_range := 340.0
@export var telegraph_time := 0.5
@export var shoot_cooldown := 1.7
@export var projectile_scene: PackedScene = preload("res://scenes/projectile.tscn")

var _cooldown := 0.8
var _telegraph := 0.0
var _charging := false

@onready var charge: ColorRect = $Visual/Charge


func _ready() -> void:
	super._ready()
	charge.visible = false


func _update_ai(delta: float) -> void:
	velocity.x = 0.0
	_cooldown = maxf(_cooldown - delta, 0.0)

	if player == null or _player_is_dead():
		_cancel_charge()
		return

	var offset := player.global_position - global_position
	if absf(offset.x) > shoot_range or absf(offset.y) > 200.0:
		_cancel_charge()
		return

	if absf(offset.x) > 1.0:
		facing = 1.0 if offset.x > 0.0 else -1.0

	if _charging:
		_telegraph -= delta
		charge.visible = true
		charge.modulate.a = 0.55 + 0.45 * sin(_telegraph * 45.0)
		if _telegraph <= 0.0:
			_shoot()
	else:
		charge.visible = false
		if _cooldown <= 0.0:
			_charging = true
			_telegraph = telegraph_time


func _shoot() -> void:
	_charging = false
	_cooldown = shoot_cooldown
	charge.visible = false

	var origin := global_position + Vector2(0, -12)
	var target := player.global_position + Vector2(0, -12)
	var bullet := projectile_scene.instantiate()
	bullet.direction = (target - origin).normalized()
	bullet.speed = 150.0
	get_parent().add_child(bullet)
	bullet.global_position = origin + bullet.direction * 10.0


func _cancel_charge() -> void:
	_charging = false
	charge.visible = false


func _player_is_dead() -> bool:
	return player.has_method("is_dead") and player.is_dead()
