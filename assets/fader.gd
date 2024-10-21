extends ColorRect

@onready var animation_player = $AnimationPlayer

signal fade_finished

func _ready():
	# Using Callable for the connection
	animation_player.connect("animation_finished", Callable(self, "on_animation_finished"))

func on_start_pressed():
	animation_player.play("fade_in")

func fade_out():
	animation_player.play("fade_out")

func on_animation_finished(anim_name: String):
	emit_signal("fade_finished")
