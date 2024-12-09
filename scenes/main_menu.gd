extends Node2D


onready var levelscene = ("res://levels/level_2.tscn")

func _ready():
	$AudioStreamPlayer.play()

func go_to_level():
	var level_preload = preload("res://levels/level_2.tscn")
	print("nos vamos al nivel")
	get_tree().change_scene(levelscene)


func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		go_to_level()


func _on_Button_button_down():
	go_to_level()
