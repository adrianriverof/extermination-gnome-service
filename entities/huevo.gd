extends Spatial


onready var level = get_parent()

var damaged = false


func _ready():
	play_normal_animation()
	

func _on_AnimationPlayer_animation_finished(anim_name):
	play_normal_animation()

func damage():
	$DamageCooldown.start()
	if !damaged:
		play_hitted_animation()
		damaged = true
		
		level.score_manager.golpear_huevo()
		
	elif $DamageCooldown.is_stopped():
		# dar puntos por golpear
		pass
	



func play_normal_animation():
	$AnimationPlayer.play("IDDLE001")

func play_hitted_animation():
	$AnimationPlayer.play("bumbum 1001")

func play_ending_animation():
	$AnimationPlayer.play("IDDLE003")


func _on_Timer_timeout():
	play_ending_animation()
