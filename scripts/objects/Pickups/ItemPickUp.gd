extends Node3D

@export var setitem : PackedScene
var item = null

func _ready():
	item = setitem.instantiate()
	$Visual.add_child(item.duplicate())
	$Visual/AnimationPlayer.play("Spin")
	
