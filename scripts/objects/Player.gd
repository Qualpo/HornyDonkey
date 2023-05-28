extends CharacterBody3D


@export var WalkSpeed = 1.5
@export var RunSpeed = 2.5
@export var AimSpeed = 0.5
@export var HP = 100.0
@export_range(0.0,1.0,0.01) var Sensitivity = 0.5
@export var Bobset = 0.0


var FacingDir = Vector2.UP
var CameraDirection = Vector2()
var CameraOffset = Vector2()
var TiltDir = Vector2()
var LastPos = Vector3()
var GunStartPos = Vector3(0.625,-0.32,-0.529)
var GunAimPos = Vector3(0,-0.230,-0.184)
var GunPos = Vector3()


var RecoilAmt = 3.0
var Fov = 75.0
var MoveSpeed = 1.0
var SuperJumpBuffer = 0.0
var MoveSpeedScale = 1.0

var Aiming = false
var Sprinting = false
var Shooting = false
var NoClip = false
var Dead = false

var LookDisabled = false
var InvOpen = false

var RNG = RandomNumberGenerator.new()

@onready var GunAnims = $GunAnims
@onready var GunSound = $GunSound
@onready var ShootNode = $CameraPivot/Camera3D/Bullets

@onready var BulletHole = preload("res://scenes/objects/BulletHole.tscn")
#Sounds
@onready var JumpSound = preload("res://audio/sfx/Playe/JumpSounds.tres")
@onready var ShootSound = preload("res://audio/sfx/gun/Shoot.ogg")
@onready var NoBulletSound = preload("res://audio/sfx/gun/154934__klawykogut__empty-gun-shot.wav")


signal Use(user)
signal UnUse(user)
signal SecondUse(user)
signal UnSecondUse(user)

func _ready():
	MoveSpeed = WalkSpeed
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GunPos = GunStartPos
	Global.UpdateUi.connect(UpdateUi)
	Global.UpHp.connect(Heal)
	Global.UpAmmo.connect(PickupAmmo)
	Global.UpMoney.connect(PickupMoney)
	UpdateUi()
	Inventory.NewItem.connect(NewItem)
	Inventory.InvChanged.connect(UpdateInv)
	Inventory.Start(self)
	UpdateInvScroll()
