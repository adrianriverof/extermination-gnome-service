extends CanvasLayer


var final_score = 0

var yes = 0
var no = 1

onready var levelscene = ("res://levels/level_2.tscn")
onready var menuscene = ("res://scenes/main_menu.tscn")

export var combo_bonuses = true
var combo_bonuses_boolean = 0

onready var level = get_parent()

func _ready():
	
	if combo_bonuses:
		combo_bonuses_boolean = 1
	
	
	$Destroyed6YesNoIndicator.frame = no
	$Destroyed3YesNoIndicator.frame = no
	$"10scomboYesNoIndicator".frame = no
	$"15scomboYesNoIndicator".frame = no
	
	Engine.time_scale = 0.5
	get_parent().stop_player_control()
	
	final_score = get_parent().get_score_number()
	
	
	
	if level.get_result_huevo_golpeado():
		$Destroyed3YesNoIndicator.frame = yes
	
	if level.get_result_huevo_golpeado_ultimo_segundo():
		$Destroyed6YesNoIndicator.frame = yes
	
	#level.score_manager.update_max_combo()
	
	var max_combo = level.score_manager.max_combo_time
	print("max_combo: ", max_combo)
	
	if max_combo > 15.0:
		$"15scomboYesNoIndicator".frame = yes
		final_score *= 5*combo_bonuses_boolean
		
	elif max_combo > 10.0:
		
		$"10scomboYesNoIndicator".frame = yes
		final_score *= 3*combo_bonuses_boolean
	
		
	
	$FinalScoreText.text = str(final_score)

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
