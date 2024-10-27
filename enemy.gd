extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 4.5
@onready var nav = $NavigationAgent3D
var direction_vector = Vector3.ZERO
var target = Vector3.ZERO
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if target != Vector3.ZERO:
		direction_vector.x = target.x
		direction_vector.z = target.z
		var current_location = global_transform.origin
	#if direction_vector != Vector3.ZERO:
		#var desired_angle = atan2(direction_vector.x, direction_vector.z)
		#var current_angle = rotation.y
		#var rotation_speed = 5.0
		#var new_angle = lerp_angle(current_angle, desired_angle, delta * rotation_speed)
		look_at(target)
		rotation.y = rotation.y*-PI/2
		$alien/AnimationPlayer.play("Armature|Armature|ArmatureAction")
		var next_location = nav.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		velocity = velocity.move_toward(new_velocity,.25)
	#else:
		#var next_location = nav.get_next_path_position()
		#var new_velocity = (next_location - current_location).normalized() * SPEED
		#velocity = velocity.move_toward(new_velocity,.25)
		
		move_and_slide()
func update_target_location(target_location):
	nav.target_position = target_location 
	target = target_location
