class_name Pickup
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Pickup/AnimationPlayer.play("Spin")

func UpPick():
	queue_free()

func _on_area_3d_body_entered(body):
	UpPick()
