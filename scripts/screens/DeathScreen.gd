extends Control


func _input(event):
	if event.is_action_pressed("Shoot"):
		Global.Lives = 3
		get_tree().change_scene_to_packed(Global.LoadingScreen)
