extends CharacterBody3D

class_name Player

const SPEED = 15

func _ready():
	$player_helper/survivor/AnimationPlayer.play("Armature|Armature|ANIM-SurvivorA-Idle")
	

func _process(delta: float) -> void:
	default_movement(delta)
	
func default_movement(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var camera_basis = $THIRD.global_transform.basis
	var direction = (camera_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		var desired_angle = atan2(direction.x, direction.z)
		var current_angle = rotation.y
		var rotation_speed = 3.0
		var new_angle = lerp_angle(current_angle, desired_angle, delta * rotation_speed)
		
		if not input_dir.y > 0:
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
	if not input_dir.y > 0:
		update_camera()

func update_camera():
	var camera = $THIRD
	var camera_distance = -5.0  # Positive value to place camera behind the player
	var camera_height = 4.0

	var player_transform = global_transform
	var player_position = player_transform.origin
	var player_direction = -player_transform.basis.z.normalized()

	var camera_position = player_position - player_direction * camera_distance
	camera_position.y += camera_height

	camera.global_transform.origin = camera_position
	camera.look_at(player_position, Vector3.UP)
