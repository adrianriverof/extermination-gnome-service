extends Node2D


onready var skiplabel = $INTROPLAYER/RichTextLabel

func _ready():
	skiplabel.visible = false

func go_to_menu():
	print("nos vamos al menú")
	get_tree().change_scene("res://scenes/main_menu.tscn")


func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		if skiplabel.visible == false:
			skiplabel.visible = true
			
		else:
			go_to_menu()
