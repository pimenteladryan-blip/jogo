extends Node2D
## Cena de jogo: monta salas, transições, intro, pausa e game over.

const MENU_SCENE := "res://scenes/ui/menu.tscn"

@onready var world: Node2D = $World
@onready var player: CharacterBody2D = $Player
@onready var hud: CanvasLayer = $HUD
@onready var fade: ColorRect = $UI/Fade
@onready var intro: Control = $UI/Intro
@onready var pause_menu: Control = $UI/Pause
@onready var game_over: Control = $UI/GameOver
@onready var victory: Control = $UI/Victory

var _transitioning := false
var _paused := false
var _intro_open := false
var _dead := false
var _room_size := Vector2(640, 360)
var _room_spawn := Vector2.ZERO


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	if not GameManager.run_started:
		GameManager.reset_run()
	if GameManager.checkpoint_position == Vector2.ZERO:
		GameManager.set_checkpoint(1, RoomsData.get_room(1).spawn)

	GameManager.player_died.connect(_on_player_died)
	GameManager.victory.connect(_on_victory)
	$UI/Pause/Resume.pressed.connect(_on_resume_pressed)
	$UI/Pause/Restart.pressed.connect(_on_restart_pressed)
	$UI/Pause/ToMenu.pressed.connect(_go_to_menu)
	$UI/GameOver/Retry.pressed.connect(_on_retry_pressed)
	$UI/GameOver/ToMenu.pressed.connect(_go_to_menu)
	$UI/Victory/ToMenu.pressed.connect(_go_to_menu)

	pause_menu.hide()
	game_over.hide()
	victory.hide()
	fade.color = Color(0.0, 0.0, 0.0, 0.0)

	_load_room(1, RoomsData.get_room(1).spawn)
	_open_intro()


func _unhandled_input(event: InputEvent) -> void:
	if _intro_open:
		if (
			event.is_action_pressed("interact")
			or event.is_action_pressed("ui_accept")
			or event.is_action_pressed("jump")
			or event.is_action_pressed("attack")
		):
			_close_intro()
			get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("pause") and not _dead and not _transitioning:
		_toggle_pause()
		get_viewport().set_input_as_handled()


func _open_intro() -> void:
	_intro_open = true
	intro.show()
	player.set_physics_process(false)


func _close_intro() -> void:
	_intro_open = false
	intro.hide()
	player.set_physics_process(true)


func _toggle_pause() -> void:
	_paused = not _paused
	pause_menu.visible = _paused
	get_tree().paused = _paused


func _load_room(room_id: int, spawn: Vector2) -> void:
	for child in world.get_children():
		child.queue_free()

	var data: Dictionary = RoomsData.get_room(room_id)
	var builder := RoomBuilder.new()
	builder.setup(room_id, data)
	builder.door_entered.connect(_on_door_entered)
	world.add_child(builder)

	player.global_position = spawn
	player.set_camera_bounds(Rect2(Vector2.ZERO, data.size))
	GameManager.set_room(room_id, data.name)
	_room_size = data.size
	_room_spawn = spawn

	var memory: String = data.get("memory", "")
	if memory != "":
		hud.show_memory(memory)


func _physics_process(_delta: float) -> void:
	if _dead or _transitioning or _intro_open:
		return
	if player.global_position.y > _room_size.y + 120.0:
		_respawn_from_pit()


func _respawn_from_pit() -> void:
	player.take_damage(1, player.global_position.x + 10.0)
	player.global_position = _room_spawn
	player.velocity = Vector2.ZERO


func _on_door_entered(target_room: int, spawn: Vector2) -> void:
	if _transitioning or _dead:
		return
	_transitioning = true
	player.set_physics_process(false)

	var tween_out := create_tween()
	tween_out.tween_property(fade, "color:a", 1.0, 0.22)
	await tween_out.finished

	_load_room(target_room, spawn)

	var tween_in := create_tween()
	tween_in.tween_property(fade, "color:a", 0.0, 0.22)
	await tween_in.finished

	player.set_physics_process(true)
	_transitioning = false


func _on_player_died() -> void:
	_dead = true
	await get_tree().create_timer(0.9).timeout
	game_over.show()
	get_tree().paused = true


func _on_retry_pressed() -> void:
	get_tree().paused = false
	game_over.hide()
	_dead = false
	GameManager.heal_full()
	player.revive()
	_load_room(GameManager.checkpoint_room, GameManager.checkpoint_position)


func _on_victory() -> void:
	AudioManager.play("victory")
	await get_tree().create_timer(1.6).timeout
	victory.show()
	get_tree().paused = true


func _on_resume_pressed() -> void:
	_toggle_pause()


func _on_restart_pressed() -> void:
	get_tree().paused = false
	_paused = false
	pause_menu.hide()
	GameManager.heal_full()
	player.revive()
	_load_room(GameManager.checkpoint_room, GameManager.checkpoint_position)


func _go_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MENU_SCENE)
