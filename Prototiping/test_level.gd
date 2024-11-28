extends Spatial


export var reset_on_timeout = true

export var total_time = 20
onready var time_view = $UI/RichTextLabel

onready var results_menu = preload("res://scenes/results.tscn")


func _physics_process(delta):
	
	
	total_time -= delta
	
	time_view.text = str("%2.2f" % total_time)
	
	if total_time <= 0:
		total_time = 0
		if reset_on_timeout:
			show_results()



func reload_level():
	get_tree().reload_current_scene()

func show_results():
	
	get_tree().get_root().add_child(results_menu.instance())
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#$Results.visible = true
	$Player.pause_mode = Node.PAUSE_MODE_STOP
	self.pause_mode = PAUSE_MODE_STOP
	
	
