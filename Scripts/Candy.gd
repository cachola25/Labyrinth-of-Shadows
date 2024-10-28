extends Area3D

var collected: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Rotates Cookie
	rotate_y(0.01)
	


func _on_body_entered(body):
	#Plays chomping sound when player runs over coin
	$ChompSound.play()
	collected = true
	queue_free()
 
