extends CanvasLayer




func _ready():
	#Engine.time_scale = 0
	get_tree().paused = true

func _on_Timer_timeout():
	Engine.time_scale = 1
	get_tree().paused = false
	get_parent().start_level()
	queue_free()


