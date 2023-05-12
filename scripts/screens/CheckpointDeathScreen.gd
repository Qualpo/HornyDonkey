extends TextureRect

func _input(event):
	if event.is_action_pressed("Shoot"):
		owner.UnDie()
		hide()
		get_tree().paused = false
