extends Item
class_name Gun

@export var MaxAmmo = 16
@export var Ammo = 14
@export_range(0.0,1.0) var Accuracy = 1.0
@export var Recoil = 3.0
@export var BulletAmmount = 1
@export var ShootCooldown = 0.15
@export var ShootSound : AudioStream
@export var NoBulletSound : AudioStream

var BulletHole = preload("res://scenes/objects/BulletHole.tscn")

var Shooting = false
var RNG = RandomNumberGenerator.new()

func Use(user):
	if Held:
		
		Shoot(Accuracy,BulletAmmount,Recoil, user)
		user.UpdateUi()
func SecondUse(user):
	if Held:
		user.UnSprint()
		user.Aim()
func UnSecondUse(user):
	if Held:
		if user.Aiming:
			user.UnAim()
func Shoot(accuracy, bulletammount, recoil, user):
	if not Shooting and Global.Ammo > 0:
		Global.Ammo -= 1
		Shooting = true
		if user.GunSound.stream != ShootSound:
			user.GunSound.stream = ShootSound
		user.GunSound.play()
		$AnimationPlayer.stop()
		$AnimationPlayer.play("Shoot")

		for i in range(bulletammount):
			var rand = (abs(1-accuracy))*25
			var spread = Vector2(RNG.randf_range(-rand,rand),RNG.randf_range(-rand,rand))
			var Cast:RayCast3D = RayCast3D.new()
			user.ShootNode.add_child(Cast)
			Cast.position = Vector3()
			Cast.enabled = true
			Cast.target_position = Vector3(0,0,-1000)
			Cast.collision_mask = 5
			Cast.rotation_degrees = Vector3(spread.x,spread.y,0)
			Cast.force_raycast_update()
		for Cast in user.ShootNode.get_children():
					if Cast.is_colliding():
						
					
						if Cast.get_collider().is_in_group("Enemy"):
					
							Cast.get_collider().Hit(false,self,Global.GunDamage)
						else:
							var hole = BulletHole.instantiate()
					
							user.get_parent().add_child(hole)
							hole.position = Cast.get_collision_point() + (Cast.get_collision_normal()/80)
							if abs(Cast.get_collision_normal().y) == 1:
								hole.rotation_degrees.x = 90
							else:
								hole.look_at(Cast.get_collision_point()-Cast.get_collision_normal(),Vector3.UP)
					Cast.queue_free()
		user.CameraOffset.x += recoil * 3
		user.CameraDirection.x += recoil
		user.CameraDirection.x = clamp(user.CameraDirection.x,-90,90)

		await user.get_tree().create_timer(ShootCooldown).timeout
		Shooting = false
	elif not Shooting:
		if user.GunSound.stream != NoBulletSound:
			user.GunSound.stream = NoBulletSound
		user.GunSound.play()