func _physics_process(delta):
	$CameraPivot/Camera3D.rotation_degrees.x = CameraDirection.x + CameraOffset.x
	if not Dead:
		if SuperJumpBuffer > 0.0:
			SuperJumpBuffer -= delta
			$CanvasLayer/UI/Speed.text = str(SuperJumpBuffer) 
		#$CanvasLayer/UI/Speed.text = str(Vector2(velocity.x,velocity.z).length())
		#Camera Stuff
		
		$CameraPivot/Camera3D.fov = lerp($CameraPivot/Camera3D.fov,Fov,0.2)
		CameraOffset.x = lerp(CameraOffset.x,0.0,0.1)
		$CameraPivot/Camera3D.v_offset = lerp($CameraPivot/Camera3D.v_offset,Bobset,0.1)
		$CameraPivot.rotation_degrees = lerp($CameraPivot.rotation_degrees, Vector3(TiltDir.y,0,TiltDir.x), 0.1)
		$CameraPivot/Camera3D.position = lerp($CameraPivot/Camera3D.position,Vector3(0,0.5,0),0.3)
		#Aim Lerp
		$CameraPivot/Camera3D/Gun.position = lerp($CameraPivot/Camera3D/Gun.position,GunPos,0.4)
		
		
		#Friction
		
		#Gravity
		velocity.y -= 1
		#Inputs
		var inputDir = Input.get_vector("Left","Right","Forward","Backward")
		var irt = inputDir.rotated(-rotation.y)
		
		if not InvOpen:
			if Input.is_action_just_pressed("Shoot"):
				if not $GunAnims.current_animation == "PullOut":
					emit_signal("Use",self)
			if Input.is_action_just_released("Shoot"):
				emit_signal("UnUse",self)
			if Input.is_action_just_pressed("Aim"):
				emit_signal("SecondUse",self)

			if Input.is_action_just_released("Aim"):
				emit_signal("UnSecondUse",self)
		if Input.is_action_just_pressed("Sprint"):
			UnAim()
			Sprint()
		if Input.is_action_just_released("Sprint"):
			if Sprinting:
				UnSprint()
		if Input.is_action_just_pressed("Jump"):
				SuperJumpBuffer = 0.1
		if Input.is_action_just_pressed("Interact"):
			if $CameraPivot/Camera3D/UseCast.is_colliding():
				$CameraPivot/Camera3D/UseCast.get_collider().get_parent().Interact(self)
		if inputDir != Vector2.ZERO:
			if Sprinting:
				Fov = 90.0
		else:
			if Sprinting:
				Fov = 75.0
		if is_on_floor():
			velocity = lerp(velocity, Vector3(0,velocity.y,0),0.25)
			velocity += Vector3(irt.x,0,irt.y) * MoveSpeed * MoveSpeedScale
			
			if inputDir != Vector2.ZERO and not Aiming:
				$AnimationPlayer.play("Walk")
				
			else:
				$AnimationPlayer.stop(true)
				Bobset = 0.0

			
			if Input.is_action_pressed("Jump"):
				if SuperJumpBuffer > 0.0:
					velocity.y += 16
				else:
					velocity.y = 16
					#$AudioStreamPlayer3D.stream = JumpSound
					#$AudioStreamPlayer3D.play()
			
			
		else:
			$AnimationPlayer.play("Idle" )
			velocity = lerp(velocity, Vector3(0,velocity.y,0),0.025)
			velocity += Vector3(irt.x,0,irt.y) * (MoveSpeed * MoveSpeedScale * 0.17)
			if Aiming:
				Bobset = velocity.y/256
			else:
				Bobset = velocity.y/32
		LastPos = position
		move_and_slide()
		if is_on_floor():
			if abs(position.y - LastPos.y)>0.01:
				
				var dist = position.y - LastPos.y
				$CameraPivot/Camera3D.position.y -= dist
		TiltDir = Vector2(-inputDir.x*(4+(6*int(Sprinting))),inputDir.y*10* int(Sprinting))
func _input(event):
	if not Dead and not LookDisabled:
		if event is InputEventMouseMotion:
			rotation_degrees.y -= event.relative.x * Sensitivity
			CameraDirection.x -= event.relative.y * Sensitivity
			CameraDirection.x = clamp(CameraDirection.x, -90.0,90.0)
	if event.is_action_pressed("Flashlight"):
		$CameraPivot/Camera3D/SpotLight3D.visible = !$CameraPivot/Camera3D/SpotLight3D.visible
		$FlashlightSound.play()
	if event.is_action_pressed("InvUp"):
		if not InvOpen:
			Inventory.MoveRight()
		else:
			$CanvasLayer/Inventory.PageUp()
	if event.is_action_pressed("InvDown"):
		if not InvOpen:
			Inventory.MoveLeft()
		else:
			$CanvasLayer/Inventory.PageDown()
	if event.is_action_pressed("Inventory"):
		$CanvasLayer/Inventory.visible = true
		$CanvasLayer/Inventory.Open()
		Inventory
		LookDisabled = true
		InvOpen = true
		
	if event.is_action_released("Inventory"):
		$CanvasLayer/Inventory.visible = false
		$CanvasLayer/Inventory.Active = false
		LookDisabled = false
		InvOpen = false


func PickUpItem(pick):
	pick.PickUp(self)
	Inventory.AddItem(pick)
	pick.get_parent().remove_child(pick)
func UpdateInv():
	UpdateInvScroll()
