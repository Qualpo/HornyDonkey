extends Node3D
class_name Item


@export var icon : Texture
@export var offset : Vector3 
@export var Name = "TestName"
@export var Info = ""
@export var Upgradeable = false
@export var UpgradePath = ""

var Using = false
var Held = false
var OnGround = true


func PickUp(user):
	OnGround = false
	$Area3D.collision_layer = 0
	position = Vector3()
	$Spin.stop()
	user.connect("Use",Use)
	user.connect("UnUse",UnUse)
	user.connect("SecondUse",SecondUse)
	user.connect("UnSecondUse",UnSecondUse)
func _ready():
	SetInfo()
	if OnGround:
		$Spin.play("Spin")
func Upgrade(upgrader):
	if Upgradeable:
		if UpgradePath != "":
			if Inventory.content.has(self):
				Inventory.ReplaceItem(Inventory.content.find(self),load(UpgradePath).instantiate(),upgrader)
func SetInfo():
	pass
func Select():
	Held = true
func Deselect():
	Held = false

func Use(user):
	if Held:
		pass
func UnUse(user):
	if Held:
		pass
func SecondUse(user):
	if Held:
		pass
func UnSecondUse(user):
	if Held:
		pass


func _on_area_3d_area_entered(area):
	pass # Replace with function body.
