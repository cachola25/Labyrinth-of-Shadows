extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Rotates Cookie
	rotate_y(0.01)
	


func _on_body_entered(body: Node3D) -> void:
	#Plays chomping sound when player runs over coin
	$ChompSound.play()
	#Destroys coins and plays music at same time makes it look nice
	$MeshInstance3D.queue_free()



func _on_chomp_sound_finished() -> void:
	#After sound is played, destroy cookie
	queue_free()
