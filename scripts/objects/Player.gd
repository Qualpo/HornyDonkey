extends CharacterBody3D


@export var WalkSpeed = 1.0
@export var RunSpeed = 2.0
@export var AimSpeed = 0.5
@export var HP = 100.0
@export_range(0.0,1.0,0.01) var Sensitivity = 0.5
@export var Bobset = 0.0

var FacingDir = Vector2.UP
var CameraDirection = Vector2()
var CameraOffset = Vector2()
var TiltDir = Vector2()
var GunStartPos = Vector3(0.625,-0.32,-0.529)
var GunAimPos = Vector3(0,-0.230,-0.184)
var GunPos = Vector3()


var RecoilAmt = 3.0
var Fov = 75.0
var MoveSpeed = 1.0


var Aiming = false
var Sprinting = false
var Shooting = false

var RNG = RandomNumberGenerator.new()

@onready var BulletHole = preload("res://scenes/objects/BulletHole.tscn")
#Sounds
@onready var JumpSound = preload("res://audio/sfx/Playe/JumpSounds.tres")
@onready var ShootSound = preload("res://audio/sfx/gun/Shoot.ogg")
@onready var NoBulletSound = preload("res://audio/sfx/gun/154934__klawykogut__empty-gun-shot.wav")


func _ready():
	MoveSpeed = WalkSpeed
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GunPos = GunStartPos
	Global.UpdateUi.connect(UpdateUi)
	Global.UpHp.connect(Heal)
	Global.UpAmmo.connect(PickupAmmo)
	Global.UpMoney.connect(PickupMoney)
	UpdateUi()
func _physics_process(delta):
	
	#Camera Stuff
	$CameraPivot/Camera3D.rotation_degrees.x = CameraDirection.x + CameraOffset.x
	$CameraPivot/Camera3D.fov = lerp($CameraPivot/Camera3D.fov,Fov,0.2)
	CameraOffset.x = lerp(CameraOffset.x,0.0,0.1)
	$CameraPivot/Camera3D.v_offset = lerp($CameraPivot/Camera3D.v_offset,Bobset,0.1)
	$CameraPivot.rotation_degrees = lerp($CameraPivot.rotation_degrees, Vector3(TiltDir.y,0,TiltDir.x), 0.1)
	#Aim Lerp
	$CameraPivot/Camera3D/Gun.position = lerp($CameraPivot/Camera3D/Gun.position,GunPos,0.4)
	
	#Friction
	
	#Gravity
	velocity.y -= 1
	#Inputs
	var inputDir =Input.get_vector("Left","Right","Forward","Backward")
	var irt = inputDir.rotated(-rotation.y)
	
	if Input.is_action_just_pressed("Shoot"):
		Shoot()
	if Input.is_action_just_pressed("Aim"):
		UnSprint()
		Aim()
	if Input.is_action_just_released("Aim"):
		if Aiming:
			UnAim()
	if Input.is_action_just_pressed("Sprint"):
		UnAim()
		Sprint()
	if Input.is_action_just_released("Sprint"):
		if Sprinting:
			UnSprint()
		
	if inputDir != Vector2.ZERO:
		if Sprinting:
			Fov = 90.0
	else:
		if Sprinting:
			Fov = 75.0
	if is_on_floor():
		velocity = lerp(velocity, Vector3(0,velocity.y,0),0.3)
		velocity += Vector3(irt.x,0,irt.y) * MoveSpeed
		if inputDir != Vector2.ZERO and not Aiming:
			$AnimationPlayer.play("Walk")
		else:
			$AnimationPlayer.stop(true)
			Bobset = 0.0
		if Input.is_action_pressed("Jump"):
			velocity.y += 16
			$AudioStreamPlayer3D.stream = JumpSound
			$AudioStreamPlayer3D.play()
			
	else:
		$AnimationPlayer.play("Idle" )
		velocity = lerp(velocity, Vector3(0,velocity.y,0),0.025)
		velocity += Vector3(irt.x,0,irt.y) * (MoveSpeed * 0.15)
		if Aiming:
			Bobset = velocity.y/256
		else:
			Bobset = velocity.y/32
	move_and_slide()
	TiltDir = Vector2(-inputDir.x*(4+(6*int(Sprinting))),inputDir.y*10* int(Sprinting))
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * Sensitivity
		CameraDirection.x -= event.relative.y * Sensitivity
		CameraDirection.x = clamp(CameraDirection.x, -90.0,90.0)

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
	HP -= am
	$ScreenAnims.play("Hurt")
	$AudioStreamPlayer3D.stream = JumpSound
	$AudioStreamPlayer3D.play()
	UpdateUi()
	if HP <= 0:
		Die()
func Die():
	if Global.Lives <= 0:
		get_tree().quit()
	Global.Lives -= 1
	get_tree().reload_current_scene()
	
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

func Shoot():
	if not Shooting and Global.Ammo > 0:
		Global.Ammo -= 1
		UpdateUi()
		Shooting = true
		if $GunSound.stream != ShootSound:
			$GunSound.stream = ShootSound
		$GunSound.play()
		$GunAnims.stop()
		$GunAnims.play("Shoot")

		for i in range(1):
			var rand = (abs(1-1))*25
			var spread = Vector2(RNG.randf_range(-rand,rand),RNG.randf_range(-rand,rand))
			var Cast:RayCast3D = RayCast3D.new()
			$CameraPivot/Camera3D/Bullets.add_child(Cast)
			Cast.position = Vector3()
			Cast.enabled = true
			Cast.target_position = Vector3(0,0,-1000)
			Cast.collision_mask = 5
			Cast.rotation_degrees = Vector3(spread.x,spread.y,0)
			Cast.force_raycast_update()
		for Cast in $CameraPivot/Camera3D/Bullets.get_children():
					if Cast.is_colliding():
						
					
						if Cast.get_collider().is_in_group("Enemy"):
					
							Cast.get_collider().Hit(false,self,Global.GunDamage)
						else:
							var hole = BulletHole.instantiate()
					
							get_parent().add_child(hole)
							hole.position = Cast.get_collision_point() + (Cast.get_collision_normal()/80)
							if abs(Cast.get_collision_normal().y) == 1:
								hole.rotation_degrees.x = 90
							else:
								hole.look_at(Cast.get_collision_point()-Cast.get_collision_normal(),Vector3.UP)
					Cast.queue_free()
		CameraOffset.x += RecoilAmt * 3
		CameraDirection.x += RecoilAmt
		CameraDirection.x = clamp(CameraDirection.x,-90,90)

		await get_tree().create_timer(0.15).timeout
		Shooting = false
	elif not Shooting:
		if $GunSound.stream != NoBulletSound:
			$GunSound.stream = NoBulletSound
		$GunSound.play()


func _on_hurtbox_area_entered(area):
	Hurt(10)
