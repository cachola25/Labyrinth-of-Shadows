extends CharacterBody3D

class_name Player

const SPEED = 15
const JUMP_VELOCITY = 10

func _ready():
	$player_helper/survivor/AnimationPlayer.play("Armature|Armature|ANIM-SurvivorA-Idle")
	

func _process(delta: float) -> void:
	default_movement(delta)
	
func default_movement(delta):
	
	var input_dir := Input.get_vector("move_right", "move_left", "move_backward", "move_forward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		$player_helper/survivor/AnimationPlayer.play("Armature|Armature|ANIM-SurvivorA-Jog")
	
	move_and_slide()
