extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_body_entered(body):
	#Play beep noise when battery is picked up
	$BeepNoise.play()
	#Delete battery when it is picked up
	queue_free()
	
