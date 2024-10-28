extends Control

@onready var timer: Timer = $Countdown
@onready var time: Label = $Minutes
@onready var seconds: Label = $Seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()

func time_left_to_live():
	var timeLeft = timer.time_left
	
	#Update times
	var minutes = floor(timeLeft / 60)
	var seconds = int(timeLeft) % 60

	#Cookie updating
	#if Candy.collected == true:
		#seconds + 30
		#Candy.collected = false
	return [minutes, seconds]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time.text = "%02d:%02d" % time_left_to_live()
	

func stop() -> void:
	#Stops timer
	set_process(false)
	
	
