extends Node3D

@onready var monster_scene = preload("res://scenes/Monster.tscn")
var monster_in_scene = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
		
func spawn_monster():
	var spawn_distance = 10.0 
	var random_offset_range = 2.0
	var random_offset = Vector3(
		(randf() * 2 - 1) * random_offset_range, 
		0,
		(randf() * 2 - 1) * random_offset_range  
	)

	# Calculate the spawn position behind the player
	var player_position = $player.global_transform.origin
	var player_direction = -$player.global_transform.basis.z.normalized()
	var spawn_position = player_position + (player_direction * spawn_distance) + random_offset

	# Instantiate the monster and set its position
	var monster_instance = monster_scene.instantiate()
	monster_instance.global_transform.origin = spawn_position
	add_child(monster_instance)
	
	monster_in_scene = true
	
func _on_monster_spawn_timer_timeout() -> void:
	if not monster_in_scene:
		spawn_monster()
		$monster_spawn_timer.wait_time = randi_range(1, 10)
