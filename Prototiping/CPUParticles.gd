extends CPUParticles



func _ready():
	#print("impact appear")
	#print("estoy en ",self.global_translation)
	emitting = true
	one_shot = true




func _on_Timer_timeout():
	get_parent().queue_free()
