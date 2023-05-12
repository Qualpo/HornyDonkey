extends Node



var LoadingScreen = preload("res://scenes/loading_screen.tscn")
var TargetScenePath = "res://scenes/levels/DebugLevel.tscn"

var Lives = 3
var Money = 0.0
var Ammo = 12
var GunDamage = 30

signal UpdateUi
signal UpHp(ammount)
signal UpAmmo
signal UpMoney

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
