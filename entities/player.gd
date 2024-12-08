# Based on work by Kamyab Nazari - 2021

extends KinematicBody

# Playercontroller for movement

#onready var spell_controller = $SpellController
#onready var _transition = $SceneTransition;

onready var impact_scene = preload("res://Prototiping/impact.tscn")

onready var level = get_parent()


# Constant variables for Movement
var SPEED = 30

export var Run_Speed = 15
export var Wall_Speed = 20
export var Dash_Speed = 20

export var GRAVITY = 20
export var JUMP = 8
export var FALL_MULTY = 1
export var JUMP_MULTY = 1
export var CAM_ACCEL = 40
export var ACCEL_TYPE = {"default": 10, "air": 5}

# Strafe leaning
const LEAN_SMOOTH : float = 10.0
const LEAN_MULT : float = 0.066
const LEAM_AMOUNT : float = 0.7

# Mouse sensitivity
export var mouse_sense = 0.15
var snap

var currentStrafeDir = 0

var first_jump_charged = true
var double_jump_charged = true


var player_input_active = true


# Vectors for movement
var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

# Onready variables
onready var accel = ACCEL_TYPE["default"]
onready var head = $Head
onready var camera = $Head/Camera
onready var raycast = $Head/Camera/RayCast

onready var WallCastRight = $Laterals/WallCastRight
onready var WallCastLeft = $Laterals/WallCastLeft


var is_dashing = false
var dash_duration = 0.3
var original_head_height = 0.5
var lowered_head_height = -0.5

onready var weapon_sprite = $CanvasLayer/Control/ShotgunShoot 
var repeat_frame = 9
onready var animated_crosshair = $CanvasLayer/Position2D/AnimatedCrosshair

const MAX_AMMUNITION = 6
var ammunition = MAX_AMMUNITION

const DISTANCIA_MELEE = 3
const DISTANCIA_RANGE = 15
const SPREAD_RANGE = 2
const SPREAD_MELEE = 5


func _ready():
	randomize()
	# Hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	OS.set_window_always_on_top(true) # !!! esto lo quitaré
	





func _physics_process(delta):
	
	
	_manage_dash()
	
	_manage_tilting()
	
	
	# Get keyboard input
	_get_keyboard_input()
	
	
	# Jumping and gravity
	if is_on_floor() or is_wallruning():
		#$BufferTimer.stop()
		first_jump_charged = true
		snap = -get_floor_normal()
		accel = ACCEL_TYPE["default"]
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_TYPE["air"]
		gravity_vec += Vector3.DOWN * GRAVITY * delta
	
	_manage_jump()
	
	_move(delta)
	
	_shoot()
	_melee()
	
	_regresar_a_escopeta()
	

func _regresar_a_escopeta():
	if weapon_sprite.frame == 10:
		weapon_sprite.animation = "neworder"
		weapon_sprite.playing = false
	# añadir aquí bamboleo al poner y quitar arma?

func _input(event):
	
	if event is InputEventKey and event.pressed:
		# Verifica si Ctrl está presionado y la tecla es 'W'
		if event.control and event.scancode == KEY_W:
			# Consume el evento para que no llegue al navegador
			#event.accept()
			print("Ctrl + W interceptado")
		
	
	
	_manage_mouse_capture()
	
	if !player_input_active or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: 
		return
	# Get mouse input for camera rotation
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))


func _manage_mouse_capture():
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("shoot") and !pause_mode == PAUSE_MODE_STOP:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func theres_wall_right():
	if WallCastRight.is_colliding() and !is_on_floor():
		if (WallCastRight.get_collider().get_parent().name == "structure") or (WallCastRight.get_collider().get_parent().name == "prueba 8"):
			
			return true
			
	return false
#	WallCastRight.is_colliding()

func theres_wall_left():
	if WallCastLeft.is_colliding() and !is_on_floor():
		
		print(WallCastLeft.get_collider().get_parent().name)
		
		if (WallCastLeft.get_collider().get_parent().name == "structure") or (WallCastLeft.get_collider().get_parent().name == "prueba 8"):
			return true 
	return false


func is_wallruning():
	return (theres_wall_left() or theres_wall_right())
	

func _get_keyboard_input():
	
	if !player_input_active: return
	
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
		SPEED = Wall_Speed #20
	elif is_dashing:
		SPEED = Dash_Speed #20
		
	else:
		SPEED = Run_Speed #10
		
	# warning-ignore:return_value_discarded
	move_and_slide_with_snap(movement, snap, Vector3.UP)

