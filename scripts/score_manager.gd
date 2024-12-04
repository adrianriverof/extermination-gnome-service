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


func matar_cuca():
	add_score(puntos_cuca_segun_tiempo() * (multip_cuca_distancia + combo()))
	update_last_time_killed()


func matar_cuca_wallriding():
	add_score(puntos_cuca_segun_tiempo() * (multip_cuca_distancia + combo()+ 2) )

func matar_cuca_en_aire():
	add_score(puntos_cuca_segun_tiempo() * (multip_cuca_distancia + combo()+ 3) )


func puntos_cuca_segun_tiempo():
	return puntos_por_cuca + 25*time_passed
	

func update_last_time_killed():
	last_kill_time = time_passed

func combo():
	
	#1 comprobar que hay combo
	#2 añadir 3*tiempo en combo
	if in_combo():
		return 3 * segundos_en_combo()
	else: return 1 

func in_combo():
	
	if (time_passed - last_kill_time) < combo_time:
		return true 
	return false

func segundos_en_combo():
	return 1






