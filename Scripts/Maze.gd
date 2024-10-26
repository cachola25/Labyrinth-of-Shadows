extends Node3D

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	spawn_monster()
	
func spawn_monster():
	var spawn_distance = 5.0
	var random_offset = Vector3(
		randf() * 2 - 1,
		0,
		randf() * 2 - 1
	)
	var player_position = $player.global_transform.origin
	var player_direction = -$player.global_transform.basis.z
	var spawn_position = player_position + (player_direction * spawn_distance) + random_offset
	
	
	
