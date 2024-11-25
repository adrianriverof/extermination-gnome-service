extends KinematicBody


var speed = 120.0

export var target_to_follow : String = "Player"
var moving = true

onready var player = get_parent().get_node(target_to_follow)
var destination = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	if player == null:
		player = get_parent().get_node(target_to_follow)
	
	speed = 300
	
	
	
func damage():
	print("...enemy damaged")
	queue_free()

func _physics_process(delta):
	
	$CucamanAnimated/AnimationPlayer.play("Action")
	
	destination = player.translation
	#print(destination)
	
	
	if moving:
		#print("moving")
		
		var direction = (destination - global_transform.origin).normalized()
		var distance_to_target = global_transform.origin.distance_to(destination)

		if distance_to_target > 1:
			direction.y *= 0
			var motion = direction * speed * delta
			self.look_at(Vector3(destination.x, self.translation.y, destination.z), Vector3.UP)
			self.rotation.x= 0
			#$compa/AnimationPlayer.play("walkin")
			
			motion = move_and_slide(motion)
		#self.translation.y = player.altitude + 0.08# !!! recenter
		
#		else:
#			$compa/AnimationPlayer.play("Iddle")
	else:
		#pass
		print("not moving")
		#$compa/AnimationPlayer.play("Iddle")
