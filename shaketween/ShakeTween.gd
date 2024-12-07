extends Node2D



# dependencies

# !!!!!!
onready var host_sprite = get_parent() # mueve el parent

export var pivot_below = true # si pivota de abajo o no

# parameterrs
export var x_max = 10  # def: 1.5 # MIN:1?
export var y_max = 0 # vertical
export var r_max = 0 # rotation def: 10

export var STOP_THRESHOLD = 5.0  # def: 0.1 # relacionado con pos x
export var TWEEN_DURATION = 0.05  # def: 0.05
export var RECOVERY_FACTOR = 1.0/3 # def: 2.0/3 # energia retenida cada ciclo
const TRANSITION_TYPE = Tween.TRANS_SINE # def: Tween.TRANS_SINE

signal tween_completed


# run animation

func start():
	
	# multiple bounces
	var x = x_max
	var y = y_max
	var r = r_max
	
	while x>STOP_THRESHOLD or y>STOP_THRESHOLD:
		
		var tween
		#if x>STOP_THRESHOLD:
			
		# left
		if x>STOP_THRESHOLD:
			tween = _tilt_left(x,r)
			yield(tween, "tween_completed")
			tween.queue_free()
			x *= RECOVERY_FACTOR
			r *= RECOVERY_FACTOR
			
			_recenter()
		
		# right 
		if x>STOP_THRESHOLD:
			tween = _tilt_right(x,r)
			yield(tween, "tween_completed")
			tween.queue_free()
			x *= RECOVERY_FACTOR
			r *= RECOVERY_FACTOR
			
			_recenter()
	
		# up
		if y>STOP_THRESHOLD:
			tween = _tilt_up(y)
			yield(tween, "tween_completed")
			tween.queue_free()
			y *= RECOVERY_FACTOR
			
			_recenter()
		
	#if y>STOP_THRESHOLD:
		
		
		# down
		if y>STOP_THRESHOLD:
			tween = _tilt_down(y)
			yield(tween, "tween_completed")
			tween.queue_free()
			y *= RECOVERY_FACTOR
			
			_recenter()

		#  complete
		emit_signal("tween_completed")


func _interpolate(name:String, property, tween):
	tween.interpolate_property(host_sprite, name, 0,
	property, TWEEN_DURATION,TRANSITION_TYPE, Tween.EASE_OUT)  #( Object object,NodePath property, Variant initial_val, Variant final_val, float duration, TransitionType trans_type=0, EaseType ease_type=2, float delay=0 )

func create_tween():
	var tween = Tween.new()
	add_child(tween)
	return tween
	

func _tilt_left(x,r) -> Tween:
	var tween = create_tween()
	
	# position
	_interpolate("position:x", -x, tween)
	
	
	
	# rotation
	r = -r if pivot_below else r
	_interpolate("rotation_degrees", r, tween)
	
	
	tween.start()
	return tween
	
	
func _tilt_right(x,r) -> Tween:
	var tween = create_tween()
	
	# position x
	_interpolate("position:x", x, tween)
	
	# rotation
	r = r if pivot_below else -r
	_interpolate("rotation_degrees", r, tween)
	
	tween.start()
	return tween

func _tilt_up(y) -> Tween:
	var tween = create_tween()
	
	# position y
	_interpolate("position:y", -y, tween)
	
	tween.start()
	return tween

func _tilt_down(y)-> Tween:
	var tween = create_tween()
	
	# position y
	_interpolate("position:y", y, tween)
	
	tween.start()
	return tween

func _recenter():
	var tween = create_tween()
	
	# position x 
	var host_x = host_sprite.position.x
	tween.interpolate_property(host_sprite, "position:x",host_x, 0,  # estos no los refactorizamos, van al revés
	TWEEN_DURATION,TRANSITION_TYPE, Tween.EASE_IN)
	
	
	# position y
	var host_y = host_sprite.position.y
	tween.interpolate_property(host_sprite, "position:y",host_y, 0,  
	TWEEN_DURATION,TRANSITION_TYPE, Tween.EASE_IN)
	
	
	# rotation
	var host_r = host_sprite.rotation_degrees
	tween.interpolate_property(host_sprite, "rotation_degrees", host_r, 0,
	TWEEN_DURATION, TRANSITION_TYPE, Tween.EASE_IN)
	
	
	tween.start()
	return tween

	

	


