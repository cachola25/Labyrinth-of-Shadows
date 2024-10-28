extends Node3D

@onready var maze_scene = get_tree().root.get_child(0)
@onready var player_scene = get_parent()
@onready var monster_in_view = false
@onready var monster_scene
@onready var flashlight_rays = [$survivor/RayCast3D, $survivor/RayCast3D2, $survivor/RayCast3D3]

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if monster_in_view:
		check_line_of_sight()
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is monster and $survivor/SpotLight3D.light_energy > 0:
		monster_scene = body
		monster_in_view = true

func check_line_of_sight():
	for i in range(len(flashlight_rays)):
		if flashlight_rays[i].is_colliding():
			if flashlight_rays[i].get_collider() is monster:
				despawn_monster()

func despawn_monster():
	if not monster_scene:
		return
	monster_scene.queue_free()
	maze_scene.monster_in_scene = false
	maze_scene.get_node("monster_spawn_timer").start()

func _on_flashlight_area_body_exited(body: Node3D) -> void:
	if body is monster or $survivor/SpotLight3D.light_energy <= 0:
		monster_in_view = false
