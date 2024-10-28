extends Area3D

signal play_chomp
signal collected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Rotates Cookie
	rotate_y(0.01)
	
func _on_body_entered(body):
	if body is Player:
		#Plays chomping sound when player runs over coin
		emit_signal("play_chomp")
		emit_signal("collected")
		queue_free()
 
