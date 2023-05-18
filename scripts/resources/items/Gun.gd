extends Item
class_name Gun

@export var MaxAmmo = 16
@export var Ammo = 14
@export_range(0.0,1.0) var Accuracy = 1.0
@export var Recoil = 3.0
@export var BulletAmmount = 1


func Use(user):
	if Held:
		user.Shoot(Accuracy,BulletAmmount,Recoil)
