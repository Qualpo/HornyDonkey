extends Node3D

@export var item : Item

func _ready():
	if item.mesh == null:
		var s = Sprite3D.new()
		s.texture = item.icon
		$Visual.add_child(s)
	else:
		var m = MeshInstance3D.new()
		m.mesh = item.mesh
		$Visual.add_child(m)
	$Visual/AnimationPlayer.play("Spin")
	
