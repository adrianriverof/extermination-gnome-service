extends Node2D


onready var skiplabel = $INTROPLAYER/RichTextLabel
onready var skiptimer = $SkipTextTimer

func _ready():
	skiplabel.visible = false

func go_to_menu():
	print("nos vamos al menú")
	get_tree().change_scene("res://scenes/main_menu.tscn")


func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		if skiplabel.visible == false:
			skiplabel.visible = true
			skiptimer.start()
		else:
			go_to_menu()


func _on_SkipTextTimer_timeout():
	skiplabel.visible = false