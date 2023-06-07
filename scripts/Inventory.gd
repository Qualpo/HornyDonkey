extends Node


@export var content : Array[Item]= []
@export var PreDeathContent : Array[Item] = []
@export var curselect = 0

signal NewItem(item)
signal InvChanged


func _ready():
	PreDeathContent.append(preload("res://scenes/objects/items/Hands.tscn").instantiate())

func Start(starter):
	for i in content:
		if not PreDeathContent.has(i):
			i.queue_free()
	content.assign(PreDeathContent)
	content[0].Select()
	curselect = 0
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
	if curselect == 0:
		Select(content.size() -1)
	emit_signal("InvChanged")

func RemoveItem(item):
	content.erase(item)
	if curselect >= content.size():
		curselect -= 1
	content[curselect].Select()
	emit_signal("NewItem",content[curselect])
	emit_signal("InvChanged")
func Select(index):
	if (index < content.size() and index >= 0):
		if index != curselect:
			if content[curselect].Using == false:
				content[curselect].Deselect()
				curselect = index
				content[curselect].Select()
				emit_signal("NewItem",content[curselect])
func ReplaceItem(index,variant:Item,user):
	if index >= 0 and index < content.size():
		var pre = content[index]
		variant.PickUp(user)
		variant.Select()
		content[index] = variant
		if index == curselect:
			emit_signal("NewItem",variant)
		emit_signal("InvChanged")
		pre.queue_free()
func MoveLeft():
	if content.size() > 1:
		if curselect == 0:
			Select(content.size() -1)
		else:
			Select(curselect - 1)
