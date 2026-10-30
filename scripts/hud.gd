extends CanvasLayer
## HUD: máscaras de vida, nome da sala, habilidades e frases de memória.

const MASK_ON := Color(0.878431, 0.643137, 0.345098, 1.0)
const MASK_OFF := Color(0.105882, 0.14902, 0.231373, 1.0)
const MEMORY_HOLD := 2.5

@onready var _masks: HBoxContainer = $Root/TopLeft/Masks
@onready var _room_label: Label = $Root/TopLeft/RoomName
@onready var _ability_label: Label = $Root/TopLeft/Abilities
@onready var _memory: Label = $Root/Memory

var _mask_nodes: Array[ColorRect] = []
var _memory_tween: Tween


func _ready() -> void:
	GameManager.health_changed.connect(_on_health_changed)
	GameManager.room_changed.connect(_on_room_changed)
	GameManager.ability_unlocked.connect(_on_ability_unlocked)
	_build_masks()
	_on_health_changed(GameManager.health, GameManager.max_health)
	_on_room_changed(GameManager.current_room, GameManager.current_room_name)
	_update_abilities()
	memory_clear()


func _build_masks() -> void:
	for child in _masks.get_children():
		child.queue_free()
	_mask_nodes.clear()
	for i in GameManager.max_health:
		var mask := ColorRect.new()
		mask.custom_minimum_size = Vector2(12, 12)
		mask.mouse_filter = Control.MOUSE_FILTER_IGNORE
		mask.color = MASK_ON
		_masks.add_child(mask)
		_mask_nodes.append(mask)


func _on_health_changed(current: int, _maximum: int) -> void:
	for i in _mask_nodes.size():
		_mask_nodes[i].color = MASK_ON if i < current else MASK_OFF


func _on_room_changed(_room_id: int, room_name: String) -> void:
	_room_label.text = room_name.to_upper()


func _on_ability_unlocked(_ability: String) -> void:
	_update_abilities()


func _update_abilities() -> void:
	var labels: Array[String] = []
	if GameManager.has_ability("dash"):
		labels.append("DASH  SHIFT")
	if GameManager.has_ability("double_jump"):
		labels.append("PULO DUPLO  ESPAÇO×2")
	_ability_label.text = "   ".join(labels)


func show_memory(text: String) -> void:
	_memory.text = text
	if _memory_tween and _memory_tween.is_valid():
		_memory_tween.kill()
	_memory_tween = create_tween()
	_memory_tween.tween_property(_memory, "modulate:a", 1.0, 0.8)
	_memory_tween.tween_interval(MEMORY_HOLD)
	_memory_tween.tween_property(_memory, "modulate:a", 0.0, 1.0)


func memory_clear() -> void:
	_memory.text = ""
	_memory.modulate.a = 0.0
