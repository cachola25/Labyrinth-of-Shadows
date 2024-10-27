extends Node3D

@onready var maze_scene = get_tree().root.get_child(0)
@onready var player_scene = get_parent()
@onready var monster_in_view = false
@onready var monster_scene

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if monster_in_view:
		print("monster in view")
		check_line_of_sight()
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is monster and $survivor/SpotLight3D.light_energy > 0:
		monster_scene = body
		monster_in_view = true

func check_line_of_sight():
	var from = player_scene.current_camera.global_transform.origin 
	var forward = player_scene.current_camera.global_transform.basis.z.normalized()
	var to = from + forward * $survivor/SpotLight3D.spot_range
	var space_state = get_world_3d().direct_space_state

	# Create a new PhysicsRayQueryParameters3D object
	var query = PhysicsRayQueryParameters3D.new()
	query.from = from
	query.to = to
	query.exclude = [self, player_scene.current_camera]
	query.collision_mask = (1 << 2) | (1 << 3)

	# Perform the raycast
	var result = space_state.intersect_ray(query)
	
	if result:
		var collider = result.collider
		if collider is monster:
			# Line of sight is clear; no obstacles between player and monster
			print("Line of sight is clear; no obstacles between player and monster")
			despawn_monster(monster_scene)
		else:
			# There is an obstacle between player and monster
			print("There is an obstacle between player and monster")
			print(collider)
			pass
	else:
		despawn_monster(monster_scene)

func despawn_monster(monster_scene):
	if not monster_scene:
		return
	monster_scene.queue_free()
	maze_scene.monster_in_scene = false
	maze_scene.get_node("monster_spawn_timer").start()


func _on_flashlight_area_body_exited(body: Node3D) -> void:
	if body is monster or $survivor/SpotLight3D.light_energy <= 0:
		monster_in_view = false
		print("cant see monster anymore")
