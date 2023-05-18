extends Resource
class_name Item


@export var mesh : Mesh
@export var icon : Texture
@export var offset : Vector3 


var Held = false

func PickUp(user):
	user.connect("Use",Use)

func Select():
	Held = true
func Deselect():
	Held = false

func Use(user):
	if Held:
		pass
