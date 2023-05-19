extends Node3D
class_name Item


@export var icon : Texture
@export var offset : Vector3 
@export var Name = "TestName"


var Held = false

func PickUp(user):
	user.connect("Use",Use)
	user.connect("UnUse",UnUse)
	user.connect("SecondUse",SecondUse)
	user.connect("UnSecondUse",UnSecondUse)

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
