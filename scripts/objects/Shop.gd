extends Node3D



@export var Sounds : Dictionary

var Idle = true

func _ready():
	$AnimationPlayer.play("Idle")
func Interact(interacter):
	$AnimationPlayer.play("Buy")
	$AudioStreamPlayer3D.stream = Sounds["Greet"]
	$AudioStreamPlayer3D.play()
	# shitty fucking upgrade change later
	if Inventory.content.size() > 0:
		Inventory.content[Inventory.curselect].Upgrade(interacter)
