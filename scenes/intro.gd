extends Node2D



func _ready():
	$RichTextLabel.visible = false

func go_to_menu():
	print("nos vamos al menú")
	get_tree().change_scene("res://scenes/main_menu.tscn")


func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		if $RichTextLabel.visible == false:
			$RichTextLabel.visible = true
		else:
			go_to_menu()
