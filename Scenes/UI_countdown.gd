extends Control

#Timer vars
var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Update times
	time += delta
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	
	#Updates time in proper form
	$Minutes.text = "%02d:" % minutes
	$Seconds.text = "%02d." % seconds
	$Msecs.text = "%3d" % msec
	
	#Cookie updating
	#if Candy.collected == true:
		#seconds - 30
		#Candy.collected = false
		
	#CHANGE TO MAKE POP UP
	if minutes == 5:
		stop()
		
	
	
func stop() -> void:
	#Stops timer
	set_process(false)
	
	
func get_time_formatted() -> String:
	#Prints times nicely
	return "%02d:%02d.%03d" % [minutes, seconds, msec]
	
