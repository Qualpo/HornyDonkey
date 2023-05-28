extends Node


@export var content = []
@export var curselect = 0

signal NewItem(item)
signal InvChanged


func _ready():
	for i in range (10):
		AddItem(preload("res://scenes/objects/items/Pisstol.tscn").instantiate())
		AddItem(preload("res://scenes/objects/items/key.tscn").instantiate())
		AddItem(preload("res://scenes/objects/items/Soda.tscn").instantiate())
		AddItem(preload("res://scenes/objects/items/Shovel.tscn").instantiate())
		AddItem(preload("res://scenes/objects/items/Item.tscn").instantiate())

func Start(starter):
	if content.size() > 0:
		content[0].Select()
		for c in content:
			c.PickUp(starter)
		emit_signal("NewItem",content[curselect])
		emit_signal("InvChanged")

func MoveRight():
	if content.size() > 1:
		if curselect == content.size() -1:
			Select(0)
		else:
			Select(curselect + 1)

func AddItem(item):
	content.append(item)
	emit_signal("InvChanged")

func RemoveItem(item):
	content.erase(item)
	if curselect >= content.size():
		curselect -= 1
	content[curselect].Select()
	emit_signal("NewItem",content[curselect])
	emit_signal("InvChanged")

func Select(index):
	if (index < content.size() and index >= 0) and index != curselect:
		if content[curselect].Using == false:
			content[curselect].Deselect()
			curselect = index
			content[curselect].Select()
			emit_signal("NewItem",content[curselect])

func MoveLeft():
	if content.size() > 1:
		if curselect == 0:
			Select(content.size() -1)
		else:
			Select(curselect - 1)
