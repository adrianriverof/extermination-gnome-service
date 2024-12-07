extends Node2D






func _ready():
	
	#get_tree().paused = true
	get_parent().stop_player_control()
	

func go_to_menu():
	print("nos vamos al menú")
	get_tree().paused = false
	get_tree().change_scene("res://scenes/main_menu.tscn")


func go_to_level():
	print("nos vamos al nivel")
	get_tree().paused = false
	get_tree().change_scene("res://levels/test_level.tscn")



func _on_ButtonMenu_pressed():
	go_to_menu()
	queue_free()
	
	




func _on_ButtonPlay_pressed():
	go_to_level()
	queue_free()
