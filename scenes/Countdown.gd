extends CanvasLayer




func _ready():
	#Engine.time_scale = 0
	get_tree().paused = true
	
	randomize()
	var number = (randi() % 4 )
	print(number)
	$Gnometips.frame = number
	
#	for i in range(100):
#		print(randi() % 4)
	
func shake_number():
	$numbers/ShakeTween.start()


func _on_Timer_timeout():
	start_level()

func start_level():
	Engine.time_scale = 1
	get_tree().paused = false
	get_parent().start_level()
	queue_free()
