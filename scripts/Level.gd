class_name Level
extends Node3D

@export var BGM : AudioStream 


func _ready():
	Music.PlaySong(BGM)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
