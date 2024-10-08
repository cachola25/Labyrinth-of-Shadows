extends Node3D
@onready var timer: Timer = $GameTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_GameTimerTimeout() -> void:
	queue_free()
	
	
