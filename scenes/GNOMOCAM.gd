extends Control

func shoot():
	$Idle.visible = false
	$Timer.start()


func _on_Timer_timeout():
	$Idle.visible = true
