extends CharacterBody2D
## Jogador do Templo de Memórias.
## Movimento com aceleração, pulo com coyote time/buffer, ataque melee e dano com invencibilidade.

signal died

@export_group("Movimento")
@export var move_speed := 140.0
@export var ground_acceleration := 1400.0
@export var ground_friction := 1800.0
@export var air_acceleration := 900.0

@export_group("Pulo")
@export var jump_velocity := -380.0
@export var gravity := 1000.0
@export var max_fall_speed := 600.0
@export var fall_gravity_multiplier := 1.35
@export var coyote_time := 0.1
@export var jump_buffer_time := 0.12

@export_group("Combate")
@export var attack_damage := 1
@export var attack_cooldown := 0.35
@export var attack_active_time := 0.12
@export var invincibility_time := 1.0
@export var knockback_force := 180.0

@export_group("Câmera")
@export var camera_bounds := Rect2(0, 0, 640, 360)

var _coyote_timer := 0.0
var _jump_buffer_timer := 0.0
var _attack_cooldown_timer := 0.0
var _attack_active_timer := 0.0
var _invincibility_timer := 0.0
var _facing := 1
var _dead := false

@onready var _visual: Node2D = $Visual
@onready var _camera: Camera2D = $Camera2D
@onready var _attack_area: Area2D = $AttackArea
@onready var _attack_shape: CollisionShape2D = $AttackArea/CollisionShape2D
@onready var _slash: ColorRect = $Visual/Slash


func _ready() -> void:
	add_to_group("player")
	_attack_area.body_entered.connect(_on_attack_body_entered)
	_attack_shape.disabled = true
	_slash.visible = false
	set_camera_bounds(camera_bounds)


func _physics_process(delta: float) -> void:
	if _dead:
		return

	_tick_timers(delta)
	_apply_gravity(delta)
	_handle_horizontal(delta)
	_handle_jump(delta)
	_handle_attack()
	move_and_slide()
	_update_visual()


func _tick_timers(delta: float) -> void:
	_attack_cooldown_timer = maxf(_attack_cooldown_timer - delta, 0.0)
	_invincibility_timer = maxf(_invincibility_timer - delta, 0.0)

	if _attack_active_timer > 0.0:
		_attack_active_timer = maxf(_attack_active_timer - delta, 0.0)
		if _attack_active_timer <= 0.0:
			_attack_shape.disabled = true
			_slash.visible = false


func _apply_gravity(delta: float) -> void:
	var gravity_scale := fall_gravity_multiplier if velocity.y > 0.0 else 1.0
	velocity.y = minf(velocity.y + gravity * gravity_scale * delta, max_fall_speed)


func _handle_horizontal(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	var acceleration := ground_acceleration if is_on_floor() else air_acceleration

	if is_zero_approx(direction):
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0.0, ground_friction * delta)
	else:
		velocity.x = move_toward(velocity.x, direction * move_speed, acceleration * delta)


func _handle_jump(delta: float) -> void:
	_coyote_timer = coyote_time if is_on_floor() else maxf(_coyote_timer - delta, 0.0)
	_jump_buffer_timer = maxf(_jump_buffer_timer - delta, 0.0)

	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer_time

	if _jump_buffer_timer > 0.0 and _coyote_timer > 0.0:
		velocity.y = jump_velocity
		_jump_buffer_timer = 0.0
		_coyote_timer = 0.0

	# Pulo variável: soltar a tecla cedo encurta o salto.
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.5


func _handle_attack() -> void:
	if _attack_cooldown_timer > 0.0:
		return
	if not Input.is_action_pressed("attack"):
		return

	_attack_cooldown_timer = attack_cooldown
	_attack_active_timer = attack_active_time
	_attack_area.position.x = 18.0 * _facing
	_attack_shape.disabled = false
	_slash.visible = true
	_slash.modulate.a = 0.85
	var tween := create_tween()
	tween.tween_property(_slash, "modulate:a", 0.0, attack_active_time)


func _on_attack_body_entered(body: Node2D) -> void:
	if body == self:
		return
	if body.has_method("take_damage") and body.is_in_group("enemies"):
		body.take_damage(attack_damage, global_position.x)


func take_damage(amount: int, from_x: float) -> void:
	if _dead or _invincibility_timer > 0.0:
		return

	GameManager.damage_player(amount)
	_invincibility_timer = invincibility_time
	velocity.x = signf(global_position.x - from_x) * knockback_force
	velocity.y = -150.0

	if GameManager.health <= 0:
		_die()


func _die() -> void:
	_dead = true
	velocity = Vector2.ZERO
	_visual.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	Fx.light_burst(get_parent(), global_position + Vector2(0, -12), Color(0.615686, 0.705882, 0.752941), 24)
	died.emit()


func is_dead() -> bool:
	return _dead


func set_camera_bounds(bounds: Rect2) -> void:
	camera_bounds = bounds
	_camera.limit_left = int(bounds.position.x)
	_camera.limit_top = int(bounds.position.y)
	_camera.limit_right = int(bounds.end.x)
	_camera.limit_bottom = int(bounds.end.y)
	_camera.reset_smoothing()


func revive() -> void:
	_dead = false
	_visual.visible = true
	_visual.modulate = Color.WHITE
	_invincibility_timer = 0.0
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", false)
	set_physics_process(true)


func _update_visual() -> void:
	if not is_zero_approx(velocity.x):
		_facing = 1 if velocity.x > 0.0 else -1
	_visual.scale.x = _facing

	if _invincibility_timer > 0.0:
		_visual.modulate.a = 0.35 if fmod(_invincibility_timer, 0.16) < 0.08 else 1.0
	else:
		_visual.modulate.a = 1.0
