extends KinematicBody


# ojo deben estar dentro de un nodo en la escena principal
onready var level = get_parent().get_parent()

export var affected_by_gravity = true

var gravity_vec = Vector3.ZERO
var GRAVITY = 10
var speed = 120.0

export var target_to_follow : String = "Player"



export var active = true
export var chasing_player = true
export var aggro_distance = 10
export var unaggroable = true
export var unaggro_distance = 15


onready var player = level.get_node(target_to_follow)
var destination = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	if player == null:
		player = level.get_node(target_to_follow)
	
	speed = 300
	
	
	
func damage():
	#print("...enemy damaged")
	level.score_manager.matar_cuca()
	queue_free()

func _physics_process(delta):
	
	
	
	destination = player.translation
	#print(destination)
	
	
	if affected_by_gravity: _manage_gravity(delta)
	
	
	if active:
		var distance_to_target = global_transform.origin.distance_to(destination)
		if chasing_player:
			_chase_player(delta)
			
			if unaggroable and distance_to_target > unaggro_distance:
				chasing_player = false
				
		elif distance_to_target < aggro_distance:
			chasing_player = true
		else:
			_stay_iddle()
		
		
	else:
		_stay_iddle()
		

func _stay_iddle():
	move_and_slide(gravity_vec)
	$cucaman_model/AnimationPlayer.play("iddle")
	#print("not moving")

func _chase_player(delta):
	$cucaman_model/AnimationPlayer.play("Running3")
	var direction = (destination - global_transform.origin).normalized()
	var distance_to_target = global_transform.origin.distance_to(destination)

	if distance_to_target > 1:
		direction.y *= 0
		var motion = direction * speed * delta
		self.look_at(Vector3(destination.x, self.translation.y, destination.z), Vector3.UP)
		self.rotation.x= 0
		
		
		motion = move_and_slide(motion + gravity_vec)

func _manage_gravity(delta):
	
	if is_on_floor():
		gravity_vec = Vector3.ZERO
	else:
		gravity_vec += Vector3.DOWN * GRAVITY * delta
	
	
	
