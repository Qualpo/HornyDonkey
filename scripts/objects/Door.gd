extends Node3D

@export var Locked = false
@export var Code = 0
@export var Flipped = false
var Opened = false

func _ready():
	if Locked:
		$Lock.show()
func Interact(interactor):
	Open()
func Open():
	if not Locked and not $AnimationPlayer.is_playing():
		if not Opened:
			Opened = true
			if Flipped:
				$AnimationPlayer.play("FlippedOpen")
			else:
				$AnimationPlayer.play("Open")
			$Open.play()
		else:
			Opened = false
			if Flipped:
				$AnimationPlayer.play_backwards("FlippedOpen")
			else:
				$AnimationPlayer.play_backwards("Open")
			await $AnimationPlayer.animation_finished
			$Close.play()
	elif not $AnimationPlayer.is_playing():
		$Locked.play()
func Unlock(code):
	if Code == code:
		$Lock.hide()
		Locked = false
		$Unlock.play()
		return true
