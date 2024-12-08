extends GutTest


var ScoreManager = load("res://scripts/score_manager.gd")


func test_ok():
	assert_true(true)
	

func test_theres_scoremanager():
	var sut = ScoreManager.new()
	
	assert_not_null(sut)

func test_en_combo_cuando_acabamos_de_matar():
	
	var sut = ScoreManager.new()
	
	sut.matar_cuca()
	
	
	assert_eq(sut.in_combo(), true )


func test_last_kill():
	var sut = ScoreManager.new()
	
	sut.time_passed = 12 
	sut.matar_cuca()
	
	assert_eq(sut.last_kill_time, 12 )


func test_last_kill_is_updated():
	var sut = ScoreManager.new()
	
	sut.time_passed = 12 
	sut.matar_cuca()
	sut.time_passed = 24 
	sut.matar_cuca()
	
	assert_eq(sut.last_kill_time, 24 )



func test_fuera_de_combo_cuando_hace_1000s_que_matamos():
	
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed = 1000
	
	assert_eq(sut.in_combo(), false )

func test_fuera_de_combo_cuando_pasa_mas_del_combotime():
	
	var sut = ScoreManager.new()
	
	sut.time_passed = 24
	sut.matar_cuca()
	sut.time_passed += sut.combo_time + 0.1
	
	
	assert_eq(sut.in_combo(), false )

func test_dentro_de_combo_cuando_no_pasa_mas_del_combotime():
	
	var sut = ScoreManager.new()
	
	sut.time_passed = 24
	sut.matar_cuca()
	sut.time_passed += sut.combo_time - 0.1
	
	
	assert_eq(sut.in_combo(), true )
	
	
func test_segundos_en_combo_son_los_segundos_que_llevamos_sin_perderlo():
	
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	var tiempoquepasa = sut.combo_time - 0.1
	sut.time_passed += tiempoquepasa #pasa tiempo sin perderlo
	
	assert_eq(sut.segundos_en_combo(), tiempoquepasa )

func test_segundos_en_combo_son_0_si_lo_perdemos():
	
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed += sut.combo_time + 0.1 # perdemos combo
	
	assert_eq(sut.segundos_en_combo(), 0 )

#func test_matar_cuca_

func test_segundos_en_combo_no_acumula_tiempo():
	# solo mide el tiempo desde la ultima muerte
	
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	
	assert_eq(sut.segundos_en_combo(), 1 )

func test_segundos_totales_en_combo_acumula_segundos_en_combo():
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	
	assert_eq(sut.segundos_combo_total, 3 )

