extends CanvasLayer



onready var levelscene = ("res://levels/level_1.tscn")
onready var menuscene = ("res://scenes/main_menu.tscn")

func _ready():
	
	Engine.time_scale = 0.5
	get_parent().stop_player_control()
	$FinalScoreText.text = get_parent().get_score_text()
	

func _physics_process(delta):
	Engine.time_scale -= delta

func go_to_menu():
	print("nos vamos al menú")
	get_tree().paused = false
	get_tree().change_scene(menuscene)


func go_to_level():
	print("nos vamos al nivel")
	get_tree().paused = false
	get_tree().change_scene(levelscene)



func _on_ButtonMenu_pressed():
	go_to_menu()
	queue_free()
	
	




func _on_ButtonPlay_pressed():
	go_to_level()
	queue_free()