func _shoot():
	
	if !player_input_active: return
	
	
	if Input.is_action_just_pressed("shoot"):
		$CanvasLayer/Position2D/AnimatedCrosshair/ShakeTween.start()
		#$CanvasLayer/Position2D/Crosshair/ShakeTween.start()
		#spell_controller.cast()
		#print("disparamos")
		
		if _theres_ammo():
			pass
		else: 
			weapon_sprite.frame = 0
			weapon_sprite.play("noammo")
			
			return
		
		if !weapon_sprite.playing or weapon_sprite.frame > repeat_frame:
			
			gnomecam_shoot()
			waste_ammo()
			sync_ammo()
			weapon_sprite.animation = "neworder"
			weapon_sprite.frame = 0
			weapon_sprite.playing = true
			
			var raycast = $Head/Camera/RayCast
			
			
			raycast.cast_to.z = -DISTANCIA_RANGE
			for _n in range(6):
				randomize()
				#print("---", n)
				var spread = SPREAD_RANGE
				
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
						
						earn_score(50)
						
						pass
				
				spawn_impact_at(coll_point)

func gnomecam_shoot():
	$CanvasLayer/GnomoCam.shoot()

func _melee():
	if !player_input_active: return
	
	if Input.is_action_just_pressed("melee"):
		
		
		if !weapon_sprite.playing or weapon_sprite.frame > repeat_frame:
			
			
			
			weapon_sprite.animation = "bate"
			weapon_sprite.frame = 0
			weapon_sprite.playing = true
			
			
			
			raycast.cast_to.z = -DISTANCIA_MELEE
			for _n in range(10):
				randomize()
				#print("---", n)
				var spread = SPREAD_MELEE
				
				if _n > 1:
					raycast.cast_to.x = rand_range(-spread, spread)
					raycast.cast_to.y = rand_range(-spread, spread)
				else:
					raycast.cast_to.x = 0
					raycast.cast_to.y = 0
				#print(raycast.cast_to)
				#print(rand_range(-spread, spread))
				
				raycast.force_raycast_update()
				
				var coll = raycast.get_collider()
				var coll_point = raycast.get_collision_point()
				#print("punto de colisión = ", coll_point)
				
				if raycast.is_colliding():
					if coll.has_method("damage"):
						coll.damage()
						reload_ammo() 
						
						#spawn_impact_at(coll_point)
					else:
						#print("spawn impact")
						#print(coll_point)
						
						earn_score(50)
						
						pass
				
				spawn_impact_at(coll_point)
	





func dash():
	
	earn_score(143)
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


func buffer_active():
	return !$BufferTimer.is_stopped()

func init_buffer():
	$BufferTimer.start()

func dashbuffer_active():
	return !$DashBufferTimer.is_stopped()

func init_dashbuffer():
	$DashBufferTimer.start()

func _manage_jump():
	
	
	if !player_input_active: return
	
	if Input.is_action_pressed("jump") and is_on_floor():
		first_jump_charged = false
		jump()
		
	if Input.is_action_just_pressed("jump") or buffer_active():
		earn_score(20)
		if is_on_floor():
			first_jump_charged = false
			jump()
		elif is_wallruning():
			
			earn_score(123)
			
			var walljumpdirection = 0
			if theres_wall_right():
				walljumpdirection = -1 
			elif theres_wall_left():
				walljumpdirection = 1 
			
			
			direction = Vector3(walljumpdirection, 0, 0).rotated(Vector3.UP, global_transform.basis.get_euler().y).normalized()
			SPEED = 200
			
			earn_score(37)
			
			first_jump_charged = false
			jump()
			
		elif first_jump_charged:
			first_jump_charged = false
			jump()
		elif double_jump_charged:
			jump()
			double_jump_charged = false
		else:
			if not buffer_active(): init_buffer()

func jump():
	double_jump_charged = true
	snap = Vector3.ZERO
	gravity_vec = Vector3.UP * JUMP

func _manage_dash():
	if (Input.is_action_pressed("dash") or dashbuffer_active()) \
	and $DashCooldownTimer.is_stopped() \
	and movement != Vector3.ZERO:
		#print("dash")
		if is_on_floor():
			$DashCooldownTimer.start()
			dash()
		elif !dashbuffer_active():
			init_dashbuffer()
	
func _manage_tilting():
	if theres_wall_right():
		tilt_camera(30) # Inclinación a la derecha
		earn_score(1)
	elif theres_wall_left():
		tilt_camera(-30) # Inclinación a la izquierda
		earn_score(1)
	else:
		tilt_camera(0) # Regresa a posición neutra
	
	

func spawn_impact_at(some_location):
	var impact_instance = impact_scene.instance()
	impact_instance.translation = some_location
	get_parent().add_child(impact_instance)


func _on_Stats_died_signal():
	#var a_player = _transition.fade_in()
	#yield(a_player, "animation_finished")
	queue_free()



func earn_score(quantity):
	if player_input_active:
		level.add_score(quantity)


## Ammo y tal, esto debería estar en su propia clase

func _theres_ammo():
	return ammunition > 0

func waste_ammo():
	animated_crosshair.playing = false
	if _theres_ammo():
		ammunition = ammunition - 1

func reload_ammo():
	ammunition = MAX_AMMUNITION
	animated_crosshair.play("default")

func sync_ammo():
	
	animated_crosshair.frame = ammunition

############


