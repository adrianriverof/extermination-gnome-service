extends Node2D



func go_to_menu():
	print("nos vamos al menú")
	get_tree().change_scene("res://scenes/main_menu.tscn")


func go_to_level():
	print("nos vamos al nivel")
	get_tree().change_scene("res://Prototiping/test_level.tscn")



func _on_ButtonMenu_pressed():
	go_to_menu()
	print("eeeeee")
	print(queue_free())
	




func _on_ButtonPlay_pressed():
	go_to_level()
	queue_free()
