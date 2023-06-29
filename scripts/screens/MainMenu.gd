extends Control

var Levels = {"DEBUG":"res://scenes/levels/DebugLevel.tscn","LEVEL 1":"res://scenes/levels/Level1.tscn"}
var CurSelect = 0

var windowvel = Vector2()

func _ready():
	discord_sdk.state = "MainMenu"
	discord_sdk.refresh()
	get_tree().root.grab_focus()

func _physics_process(delta):
	if has_node("Window"):
		windowvel = lerp(windowvel,Vector2(),0.1)
		var id = Input.get_vector("Left","Right","Forward","Backward").round()
		windowvel += id
		$Window.position += Vector2i(windowvel)
		$Window/Camera2D.position = $Window.position

func _on_button_pressed():
#	Inventory.content.append(load("res://mods/TestMod/assets/scenes/test_item.tscn").instantiate())
	get_tree().change_scene_to_file("res://scenes/screens/loading_screen.tscn")

func Move(left):
	if left:
		CurSelect -= 1
	else:
		CurSelect += 1
	if CurSelect >= Levels.keys().size() -1:
		$Main/Stuff/LevelSelect/Right.disabled = true
	else:
		$Main/Stuff/LevelSelect/Right.disabled = false
	if CurSelect <= 0:
		$Main/Stuff/LevelSelect/Left.disabled = true
	else:
		$Main/Stuff/LevelSelect/Left.disabled = false
	$Main/Stuff/LevelSelect/TextEdit/Label.text = Levels.keys()[CurSelect]
	Global.TargetScenePath = Levels.values()[CurSelect]

func _on_left_pressed():
	Move(true)


func _on_right_pressed():
	Move(false)


func _on_window_close_requested():
	$Window.queue_free()


func _on_options_pressed():
	pass # Replace with function body.
