extends Spatial

var gnomed = false


func _on_Area_body_entered(body):
	if body.name == "Player" and !gnomed:
		$AudioStreamPlayer.play()
		gnomed = true
