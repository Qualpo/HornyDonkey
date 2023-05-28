extends Item
class_name Key


@export var Code = 1

var keying = false

func SetInfo():
	Info = str("Door:",Code)

func Use(user):
	if Held:
		if not keying:
			keying = true
			$AnimationPlayer.play("Key/use")
			var Cast:RayCast3D = RayCast3D.new()
			user.ShootNode.add_child(Cast)
			Cast.position = Vector3()
			Cast.enabled = true
			Cast.target_position = Vector3(0,0,-1000)
			Cast.collision_mask = 17
			Cast.force_raycast_update()
				
			if Cast.is_colliding():
				if Cast.get_collider().is_in_group("Door"):
					var col = Cast.get_collider().get_parent()
					if col.Unlock(Code):
						Cast.queue_free()
						await get_tree().create_timer(0.3).timeout
						user.ControlShake(0,1.0,0.0,0.2)
						await get_tree().create_timer(0.2).timeout
						user.ControlShake(0,0.0,0.5,0.2)
						await $AnimationPlayer.animation_finished
						Inventory.RemoveItem(self)
						queue_free()
						return
					
			Cast.queue_free()
			await $AnimationPlayer.animation_finished
			keying = false

			
