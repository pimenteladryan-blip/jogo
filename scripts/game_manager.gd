extends Node
## Estado global da partida: vida, habilidades, sala atual e checkpoint.

signal health_changed(current: int, maximum: int)
signal player_died
signal ability_unlocked(ability: String)
signal room_changed(room_id: int, room_name: String)

const MAX_HEALTH := 5

var max_health := MAX_HEALTH
var health := MAX_HEALTH
var abilities := {"dash": false, "double_jump": false}
var current_room := 1
var current_room_name := ""
var checkpoint_room := 1
var checkpoint_position := Vector2.ZERO
var boss_defeated := false
var run_started := false


func reset_run() -> void:
	max_health = MAX_HEALTH
	health = max_health
	abilities = {"dash": false, "double_jump": false}
	current_room = 1
	current_room_name = ""
	checkpoint_room = 1
	checkpoint_position = Vector2.ZERO
	boss_defeated = false
	run_started = true
	health_changed.emit(health, max_health)


func damage_player(amount: int) -> void:
	if health <= 0:
		return
	health = maxi(health - amount, 0)
	health_changed.emit(health, max_health)
	if health == 0:
		player_died.emit()


func heal_full() -> void:
	health = max_health
	health_changed.emit(health, max_health)


func unlock_ability(ability: String) -> void:
	if abilities.get(ability, false):
		return
	abilities[ability] = true
	ability_unlocked.emit(ability)


func has_ability(ability: String) -> bool:
	return abilities.get(ability, false)


func set_checkpoint(room: int, position: Vector2) -> void:
	checkpoint_room = room
	checkpoint_position = position


func set_room(room: int, room_name: String) -> void:
	current_room = room
	current_room_name = room_name
	room_changed.emit(room, room_name)
