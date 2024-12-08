extends Node2D


onready var levelscene = ("res://levels/level_1.tscn")

func go_to_level():
	print("nos vamos al nivel")
	get_tree().change_scene(levelscene)


func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		go_to_level()



