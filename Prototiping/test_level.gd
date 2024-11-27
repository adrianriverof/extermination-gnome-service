extends Spatial


export var reset_on_timeout = true

export var total_time = 20
onready var time_view = $UI/RichTextLabel


func _physics_process(delta):
	
	
	total_time -= delta
	
	time_view.text = str("%2.2f" % total_time)
	
	if total_time <= 0:
		total_time = 0
		if reset_on_timeout:
			get_tree().reload_current_scene()
		
