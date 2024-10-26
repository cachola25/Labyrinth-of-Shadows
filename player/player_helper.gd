extends Node3D

@onready var maze_scene = get_tree().root.get_child(0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	print(body)
	if body is monster and $survivor/SpotLight3D.light_energy > 0:
		body.queue_free()
		maze_scene.monster_in_scene = false
