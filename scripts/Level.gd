class_name Level
extends Node3D

@export var BGM : AudioStream 
# Called when the node enters the scene tree for the first time.

func _ready():
	Music.PlaySong(BGM)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
