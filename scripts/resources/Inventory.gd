extends Resource
class_name Inventory


@export var content = []
@export var curselect = 0

signal NewItem(item)

func Start(starter):
	if content.size() > 0:
		content[0].Select()
		for c in content:
			c.PickUp(starter)
		emit_signal("NewItem",content[curselect])
func MoveRight():
	content[curselect].Deselect()
	if curselect == content.size() -1:
		curselect = 0
	else:
		curselect += 1
	content[curselect].Select()
	emit_signal("NewItem",content[curselect])
func MoveLeft():
	content[curselect].Deselect()
	if curselect == 0:
		curselect = content.size() -1
	else:
		curselect -= 1
	content[curselect].Select()
	emit_signal("NewItem",content[curselect])
