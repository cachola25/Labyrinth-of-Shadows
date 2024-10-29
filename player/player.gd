extends CharacterBody3D

class_name Player

const SPEED = 15
@onready var current_camera = $THIRD
@onready var flashlight_bar = get_parent().get_node("CanvasLayer").get_node("Hud").get_node("flashlight_bar")
@onready var flashlight_light = $player_helper/survivor/SpotLight3D
@onready var flickering_threshold = flashlight_bar.max_value * 0.5

var is_flickering = false
var is_game_over = false

signal gameover
func _ready():
	randomize()
	$player_helper/survivor/AnimationPlayer.play("Armature|Armature|ANIM-SurvivorA-Idle")
	current_camera.current = true
	flashlight_bar.max_value = flashlight_light.light_energy
	

func _process(delta: float) -> void:
	if is_game_over:
		return
		
	if Input.is_action_just_pressed("change_perspective"):
		if current_camera == $THIRD:
			current_camera = $FIRST
		else:
			current_camera = $THIRD
	elif Input.is_action_pressed("toggle_looking_back"):
		$LOOK_BACK.current = true
	else:
		current_camera.current = true
		
	if Input.is_action_just_pressed("flashlight_toggle"):
		if not $flashlight_toggle.playing:
			$flashlight_toggle.play()
		if $flashlight_timer.is_stopped():
			flashlight_light.light_energy = flashlight_bar.value
			$flashlight_timer.start()
			if flashlight_bar.value <= flickering_threshold:
				start_flickering()
		else:
			flashlight_light.light_energy = 0
			$flashlight_timer.stop()
			stop_flickering()
		
		
	default_movement(delta)
	
func default_movement(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var camera_basis = $THIRD.global_transform.basis
	var direction = (camera_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var is_moving_backwards = input_dir.y > 0

	if direction != Vector3.ZERO:
		if not $footsteps.playing:
			$footsteps.play()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		var desired_angle = atan2(direction.x, direction.z)
		var current_angle = rotation.y
		var rotation_speed = 3.0
		var new_angle = lerp_angle(current_angle, desired_angle, delta * rotation_speed)
		
		if not is_moving_backwards:
			rotation.y = new_angle
			$player_helper/survivor.rotation.y = 0
		$player_helper/survivor/AnimationPlayer.play("Armature|Armature|ANIM-SurvivorA-Jog")
	else:
		if $footsteps.playing:
			$footsteps.stop()
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		$player_helper/survivor/AnimationPlayer.play("Armature|Armature|ANIM-SurvivorA-Idle")

	move_and_slide()
	if not is_moving_backwards:
		update_camera()

func update_camera():
	var camera = $THIRD
	var camera_distance = -2.0
	var camera_height = 2.0

	var player_transform = global_transform
	var player_position = player_transform.origin
	var player_direction = -player_transform.basis.z.normalized()

	var camera_position = player_position - player_direction * camera_distance
	camera_position.y += camera_height

	camera.global_transform.origin = camera_position
	camera.look_at(player_position, Vector3.UP)
	camera.rotate_object_local(Vector3.RIGHT, deg_to_rad(20))
		
func _on_flashlight_timer_timeout() -> void:
	if flashlight_light.light_energy > 0:
		flashlight_light.light_energy -= flashlight_bar.step
		flashlight_bar.value -= flashlight_bar.step
		if flashlight_bar.value <= flickering_threshold \
		and not is_flickering \
		and flashlight_light.light_energy > 0:
			start_flickering()
	else:
		flashlight_light.light_energy = 0
		flashlight_bar.value = 0
		stop_flickering()
		$flashlight_timer.stop()

func start_flickering():
	if not is_flickering:
		is_flickering = true
		$start_flicker_timer.start()

func stop_flickering():
	if is_flickering:
		is_flickering = false
		$start_flicker_timer.stop()
		flashlight_light.light_energy = 0

func _on_start_flicker_timer_timeout() -> void:
	if flashlight_light.light_energy > 0:
		var base_energy = flashlight_bar.value
		var flicker_chance = randf()
		if flicker_chance > 0.5:
			flashlight_light.light_energy = base_energy * (0.8 + randf() * 0.4)
		else:
			flashlight_light.light_energy = base_energy * (0.2 + randf() * 0.2)
		flashlight_light.light_energy = max(flashlight_light.light_energy, 0)
	else:
		stop_flickering()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is monster and not is_game_over:
		current_camera.clear_current(true)
		gameover.emit()
