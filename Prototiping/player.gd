# Author Kamyab Nazari - 2021

extends KinematicBody

# Playercontroller for movement

#onready var spell_controller = $SpellController
#onready var _transition = $SceneTransition;

onready var impact_scene = preload("res://Prototiping/impact.tscn")


# Constant variables for Movement
export var SPEED = 30
export var GRAVITY = 20
export var JUMP = 8
export var FALL_MULTY = 1
export var JUMP_MULTY = 1
export var CAM_ACCEL = 40
export var ACCEL_TYPE = {"default": 10, "air": 1}

# Strafe leaning
const LEAN_SMOOTH : float = 10.0
const LEAN_MULT : float = 0.066
const LEAM_AMOUNT : float = 0.7

# Mouse sensitivity
var mouse_sense = 0.3
var snap

var currentStrafeDir = 0

var double_jump_charged = true



# Vectors for movement
var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

# Onready variables
onready var accel = ACCEL_TYPE["default"]
onready var head = $Head
onready var camera = $Head/Camera

onready var WallCastRight = $Laterals/WallCastRight
onready var WallCastLeft = $Laterals/WallCastLeft


var is_dashing = false
var dash_speed = 20
var dash_duration = 0.3
var original_head_height = 0.5
var lowered_head_height = -0.5


func _ready():
	randomize()
	# Hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	OS.set_window_always_on_top(true) # !!! esto lo quitaré
	



func _manage_mouse_capture():
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("shoot"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _input(event):
	
	_manage_mouse_capture()	
	
	# Get mouse input for camera rotation
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func theres_wall_right():
	if WallCastRight.is_colliding() and !is_on_floor():
		if WallCastRight.get_collider().get_parent().name == "structure":
			return true 
	return false
#	WallCastRight.is_colliding()

func theres_wall_left():
	if WallCastLeft.is_colliding() and !is_on_floor():
		if WallCastLeft.get_collider().get_parent().name == "structure":
			return true 
	return false


func is_wallruning():
	return (theres_wall_left() or theres_wall_right())
	

func _get_keyboard_input():
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
func _move(delta):
	
	
	
	velocity = velocity.linear_interpolate(direction * SPEED, accel * delta)
	if(gravity_vec > Vector3.ZERO):
		movement = velocity + gravity_vec * JUMP_MULTY
	elif(gravity_vec < Vector3.ZERO):
		movement = velocity + gravity_vec * FALL_MULTY
	else:
		movement = velocity + gravity_vec
	
	if is_wallruning():
		#print("is wallruning")
		
		#movement.y = 0
		#velocity.y = 0
		SPEED = 20
	elif is_dashing:
		SPEED = 20
		
	else:
		SPEED = 10
		
	# warning-ignore:return_value_discarded
	move_and_slide_with_snap(movement, snap, Vector3.UP)

func _shoot():
	if Input.is_action_pressed("shoot"):
		#spell_controller.cast()
		#print("disparamos")
		var shotgun = $CanvasLayer/Control/shotgun_sprite 
		if !shotgun.playing or shotgun.frame == 6:
			shotgun.frame = 0
			shotgun.playing = true
			
			var raycast = $Head/Camera/RayCast
			
			
			for n in range(6):
				randomize()
				#print("---", n)
				var spread = 5
				
				raycast.cast_to.x = rand_range(-spread, spread)
				raycast.cast_to.y = rand_range(-spread, spread)
				#print(raycast.cast_to)
				#print(rand_range(-spread, spread))
				
				raycast.force_raycast_update()
				
				var coll = raycast.get_collider()
				var coll_point = raycast.get_collision_point()
				#print("punto de colisión = ", coll_point)
				
				if raycast.is_colliding():
					if coll.has_method("damage"):
						coll.damage()
						#spawn_impact_at(coll_point)
					else:
						#print("spawn impact")
						#print(coll_point)
						pass
				
				spawn_impact_at(coll_point)

func dash():
	if is_dashing:
		return # Evita múltiples dashes simultáneos
	
	is_dashing = true
	# Reduce la altura de la cámara
	lower_head_height(lowered_head_height, dash_duration * 0.5)
	
	# Mueve al personaje hacia adelante rápidamente
#	var dash_vector = transform.basis.z * dash_speed
#	move_and_slide(dash_vector)

	# Espera el tiempo del dash
	yield(get_tree().create_timer(dash_duration), "timeout")
#
	# Regresa la cámara a su altura original
	lower_head_height(original_head_height, dash_duration * 0.5)
	is_dashing = false

func lower_head_height(target_height: float, duration: float):
	var tween = $Tween
	tween.stop_all() # Detén cualquier animación previa
	tween.interpolate_property(
		$Head,
		"translation:y", # Animamos la posición Y de la cabeza
		$Head.translation.y, # Valor actual
		target_height, # Nueva altura
		duration, # Duración
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	tween.start()
func tilt_camera(target_angle: float, duration: float = 0.5):
	var tween = $Head/Camera/CameraTween
	# Detén cualquier animación previa que esté en curso
	tween.stop_all()
	# Aplica la rotación suavemente al eje Z
	tween.interpolate_property(
		$Head/Camera,
		"rotation_degrees:z", 
		$Head/Camera.rotation_degrees.z, # Valor actual
		target_angle, # Valor objetivo
		duration, # Duración de la interpolación
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	tween.start()

func _physics_process(delta):
	
	
	if Input.is_action_pressed("dash") and is_on_floor() and $DashCooldownTimer.is_stopped() and movement != Vector3.ZERO:
		print("dash")
		$DashCooldownTimer.start()
		dash()
		
	
	if theres_wall_right():
		tilt_camera(30) # Inclinación a la derecha
	elif theres_wall_left():
		tilt_camera(-30) # Inclinación a la izquierda
	else:
		tilt_camera(0) # Regresa a posición neutra
	
	
	
	# Get keyboard input
	_get_keyboard_input()
	
	
	# Jumping and gravity
	if is_on_floor() or is_wallruning():
		snap = -get_floor_normal()
		accel = ACCEL_TYPE["default"]
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_TYPE["air"]
		gravity_vec += Vector3.DOWN * GRAVITY * delta
	
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			double_jump_charged = true
			snap = Vector3.ZERO
			gravity_vec = Vector3.UP * JUMP
		elif  is_wallruning():
			
			var walljumpdirection = 0
			if theres_wall_right():
				walljumpdirection = -1 
			elif theres_wall_left():
				walljumpdirection = 1 
			
			
			direction = Vector3(walljumpdirection, 0, 0).rotated(Vector3.UP, global_transform.basis.get_euler().y).normalized()
			SPEED = 200
			
			
			double_jump_charged = true
			snap = Vector3.ZERO
			gravity_vec = Vector3.UP * JUMP
		elif double_jump_charged:
			snap = Vector3.ZERO
			gravity_vec = Vector3.UP * JUMP
			double_jump_charged = false
	
	# Moving
	_move(delta)
	
	
	_shoot()
	


func spawn_impact_at(some_location):
	var impact_instance = impact_scene.instance()
	impact_instance.translation = some_location
	get_parent().add_child(impact_instance)


func _on_Stats_died_signal():
	#var a_player = _transition.fade_in()
	#yield(a_player, "animation_finished")
	queue_free()




