extends Pickup


func UpPick():
	Global.Player.Heal(8.0)
	super.UpPick()
