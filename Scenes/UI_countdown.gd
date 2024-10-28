extends Control

@onready var Gametimer: Timer = $Countdown
@onready var time: Label = $Minutes
var seconds
var minutes
#var collected = candy.collected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Gametimer.start()

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
	
	
