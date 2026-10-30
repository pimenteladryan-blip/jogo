class_name RoomBuilder
extends Node2D
## Monta uma sala a partir dos dados de RoomsData: fundo, plataformas,
## inimigos, portas, sino e item de habilidade.

signal door_entered(target_room: int, spawn: Vector2)

const CHASER_SCENE := preload("res://scenes/enemies/chaser.tscn")
const SHOOTER_SCENE := preload("res://scenes/enemies/shooter.tscn")
const BOSS_SCENE := preload("res://scenes/enemies/boss.tscn")
const CHECKPOINT_SCENE := preload("res://scenes/checkpoint.tscn")
const PICKUP_SCENE := preload("res://scenes/pickup.tscn")

const COLOR_BACKGROUND := Color(0.0509804, 0.105882, 0.164706, 1.0)
const COLOR_PLATFORM := Color(0.105882, 0.14902, 0.231373, 1.0)
const COLOR_PLATFORM_EDGE := Color(0.254902, 0.352941, 0.466667, 1.0)
const COLOR_DOOR := Color(0.878431, 0.643137, 0.345098, 0.45)

var room_id := 1
var data: Dictionary = {}


func setup(id: int, room_data: Dictionary) -> void:
	room_id = id
	data = room_data


func _ready() -> void:
	_build_background()
	_build_decor()
	_build_platforms()
	_build_doors()
	_build_checkpoint()
	_build_pickup()
	_build_enemies()


func _build_background() -> void:
	var size: Vector2 = data.size
	var background := ColorRect.new()
	background.color = COLOR_BACKGROUND
	background.size = size
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.z_index = -100
	add_child(background)


func _build_decor() -> void:
	var size: Vector2 = data.size
	var rng := RandomNumberGenerator.new()
	rng.seed = room_id * 7919
	for i in 14:
		var mote := ColorRect.new()
		mote.color = Color(0.615686, 0.705882, 0.752941, rng.randf_range(0.12, 0.35))
		var side := 1.0 if i % 3 != 0 else 2.0
		mote.size = Vector2(side, side)
		mote.position = Vector2(rng.randf() * size.x, rng.randf() * size.y * 0.85)
		mote.mouse_filter = Control.MOUSE_FILTER_IGNORE
		mote.z_index = -90
		add_child(mote)

	var columns := int(size.x / 220.0) + 1
	for i in columns:
		var column := ColorRect.new()
		column.color = Color(0.105882, 0.14902, 0.231373, 1.0)
		column.size = Vector2(26.0, size.y)
		column.position = Vector2(i * 220.0 + 60.0, 0.0)
		column.mouse_filter = Control.MOUSE_FILTER_IGNORE
		column.z_index = -90
		add_child(column)

		var cap := ColorRect.new()
		cap.color = Color(0.254902, 0.352941, 0.466667, 0.55)
		cap.size = Vector2(34.0, 4.0)
		cap.position = Vector2(i * 220.0 + 56.0, size.y - 44.0)
		cap.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cap.z_index = -89
		add_child(cap)


func _build_platforms() -> void:
	for rect: Rect2 in data.platforms:
		var body := StaticBody2D.new()
		body.position = rect.get_center()

		var shape := CollisionShape2D.new()
		var rectangle := RectangleShape2D.new()
		rectangle.size = rect.size
		shape.shape = rectangle
		body.add_child(shape)

		var fill := ColorRect.new()
		fill.color = COLOR_PLATFORM
		fill.size = rect.size
		fill.position = -rect.size * 0.5
		fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
		body.add_child(fill)

		var edge := ColorRect.new()
		edge.color = COLOR_PLATFORM_EDGE
		edge.size = Vector2(rect.size.x, 2.0)
		edge.position = Vector2(-rect.size.x * 0.5, -rect.size.y * 0.5)
		edge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		body.add_child(edge)

		add_child(body)


func _build_doors() -> void:
	for door_data: Dictionary in data.doors:
		var rect: Rect2 = door_data.rect
		var target_room: int = door_data.to
		var spawn: Vector2 = door_data.spawn

		var door := Area2D.new()
		door.position = rect.get_center()
		door.collision_layer = 0
		door.collision_mask = 2
		door.monitorable = false

		var shape := CollisionShape2D.new()
		var rectangle := RectangleShape2D.new()
		rectangle.size = rect.size
		shape.shape = rectangle
		door.add_child(shape)

		var marker := ColorRect.new()
		marker.color = COLOR_DOOR
		marker.size = rect.size
		marker.position = -rect.size * 0.5
		marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
		door.add_child(marker)

		door.body_entered.connect(
			func(body: Node2D) -> void:
				if body.is_in_group("player"):
					door_entered.emit(target_room, spawn)
		)
		add_child(door)


func _build_checkpoint() -> void:
	if data.checkpoint == null:
		return
	var position: Vector2 = data.checkpoint.pos
	var bell: Area2D = CHECKPOINT_SCENE.instantiate()
	bell.room_id = room_id
	bell.respawn = position + Vector2(-48, 0)
	bell.position = position
	add_child(bell)


func _build_pickup() -> void:
	if data.pickup == null:
		return
	var position: Vector2 = data.pickup.pos
	var pickup: Area2D = PICKUP_SCENE.instantiate()
	pickup.ability = data.pickup.ability
	pickup.position = position
	add_child(pickup)


func _build_enemies() -> void:
	for enemy_data: Dictionary in data.enemies:
		var scene: PackedScene = CHASER_SCENE
		if enemy_data.type == "shooter":
			scene = SHOOTER_SCENE
		elif enemy_data.type == "boss":
			scene = BOSS_SCENE
		var enemy: Node2D = scene.instantiate()
		enemy.position = enemy_data.pos
		add_child(enemy)
