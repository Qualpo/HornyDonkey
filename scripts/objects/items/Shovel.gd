extends Item


@onready var HitNoise = preload("res://audio/sfx/metal clang.ogg")


var User = null

func Use(user):
	if Held:
		User = user
		if not Using:
			Using = true
			$AnimationPlayer.play("Shovel/use")

func UnUse(user):
	pass
func Dig():
			var Cast:RayCast3D = RayCast3D.new()
			User.ShootNode.add_child(Cast)
			Cast.position = Vector3()
			Cast.enabled = true
			Cast.target_position = Vector3(0,0,-2)
			Cast.collision_mask = 17
			Cast.force_raycast_update()
			if Cast.is_colliding():
				if Cast.get_collider().is_in_group("Dig"):
					Cast.get_collider().Dig()
				else:
					$GPUParticles3D.restart()
					$AnimationPlayer.play("Shovel/hit")
					$AudioStreamPlayer3D.stream = HitNoise
					$AudioStreamPlayer3D.play()
					if User.velocity.y < 0:
						User.velocity.y = 0
					User.velocity -= (User.global_position.direction_to(Cast.get_collision_point()))*8
					
			Cast.queue_free()
			await $AnimationPlayer.animation_finished
			Using = false
