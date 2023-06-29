class_name Level
extends Node3D

@export var LevelName = ""
@export var BGM : AudioStream 
@export var Volume = 0.0


func _ready():
	discord_sdk.state = LevelName
	discord_sdk.refresh()
	SetMusic()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func SetMusic():
	Music.PlaySong(BGM)
	Music.volume_db = Volume
