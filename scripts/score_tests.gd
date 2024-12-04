extends GutTest


var ScoreManager = load("res://scripts/score_manager.gd")


func test_ok():
	assert_true(true)
	

func test_theres_scoremanager():
	var sut = ScoreManager.new()
	
	assert_not_null(sut)

func test_en_combo():
	
	var sut = ScoreManager.new()
	
	assert_eq(sut.in_combo(), true )



