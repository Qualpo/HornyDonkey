extends Control

var Levels = {"Debug":"res://scenes/levels/DebugLevel.tscn","Level1":"res://scenes/levels/Level1.tscn"}
var CurSelect = 0

func _on_button_pressed():
#	Inventory.content.append(load("res://mods/TestMod/assets/scenes/test_item.tscn").instantiate())
	get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")

func Move(left):
	if left:
		CurSelect -= 1
	else:
		CurSelect += 1
	if CurSelect >= Levels.keys().size() -1:
		$LevelSelect/Right.disabled = true
	else:
		$LevelSelect/Right.disabled = false
	if CurSelect <= 0:
		$LevelSelect/Left.disabled = true
	else:
		$LevelSelect/Left.disabled = false
	$LevelSelect/TextEdit/Label.text = Levels.keys()[CurSelect]
	Global.TargetScenePath = Levels.values()[CurSelect]

func _on_left_pressed():
	Move(true)


func _on_right_pressed():
	Move(false)
