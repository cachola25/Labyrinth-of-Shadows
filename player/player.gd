extends CharacterBody3D

class_name Player

const SPEED = 15
@onready var current_camera = $THIRD
@onready var flashlight_bar = get_parent().get_node("CanvasLayer").get_node("Hud").get_node("flashlight_bar")

var curr_flashlight_value

func _ready():
	$player_helper/survivor/AnimationPlayer.play("Armature|Armature|ANIM-SurvivorA-Idle")
	
	current_camera.current = true
	flashlight_bar.max_value = $player_helper/survivor/SpotLight3D.light_energy
	

func _process(delta: float) -> void:
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
		if $flashlight_timer.is_stopped():
			$player_helper/survivor/SpotLight3D.light_energy = curr_flashlight_value
			$flashlight_timer.start()
		else:
			curr_flashlight_value = $player_helper/survivor/SpotLight3D.light_energy
			$player_helper/survivor/SpotLight3D.light_energy = 0
			$flashlight_timer.stop()
		
		
	default_movement(delta)
	
func default_movement(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var camera_basis = $THIRD.global_transform.basis
	var direction = (camera_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var is_moving_backwards = input_dir.y > 0

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		var desired_angle = atan2(direction.x, direction.z)
		var current_angle = rotation.y
		var rotation_speed = 3.0
		var new_angle = lerp_angle(current_angle, desired_angle, delta * rotation_speed)
		
		if not is_moving_backwards:
			rotation.y = new_angle
			$player_helper/survivor.rotation.y = 0
		else:
			$player_helper/survivor.rotation.y = PI
		$player_helper/survivor/AnimationPlayer.play("Armature|Armature|ANIM-SurvivorA-Jog")
	else:
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
	if $player_helper/survivor/SpotLight3D.light_energy > 0:
		$player_helper/survivor/SpotLight3D.light_energy -= flashlight_bar.step
		flashlight_bar.value -= flashlight_bar.step
