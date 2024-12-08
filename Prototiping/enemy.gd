extends KinematicBody


onready var level = get_parent()

export var affected_by_gravity = true

var gravity_vec = Vector3.ZERO
var GRAVITY = 10
var speed = 120.0

export var target_to_follow : String = "Player"
var moving = true

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
	
	$cucaman_model/AnimationPlayer.play("Running3")
	
	destination = player.translation
	#print(destination)
	
	
	if affected_by_gravity: _manage_gravity(delta)
	
	if moving:
		
		var direction = (destination - global_transform.origin).normalized()
		var distance_to_target = global_transform.origin.distance_to(destination)

		if distance_to_target > 1:
			direction.y *= 0
			var motion = direction * speed * delta
			self.look_at(Vector3(destination.x, self.translation.y, destination.z), Vector3.UP)
			self.rotation.x= 0
			
			
			motion = move_and_slide(motion + gravity_vec)
	else:
		#pass
		print("not moving")


func _manage_gravity(delta):
	
	if is_on_floor():
		gravity_vec = Vector3.ZERO
	else:
		gravity_vec += Vector3.DOWN * GRAVITY * delta
	
	
	
