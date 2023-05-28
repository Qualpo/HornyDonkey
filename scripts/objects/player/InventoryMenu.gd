extends Control


var Page = 0
var CurSelect = 0
var Active = false
var LastVec = Vector2()
var MenuMousePos = Vector2()
var D = false

func _ready():
	Inventory.InvChanged.connect(UpdateMenu)
func Open():
	Active = true
	MenuMousePos = Vector2()
	$Line2D.points[1] = Vector2()
	$OutLine.points[1] = Vector2()
	Page = int(Inventory.curselect/8)
	NewSelect(Inventory.curselect%8)
	UpdateMenu()
func _input(event):
	if Active:
		if event is InputEventMouseMotion:
			
			NewSelect(GetMenuIndex(event.relative,MenuMousePos.length(),false))
		if event.is_action_pressed("Shoot"):
			Choose()
func _physics_process(delta):
	var poop = Input.get_vector("CamLeft","CamRight","CamUp","CamDown")
	if poop.length() >0.1:
		NewSelect(GetMenuIndex(poop,MenuMousePos.length(),true))
		D = false
	else:
		if not D:
			D = true
			NewSelect(GetMenuIndex(Vector2(),MenuMousePos.length(),true))
func UpdateMenu():
	$WheelTexture/Info/Page.text = str("PAGE\n",Page + 1)
	for i in range(8):
		var tex = get_node("WheelTexture/Items/Item" + str(i))
		if i + (Page *8) < Inventory.content.size():
			tex.texture = Inventory.content[i + (Page *8)].icon
		else:
			tex.texture = null
func GetMenuIndex(dirVec : Vector2, dist,controller):
	var dir = Vector2()
	if controller:
		dir = dirVec.normalized().round()
		$Line2D.points[1] = dir.normalized()*70
		$OutLine.points[1] = dir.normalized() * 70 + dir.normalized()
	else:
		dir = DoThing(dirVec)
	if not controller and dist < 62:
		return CurSelect%8

	match dir:
		Vector2(0,-1):
			return 0
		Vector2(1,-1):
			return 1
		Vector2(1,0):
			return 2
		Vector2(1,1):
			return 3
		Vector2(0,1):
			return 4
		Vector2(-1,1):
			return 5
		Vector2(-1,0):
			return 6
		Vector2(-1,-1):
			return 7
	return CurSelect%8
func DoThing(vec : Vector2):
#	var doVec = vec
#	if LastVec.distance_to(vec)<0.8:
#		doVec = LastVec
#	else:
#		LastVec = vec
#	var absx = abs(doVec.x)
#	var absy = abs(doVec.y)
	MenuMousePos+= vec * 2
	var returnVec = MenuMousePos.normalized().round()
#	if absx >= 0.3 and absy >= 0.3:
#
#		if doVec.x > 0:
#			returnVec.x = 1
#		else:
#			returnVec.x = -1
#		if doVec.y > 0:
#			returnVec.y = 1
#		else:
#			returnVec.y = -1
	$Line2D.points[1] = MenuMousePos
	$OutLine.points[1] = MenuMousePos + MenuMousePos.normalized()
	return returnVec
func NewSelect(index):
	$WheelTexture/Segment.rotation_degrees = index * 45
	CurSelect = index + (Page *8)
	if CurSelect < Inventory.content.size():
		$WheelTexture/Info/Name.text = Inventory.content[CurSelect].Name
		$WheelTexture/Info/OtherInfo.text = Inventory.content[CurSelect].Info
func PageUp():
	if Page >= int((Inventory.content.size() -1)/8):
		Page = 0
	else:
		Page += 1
	UpdateMenu()
func PageDown():
	if Page <= 0:
		Page = int((Inventory.content.size() -1)/8)
	else:
		Page -= 1
	UpdateMenu()
func Choose():
	Inventory.Select(CurSelect)
