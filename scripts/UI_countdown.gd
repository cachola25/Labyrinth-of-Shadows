extends Control

@onready var Gametimer: Timer = $Countdown
@onready var time: Label = $Minutes
var seconds
var minutes
var cookie_collected = false

#var collected = candy.collected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Gametimer.start()
	for cookie in get_parent().get_node("Cookies").get_children():
		cookie.connect("collected", _on_cookie_collected)

func time_left_to_live():
	var timeLeft = Gametimer.time_left
	
	#Update times
	minutes = floor(timeLeft / 60)
	seconds = int(timeLeft) % 60

	return [minutes, seconds]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time.text = "%02d:%02d" % time_left_to_live()
	

func stop() -> void:
	#Stops timer
	set_process(false)
	
func _on_cookie_collected():
	var time_left = Gametimer.time_left
	Gametimer.stop()
	Gametimer.start(time_left + 30)
	
