extends Control

func _ready():
	discord_sdk.details = ""
	discord_sdk.state = "Game Over"
	discord_sdk.large_image = "icon"
	discord_sdk.refresh()
func _input(event):
	if event.is_action_pressed("Shoot"):
		Global.Lives = 3
		discord_sdk.large_image = "gaben"
		get_tree().change_scene_to_packed(Global.LoadingScreen)
