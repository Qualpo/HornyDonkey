extends Node3D

@export var setitem : PackedScene
var item = null

func _ready():
	item = setitem.instantiate()
	$Visual.add_child(item)
	$Visual/AnimationPlayer.play("Spin")
func remove(remover):
	item.PickUp(remover)
	Inventory.content.append(item)
	$Visual.remove_child(item)
	queue_free()
