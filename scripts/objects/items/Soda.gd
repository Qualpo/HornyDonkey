extends Item

var timer
signal drink

func Select():
	Held = true
	$Visual.position.z = -0.3
func Use(user):
	if Held:
		if not Using:
			$AnimationPlayer.play("Drink")
			Using = true
			await drink
			pass
			await $AnimationPlayer.animation_finished
			Using = false
