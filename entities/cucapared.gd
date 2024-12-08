extends KinematicBody

onready var level = get_parent().get_parent()

func damage():
	#print("...enemy damaged")
	level.add_score(100)
	queue_free()

