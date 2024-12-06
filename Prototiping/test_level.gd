extends Spatial


export var reset_on_timeout = true

export var total_time = 20
onready var time_view = $UI/RichTextLabel
var game_end = false


var score = 0
onready var score_view = $UI/ScoreLabel


onready var results_menu = preload("res://scenes/results.tscn")

func stop_player_control():
	$Player.player_input_active = false

func _ready():
	get_tree().paused = false
	Engine.time_scale = 1
func _physics_process(delta):
	
	
	score_view.text = str(score)
	
	total_time -= delta
	
	time_view.text = str("%2.2f" % total_time)
	
	if total_time <= 0:
		total_time = 0
		if reset_on_timeout and !game_end:
			game_end = true
			show_results()
			Engine.time_scale = 0.1



func reload_level():
	get_tree().reload_current_scene()

func show_results():
	
	add_child(results_menu.instance())
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#$Results.visible = true
	$Player.pause_mode = Node.PAUSE_MODE_STOP
	self.pause_mode = PAUSE_MODE_STOP
	

func add_score(points:int):
	score += points