func UpdateInvScroll():
	if Inventory.content.size() > 0:
		$CanvasLayer/ScrollThing/AnimationPlayer.stop()
		$CanvasLayer/ScrollThing/AnimationPlayer.play("Fade")
		$CanvasLayer/ScrollThing/Selected.texture = Inventory.content[Inventory.curselect].icon
		if Inventory.curselect == Inventory.content.size() -1:
			$CanvasLayer/ScrollThing/Foreward.hide()
		else:
			$CanvasLayer/ScrollThing/Foreward.show()
			$CanvasLayer/ScrollThing/Foreward.texture = Inventory.content[Inventory.curselect+1].icon
		if Inventory.curselect == 0:
			$CanvasLayer/ScrollThing/Backward.hide()
		else:
			$CanvasLayer/ScrollThing/Backward.texture = Inventory.content[Inventory.curselect-1].icon
			$CanvasLayer/ScrollThing/Backward.show()
func NewItem(item:Item):
	$GunAnims.stop()
	$GunAnims.play("PullOut")
	$CameraPivot/Camera3D/Gun.remove_child($CameraPivot/Camera3D/Gun.get_child(0))
	$CameraPivot/Camera3D/Gun.add_child(item)
	UpdateInvScroll()
	if Aiming:
		UnAim()
func Heal(am:float):
	HP += am
	HP = clamp(HP,0.0,100.0)
	$ScreenAnims.play("Heal")
	$AudioStreamPlayer3D.stream = load("res://audio/sfx/heal.ogg")
	$AudioStreamPlayer3D.play()
func PickupMoney():
	$AudioStreamPlayer3D.stream = load("res://audio/sfx/coin.ogg")
	$AudioStreamPlayer3D.play()
func PickupAmmo():
	$AudioStreamPlayer3D.stream = load("res://audio/sfx/ammo.ogg")
	$AudioStreamPlayer3D.play()
func Hurt(am:float):
	if not Dead:
		HP -= am
		$ScreenAnims.play("Hurt")
		$AudioStreamPlayer3D.stream = JumpSound
		$AudioStreamPlayer3D.play()
		UpdateUi()
		if HP <= 0:
			Die()
func Die():
	if not Dead:
		Dead = true
		$AnimationPlayer.play("Dead")
		$ScreenAnims.play("Die")
		CameraDirection.x = 0
		await  $AnimationPlayer.animation_finished
		if Global.Lives <= 0:
			get_tree().change_scene_to_file("res://scenes/screens/DeathScreen.tscn")
		Global.Lives -= 1
		position = Global.Checkpoint
		UnDie()
	
func Aim():
	$AnimationPlayer.stop(true)
	Aiming = true
	GunPos = GunAimPos
	MoveSpeed = AimSpeed
	Fov = 50.0
	Sprinting = false
func UnAim():
	Aiming = false
	GunPos = GunStartPos
	MoveSpeed = WalkSpeed
	Fov = 75.0
func Sprint():
	MoveSpeed = RunSpeed
	Sprinting = true
	$AnimationPlayer.speed_scale = 0.75
	Aiming = false
func UnSprint():
	MoveSpeed = WalkSpeed
	Fov = 75.0
	Sprinting = false
	$AnimationPlayer.speed_scale = 0.5

func UpdateUi():
	$CanvasLayer/UI/Money.text = str("$",Global.Money)
	$CanvasLayer/UI/Health.text = str(int(HP))
	$CanvasLayer/UI/Ammo.text = str(Global.Ammo)
	$CanvasLayer/UI/Lives.text = str("x", Global.Lives)



func UnDie():
	Dead = false
	HP = 100.0
	Global.Ammo = 12
	UpdateUi()
	$ScreenAnims.play_backwards("Die")
	$CameraPivot.rotation = Vector3()

func _on_hurtbox_area_entered(area):
	if area.is_in_group("Pickup"):
		PickUpItem(area.get_parent())
		print("peepee")
	if area.is_in_group("Hurt"):
		Hurt(10)
