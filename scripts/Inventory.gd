extends Node


@export var content = []
@export var curselect = 0

signal NewItem(item)


func _ready():
	content.append(preload("res://scenes/objects/items/Pisstol.tscn").instantiate())

func Start(starter):
	if content.size() > 0:
		content[0].Select()
		for c in content:
			c.PickUp(starter)
			starter.get_node("CanvasLayer/Inventory/Panel/ItemList").add_item(c.Name, c.icon,true)
		emit_signal("NewItem",content[curselect])
func MoveRight():
	if content.size() > 1:
		if content[curselect].Using == false:
			content[curselect].Deselect()
			if curselect == content.size() -1:
				curselect = 0
			else:
				curselect += 1
			content[curselect].Select()
			emit_signal("NewItem",content[curselect])
func RemoveItem(item):
	content.erase(item)
	if curselect >= content.size():
		curselect -= 1
	content[curselect].Select()
	emit_signal("NewItem",content[curselect])
func MoveLeft():
	if content.size() > 1:
		if content[curselect].Using == false:
			content[curselect].Deselect()
			if curselect == 0:
				curselect = content.size() -1
			else:
				curselect -= 1
			content[curselect].Select()
			emit_signal("NewItem",content[curselect])
