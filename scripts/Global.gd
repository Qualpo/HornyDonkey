extends Node



var LoadingScreen = preload("res://scenes/screens/loading_screen.tscn")
var TargetScenePath = "res://scenes/levels/DebugLevel.tscn"

var Checkpoint = Vector3(0.0,1.0,0.0)

var Lives = 3
var Money = 0.0
var Ammo = INF
var GunDamage = 30
var PlayerPos = Vector3()
var danim = 1

signal UpdateUi
signal UpHp(ammount)
signal UpAmmo
signal UpMoney
func _physics_process(delta):
	danim += delta * 10
	if danim > 8:
		danim = 1
	DiscordAnimation(int(danim))
func AmmoUp(am:int):
	Ammo += am
	Ammo = clamp(Ammo,0,16)
	emit_signal("UpdateUi")
	emit_signal("UpAmmo")
func HpUp(am:int):
	emit_signal("UpHp",am)
	emit_signal("UpdateUi")
func MoneyUp(am):
	Money+=am
	emit_signal("UpdateUi")
	emit_signal("UpMoney")
func DiscordAnimation(num):
	discord_sdk.large_image = "run" + str(num)
	discord_sdk.refresh()
