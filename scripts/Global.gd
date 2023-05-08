extends Node



var Lives = 3
var Money = 0.0
var Player = null
var Ammo = 12

func AmmoUp(am:int):
	Ammo += am
	Ammo = clamp(Ammo,0,14)
