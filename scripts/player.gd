extends CharacterBody2D
## Jogador do Templo de Memórias.
## Movimento horizontal com aceleração, pulo com coyote time e buffer de entrada.

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

@export_group("Câmera")
@export var camera_bounds := Rect2(0, 0, 640, 360)

var _coyote_timer := 0.0
var _jump_buffer_timer := 0.0
var _facing := 1

@onready var _visual: Node2D = $Visual
@onready var _camera: Camera2D = $Camera2D


func _ready() -> void:
	_camera.limit_left = int(camera_bounds.position.x)
	_camera.limit_top = int(camera_bounds.position.y)
	_camera.limit_right = int(camera_bounds.end.x)
	_camera.limit_bottom = int(camera_bounds.end.y)
	_camera.reset_smoothing()


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_horizontal(delta)
	_handle_jump(delta)
	move_and_slide()
	_update_visual()


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


func _update_visual() -> void:
	if not is_zero_approx(velocity.x):
		_facing = 1 if velocity.x > 0.0 else -1
	_visual.scale.x = _facing
