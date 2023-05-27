extends Item




func Select():
	$Visual.position.z = -0.3
func Use(user):
	$AnimationPlayer.play("Drink")
func Drink():
	pass
