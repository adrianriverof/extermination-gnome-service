extends Node
class_name Scoremanager



var puntos_por_cuca = 100
var multip_cuca_distancia = 2
var multip_cuca_melee = 4

var last_kill_time = 0.0
var first_killtime_in_spree = 0.0

var score = 0

var time_passed = 0
var combo_time = 2

var combo_level = 1  # de 1 a 5

var segundos_combo_total = 0


func get_score():
	return score

func set_score(value):
	score = value

func get_combo_level():
	update_combo_level_based_on_combo()
	return combo_level
func reset_combo_level():
	combo_level = 1
func set_combo_level(value):
	combo_level = value
func increase_combo_level():
	if combo_level < 5:
		combo_level += 1
func decrease_combo_level():
	if combo_level > 1:
		combo_level -= 1


func calculate_combo_level(time_in_combo: float) -> int:
	if time_in_combo < 1.0:
		return 1
	elif time_in_combo < 3.0:
		return 2
	elif time_in_combo < 5.0:
		return 3
	elif time_in_combo < 10.0:
		return 4
	elif time_in_combo < 15.0:
		return 5
	else:
		return 0

func select_combo_level_based_on_time():
	combo_level = calculate_combo_level(time_passed - first_killtime_in_spree)
	return combo_level

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
	
	if in_combo():
		# si se updatea pero no lo perdió, se añade el combo al total
		# y se sube de nivel de combo tal vez
		save_combo_time_to_total()
		increase_combo_level()
	else: # se perdió el combo
		# seleccionamos nueva primera kill
		first_killtime_in_spree = time_passed
		reset_combo_level()
	
	last_kill_time = time_passed



func combo_time_in_spree():
	return (time_passed - first_killtime_in_spree)

func save_combo_time_to_total():
	segundos_combo_total += time_passed - last_kill_time
	

func combo():
	return 3 * combo_time_in_spree()


func in_combo():
	
	if (time_passed - last_kill_time) < combo_time:
		return true 
	else:
		return false

func update_combo_level_based_on_combo():
	if !in_combo():
		reset_combo_level()


func segundos_en_combo():
	if in_combo():
		return time_passed - last_kill_time
	return 0
	


func golpear_huevo():
	if time_passed >= 19.0:
		score *= 6
	else:
		score *= 3





