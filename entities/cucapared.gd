extends KinematicBody

onready var level = get_parent().get_parent()

onready var idle_anim_time = 3
onready var idle_anim_random_thereshold = 1

func _ready():
	efectuar_animacion_al_azar()


func damage():
	#print("...enemy damaged")
	level.add_score(100)
	queue_free()





func atoeurtneoru():
	$CUCAPARED/AnimationPlayer.play("CUP ANTENAS")
	$CUCAPARED/AnimationPlayer.play("CUP Alas tiruri")
	$CUCAPARED/AnimationPlayer.play("CUP Breathing")
	$CUCAPARED/AnimationPlayer.play("CUP WALKING")



func _on_Timer_timeout():
	efectuar_animacion_al_azar()


func efectuar_animacion_al_azar():
	var dado = randi() % 2 + 1 # Devuelve un entero aleatoria entre 1 y X
	
	match dado:
		1:
			$CUCAPARED/AnimationPlayer.play("CUP Breathing")
		2:
			$CUCAPARED/AnimationPlayer.play("CUP Alas tiruri")
		3:
			# NO SE USA
			$CUCAPARED/AnimationPlayer.play("CUP WALKING")
	
	$Timer.start(idle_anim_time + (randi() % idle_anim_random_thereshold))
	
	
	
