extends Node
class_name Scoremanager



var puntos_por_cuca = 100
var multip_cuca_distancia = 2
var multip_cuca_melee = 4



var score = 0

var time_passed = 0



func _calculate_time(delta):
	time_passed += delta

func add_score(points:int):
	score += points


func matar_cuca():
	add_score(puntos_por_cuca * multip_cuca_distancia * time_passed )

