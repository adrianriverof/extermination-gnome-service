extends Spatial


export var reset_on_timeout = true
export var total_time = 20
export var enable_music = true

onready var time_view = $UI/RichTextLabel
var game_end = false


#var domain: CookieClicker
#var presenter: EarnCookie
var score_manager: Scoremanager





var score = 0
onready var combo_indicator = $UI/ComboIndicator
onready var score_view = $UI/ScoreLabel

onready var results_menu = preload("res://scenes/results.tscn")

onready var player = $Player

func stop_player_control():
	player.player_input_active = false

func _ready():
	
	score_manager = Scoremanager.new()
	
	
#	domain = CookieClicker.new()
#	presenter = EarnCookie.new()
#	presenter.EarnCookie(domain, self)
	
	
	if enable_music:
		$AudioStreamPlayer.play()
	
	get_tree().paused = false
	Engine.time_scale = 1


func _physics_process(delta):
	
	score_manager.calculate_time(delta)
	
	_show_score()
	_show_combo_level()
	
	_pass_time(delta)
	
	_show_time()
	
	_end_when_timeout()


func _show_combo_level():
	
	var previous_combo_level = combo_indicator.frame
	combo_indicator.frame = score_manager.select_combo_level_based_on_time()
	#$UI/ComboIndicator.frame = score_manager.get_combo_level() - 1
	
	if combo_indicator.frame != previous_combo_level:
		combo_indicator.get_node("ShakeTween").start()


func _pass_time(delta):
	total_time -= delta

func _show_score():
	
	#score_view.text = str(score)
	score_view.text = str(score_manager.get_score())
	
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
	#score += points
	score_manager.add_score(points)






func respawn_player():
	player.velocity = Vector3.ZERO
	player.translation = Vector3(-43.317, 4.475, 0.217)
	player.rotation_degrees = Vector3(0,-89.747,0)
	player.head.rotation_degrees = Vector3.ZERO



func _on_Water_body_entered(body):
	print("cuerpo al agua")
	if body.name == "Player":
		respawn_player()
	
	# aquí podemos hacerles damages a los enemigos



