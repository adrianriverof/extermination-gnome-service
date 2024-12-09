extends Node2D


onready var skiplabel = $INTROPLAYER/RichTextLabel
onready var skiptimer = $SkipTextTimer

func _ready():
	skiplabel.visible = false
	

func go_to_menu():
	
	var level_preload = preload("res://scenes/main_menu.tscn")
	print("nos vamos al menú")
	get_tree().change_scene("res://scenes/main_menu.tscn")


func _input(event):
	if Input.is_action_just_pressed("shoot") or Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		if skiplabel.visible == false:
			skiplabel.visible = true
			
		$PassTimer.start()
	
	if Input.is_action_just_released("shoot") or Input.is_action_just_released("ui_accept") or Input.is_action_just_released("ui_cancel"):
		$PassTimer.stop()
		skiptimer.start()

func _on_SkipTextTimer_timeout():
	skiplabel.visible = false


func _on_PassTimer_timeout():
	go_to_menu()


func _on_Button_button_down():
	go_to_menu()




