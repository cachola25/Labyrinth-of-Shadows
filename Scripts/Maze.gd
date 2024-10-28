extends Node3D

@onready var player = $player
@onready var monster_scene = preload("res://scenes/Monster.tscn")
var monster_in_scene = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for cookie in $Cookies.get_children():
		cookie.connect("play_chomp", _on_play_chomp)
	for battery in $Batteries.get_children():
		battery.connect("play_beep", _on_play_beep)
	$player.connect("gameover",_on_player_gameover)
	
func _process(delta: float) -> void:
	pass
		
func spawn_monster():
	var spawn_distance = 12.0 
	var random_offset_range = 1.0
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
		
func _on_player_gameover() -> void:
	get_tree().change_scene_to_file("res://End_Scene/End_Screen_Scenes/end_screen.tscn")
	
func _on_play_chomp():
	#$ChompSound.play()
	pass
	
func _on_play_beep():
	#$BeepNoise.play()
	pass
