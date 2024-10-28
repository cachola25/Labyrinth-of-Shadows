extends Node3D

@onready var start = $CanvasLayer/Fader/Control/VBoxContainer/CenterContainer/VBoxContainer/Start
@onready var quit = $CanvasLayer/Fader/Control/VBoxContainer/CenterContainer/VBoxContainer/Quit
@onready var fader = $CanvasLayer/Fader

@export var game_scene: PackedScene

func _ready():
	start.pressed.connect(self.on_start_pressed)
	quit.pressed.connect(self.on_quit_pressed)
	fader.connect("fade_finished", self.on_fade_finished)

func on_start_pressed():
	get_tree().change_scene_to_file("res://maze.tscn")

func on_quit_pressed():
	get_tree().quit()

func on_fade_finished():
	get_tree().change_scene_to(game_scene)
 	
