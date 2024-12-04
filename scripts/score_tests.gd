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



