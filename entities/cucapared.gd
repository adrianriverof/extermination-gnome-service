extends KinematicBody

func damage():
	#print("...enemy damaged")
	get_parent().add_score(100)
	queue_free()

