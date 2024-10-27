extends Node3D
@onready var timer: Timer = $GameTimer
@onready var player = $player
var enemy = preload("res://enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
func _physics_process(delta: float) -> void:
	get_tree().call_group("enemies","update_target_location",player.global_transform.origin)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_GameTimerTimeout() -> void:
	queue_free()
	
	


func _on_game_timer_timeout() -> void:
	var player_pos = player.get_position()
	var instance = enemy.instantiate()
	instance.position = player_pos
	instance.position.x = instance.position.x-10
	#get_tree().create_timer(10.0).timeout
	add_child(instance)


func _on_player_gameover() -> void:
	get_tree().change_scene_to_file("res://End_Scene/End_Screen_Scenes/end_screen.tscn")
