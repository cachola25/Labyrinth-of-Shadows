extends Node3D

@onready var start = $CanvasLayer/Fader/Control/VBoxContainer/CenterContainer/VBoxContainer/Start
@onready var quit = $CanvasLayer/Fader/Control/VBoxContainer/CenterContainer/VBoxContainer/Quit
@onready var fader = $CanvasLayer/Fader

@export var game_scene: PackedScene

func _ready():
	fader.connect("fade_finished", self.on_fade_finished)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://maze.tscn")
	
func _on_quit_pressed():
	get_tree().quit()

func on_fade_finished():
	get_tree().change_scene_to(game_scene)
 	
