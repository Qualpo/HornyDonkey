extends Item
class_name Key


@export var Code = 1

var keying = false


func Use(user):
	if Held:
		if not keying:
			keying = true
			$AnimationPlayer.play("use")
			var Cast:RayCast3D = RayCast3D.new()
			user.ShootNode.add_child(Cast)
			Cast.position = Vector3()
			Cast.enabled = true
			Cast.target_position = Vector3(0,0,-1000)
			Cast.collision_mask = 17
			Cast.force_raycast_update()
			if Cast.is_colliding():
				if Cast.get_collider().is_in_group("Locked"):
					Cast.get_collider().Unlock(Code)
			Cast.queue_free()
			await $AnimationPlayer.animation_finished
			keying = false
			
