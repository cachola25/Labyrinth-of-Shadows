extends Area3D

signal play_beep
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_body_entered(body):
	if body is Player:
		#Play beep noise when battery is picked up
		emit_signal("play_beep")
		var time = body.get_parent().get_node("UI_countdown")
		time.seconds += 30
		#Delete battery when it is picked up
		queue_free()
	
