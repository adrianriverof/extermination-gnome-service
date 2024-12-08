extends Spatial


export var reset_on_timeout = true
export var total_time = 20
export var enable_music = true

onready var time_view = $UI/RichTextLabel
var game_end = false


var score = 0
onready var score_view = $UI/ScoreLabel

onready var results_menu = preload("res://scenes/results.tscn")

onready var player = $Player

func stop_player_control():
	player.player_input_active = false

func _ready():
	
	if enable_music:
		$AudioStreamPlayer.play()
	
	get_tree().paused = false
	Engine.time_scale = 1
func _physics_process(delta):
	
	_show_score()
	
	_pass_time(delta)
	
	_show_time()
	
	_end_when_timeout()




func _pass_time(delta):
	total_time -= delta

func _show_score():
	score_view.text = str(score)
func _show_time():
	time_view.text = str("%2.2f" % total_time)
func _end_when_timeout():
	if total_time <= 0:
		total_time = 0
		if reset_on_timeout and !game_end:
			game_end = true
			show_results()
			#Engine.time_scale = 0.1

func reload_level():
	get_tree().reload_current_scene()

func show_results():
	
	add_child(results_menu.instance())
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#$Results.visible = true
	player.pause_mode = Node.PAUSE_MODE_STOP
	self.pause_mode = PAUSE_MODE_STOP
	

func add_score(points:int):
	score += points







func respawn_player():
	player.velocity = Vector3.ZERO
	player.translation = Vector3(-43.317, 4.475, 0.217)



func _on_Water_body_entered(body):
	print("cuerpo al agua")
	if body.name == "Player":
		respawn_player()
	
	# aquí podemos hacerles damages a los enemigos



