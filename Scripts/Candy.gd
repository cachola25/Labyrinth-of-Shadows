extends Area3D

signal play_chomp
var collected = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Rotates Cookie
	rotate_y(0.01)
	
func _on_body_entered(body):
	#Plays chomping sound when player runs over coin
	if body is Player:
		emit_signal("play_chomp")
		#Delete cookie when picked up
		$ChompSound.play()
		var curr_time_text = body.get_parent().get_node("UI").get_node("Minutes").text
		var curr_seconds_text = curr_time_text.substr(3,5)
		var curr_seconds = int(curr_seconds_text)
		if curr_seconds_text[0] == "0":
			curr_seconds = int(curr_seconds_text[1])
		curr_seconds += 30
		curr_time_text = str(curr_seconds)
		
		queue_free()
 
