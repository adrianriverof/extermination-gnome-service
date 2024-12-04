extends Node
class_name Scoremanager



var puntos_por_cuca = 100
var multip_cuca_distancia = 2
var multip_cuca_melee = 4

var last_kill_time = 0.0


var score = 0

var time_passed = 0
var combo_time = 2


func _calculate_time(delta):
	time_passed += delta

func add_score(points:int):
	score += points



func matar_cuca(extra_base = 0, extra_combo = 0):
	add_score(
		(puntos_cuca_segun_tiempo() + extra_base) * 
		(multip_cuca_distancia + combo()+ extra_combo) 
		)
	update_last_time_killed()


func matar_cuca_wallriding():
	matar_cuca(0, 3)
	
func matar_cuca_en_aire():
	matar_cuca(0, 2)
	
func matar_cuca_headshot():
	matar_cuca(25, 0)

func matar_cuca_headshot_aire():
	matar_cuca(25, 2)

func matar_cuca_headshot_wallride():
	matar_cuca(25, 3)


func puntos_cuca_segun_tiempo():
	return puntos_por_cuca + 25*time_passed
	

func update_last_time_killed():
	last_kill_time = time_passed

func combo():
	return 3 * segundos_en_combo()


func in_combo():
	
	if (time_passed - last_kill_time) < combo_time:
		return true 
	return false

func segundos_en_combo():
	if in_combo():
		return time_passed - last_kill_time
	return 0






