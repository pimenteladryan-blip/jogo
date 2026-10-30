extends EnemyBase
## Perseguidor: patrulha devagar e acelera quando vê o jogador.

@export var patrol_speed := 34.0
@export var chase_speed := 78.0
@export var sight_range := 230.0
@export var sight_height := 80.0
@export var acceleration := 500.0


func _update_ai(delta: float) -> void:
	if is_on_wall():
		facing = -facing

	if player == null or _player_is_dead():
		velocity.x = move_toward(velocity.x, facing * patrol_speed, acceleration * delta)
		return

	var offset := player.global_position - global_position
	var sees_player := absf(offset.x) < sight_range and absf(offset.y) < sight_height
	var target_speed := facing * patrol_speed
	if sees_player:
		target_speed = signf(offset.x) * chase_speed
	velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)


func _player_is_dead() -> bool:
	return player.has_method("is_dead") and player.is_dead()
