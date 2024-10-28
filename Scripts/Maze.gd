extends Node3D

@onready var timer: Timer = $GameTimer
@onready var player = $player
@onready var monster_scene = preload("res://scenes/Monster.tscn")
var monster_in_scene = false
var global_monster

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
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
	add_child(monster_instance)
	monster_instance.global_transform.origin = spawn_position
	global_monster = monster_instance
	monster_in_scene = true
	
func _on_monster_spawn_timer_timeout() -> void:
	if not monster_in_scene:
		spawn_monster()
		$monster_spawn_timer.wait_time = randi_range(1, 10)
		
# New Function to Handle Game Over Zoom Effect
func _on_player_gameover() -> void:
	$player.is_game_over = true
	var monster_camera = global_monster.get_node("monster_camera")
	monster_camera.make_current()

	# Define the target FOV values
	var original_fov = monster_camera.fov
	var zoom_fov = 20  # Desired zoomed-in FOV
	var zoom_duration = 0.1  # Duration for each zoom step in seconds

	# Create a Tween to animate the FOV
	var tween = get_tree().create_tween()

	# Zoom In
	tween.tween_property(monster_camera, "fov", zoom_fov, zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# Zoom Out
	tween.tween_property(monster_camera, "fov", original_fov, zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_delay(zoom_duration)
	
	for i in range(10):
		tween.tween_property(monster_camera, "fov", zoom_fov, zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_delay(zoom_duration * 2)
		tween.tween_property(monster_camera, "fov", original_fov, zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_delay(zoom_duration * 2)
	
	$player/player_helper/survivor/flashlight.visible = false
	global_monster.get_node("SpotLight3D").light_energy = 1
	$WorldEnvironment.environment.background_energy_multiplier = 1
	$jumpscare_noise.play(3.8)
	$player/player_helper/survivor/AnimationPlayer.play("Armature|Armature|ANIM-SurvivorA-Death")
	
	
func _on_play_chomp():
	$ChompSound.play()
	
func _on_play_beep():
	$BeepNoise.play()

func _on_jumpscare_noise_finished() -> void:
	get_tree().change_scene_to_file("res://End_Scene/End_Screen_Scenes/end_screen.tscn")
