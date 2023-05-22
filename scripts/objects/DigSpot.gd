extends AnimatableBody3D

@export var DigAmmount = 1


func Dig():
	position.y -= 0.1
	$MeshInstance3D.position.y = 0.1
	DigAmmount -= 1
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Dig")
	if DigAmmount <= 0:
		queue_free()
