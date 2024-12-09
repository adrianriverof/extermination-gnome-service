extends KinematicBody

onready var level = get_parent().get_parent()


onready var idle_anim_time = 3
onready var idle_anim_random_thereshold = 1

export var lanza_al_jugador = true
export var camina = false

func _ready():
	if camina:
		animacion_caminar()
	else:
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



func animacion_caminar():
	#print("timeout")
	$Timer.stop()
	$CUCAPARED/AnimationPlayer.play("CUP WALKING")
	
	#animacion_caminar()

func _on_Timer_timeout():
	#print("timeout")
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
	




func _on_Area_body_entered(body):
	if body.name == "Player" and lanza_al_jugador and not body.is_on_floor():
#
#		var local_push_direction = Vector3.RIGHT
#		var global_push_direction = global_transform.basis.xform(local_push_direction).normalized()
#
		
		var action_event_press = InputEventAction.new()
		action_event_press.action = "jump"  # Especifica la acción "jump"
		action_event_press.pressed = true
		Input.parse_input_event(action_event_press)

		# Esperar un pequeño momento antes de simular que se suelta la acción
		yield(get_tree().create_timer(0.1), "timeout")  # Puedes ajustar el tiempo si es necesario

		# Crear el evento de acción liberada para "jump"
		var action_event_release = InputEventAction.new()
		action_event_release.action = "jump"  # Especifica la acción "jump"
		action_event_release.pressed = false
		Input.parse_input_event(action_event_release)

		
		









func _on_AnimationPlayer_animation_finished(anim_name):
	#print("repeat")
	if anim_name == "CUP WALKING":
		$CUCAPARED/AnimationPlayer.play("CUP WALKING")



