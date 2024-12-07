extends Node2D





func go_to_level():
	print("nos vamos al nivel")
	get_tree().change_scene("res://levels/test_level.tscn")


func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		go_to_level()



