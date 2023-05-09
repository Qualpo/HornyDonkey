extends Pickup


func UpPick():
	Global.Money += 10
	super.UpPick()
