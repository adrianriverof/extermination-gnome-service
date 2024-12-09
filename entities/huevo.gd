extends Spatial


onready var level = get_parent()

var damaged = false

onready var impact_scene = preload("res://particles/huevo_particulas.tscn")

func _ready():
	play_normal_animation()
	

func _on_AnimationPlayer_animation_finished(anim_name):
	play_normal_animation()

func damage():
	
	
	if !damaged:
		play_hitted_animation()
		damaged = true
		
		level.score_manager.golpear_huevo()
		
	elif $DamageCooldown.is_stopped():
		# dar puntos por golpear
		print("golpeado")
		play_hitted_animation()
		pass
	
	level.play_huevo_sound()
	$DamageCooldown.start()
	
	
	var impact_instance = impact_scene.instance()
	impact_instance.translation = self.translation
	get_parent().add_child(impact_instance)
	queue_free()



func play_normal_animation():
	$AnimationPlayer.play("IDDLE001")

func play_hitted_animation():
	$AnimationPlayer.play("bumbum 1001")

func play_ending_animation():
	$AnimationPlayer.play("IDDLE003")


func _on_Timer_timeout():
	play_ending_animation()
