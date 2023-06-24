extends Gun


func Select():
	super.Select()
	$AnimationPlayer.play("Idle")
