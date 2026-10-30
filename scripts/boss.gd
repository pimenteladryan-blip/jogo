extends EnemyBase
## Guardião do Templo: duas fases, leque de projéteis, investida e invocação.

const PROJECTILE_SCENE := preload("res://scenes/projectile.tscn")
const CHASER_SCENE := preload("res://scenes/enemies/chaser.tscn")

@export var phase_two_health := 10
@export var base_interval := 2.0
@export var projectile_speed := 170.0

var phase := 1
var _attack_timer := 1.6
var _telegraph := 0.0
var _action := ""
var _charge_timer := 0.0
var _summoned := false


func _ready() -> void:
	super._ready()
	add_to_group("boss")


func _update_ai(delta: float) -> void:
	_attack_timer = maxf(_attack_timer - delta, 0.0)

	if _telegraph > 0.0:
		_telegraph -= delta
		visual.modulate = Color(1.5, 1.5, 1.5, 1.0) if fmod(_telegraph, 0.16) < 0.08 else Color.WHITE
		if _telegraph <= 0.0:
			_execute_attack()
		return

	if _action == "charge":
		_charge_timer -= delta
		velocity.x = facing * 250.0
		if _charge_timer <= 0.0:
			_action = ""
			velocity.x = 0.0
		return

	velocity.x = move_toward(velocity.x, 0.0, 260.0 * delta)
	if player != null and _attack_timer <= 0.0:
		_start_telegraph()


func _start_telegraph() -> void:
	_action = "fan" if randi() % 2 == 0 else "charge"
	_telegraph = 0.5 if phase == 1 else 0.35
	if player != null:
		facing = 1.0 if player.global_position.x > global_position.x else -1.0
		visual.scale.x = facing


func _execute_attack() -> void:
	visual.modulate = Color.WHITE
	if _action == "fan":
		_fire_fan()
	else:
		_action = "charge"
		_charge_timer = 0.35
	_attack_timer = base_interval if phase == 1 else base_interval * 0.65


func _fire_fan() -> void:
	if player == null:
		return
	var origin := global_position + Vector2(0, -24)
	var base_dir := (player.global_position + Vector2(0, -12) - origin).normalized()
	for i in 5:
		var angle := deg_to_rad(-24.0 + i * 12.0)
		var direction := base_dir.rotated(angle)
		var bullet = PROJECTILE_SCENE.instantiate()
		bullet.direction = direction
		bullet.speed = projectile_speed
		get_parent().add_child(bullet)
		bullet.global_position = origin + direction * 14.0


func take_damage(amount: int, from_x: float) -> void:
	super.take_damage(amount, from_x)
	if dead:
		return
	if phase == 1 and health <= phase_two_health:
		phase = 2
		base_interval = 1.3
		if not _summoned:
			_summoned = true
			_summon()


func _summon() -> void:
	var chaser = CHASER_SCENE.instantiate()
	get_parent().add_child(chaser)
	chaser.global_position = global_position + Vector2(-90, 0)


func _die() -> void:
	GameManager.boss_defeated = true
	AudioManager.play("boss")
	GameManager.victory.emit()
	super._die()
