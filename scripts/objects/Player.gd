extends CharacterBody3D


@export var MoveSpeed = 1.0
@export var HP = 100.0

var FacingDir = Vector2.UP
var GunStartPos = Vector3(0.625,-0.32,-0.529)
var GunAimPos = Vector3(0,-0.222,-0.184)

var GunPos = Vector3()

var Sensitivity = 0.5
var CamEnd = 0.0

var Aiming = false

var RNG = RandomNumberGenerator.new()

@onready var BulletHole = preload("res://scenes/objects/BulletHole.tscn")

@onready var JumpSound = preload("res://audio/sfx/Playe/JumpSounds.tres")


func _ready():
	Global.Player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GunPos = GunStartPos
func _physics_process(delta):
	
	$CameraPivot/Camera3D.rotation_degrees.x = lerp($CameraPivot/Camera3D.rotation_degrees.x,CamEnd,0.2)
	
	$CameraPivot/Camera3D/Gun.position = lerp($CameraPivot/Camera3D/Gun.position,GunPos,0.4)
	
	velocity = lerp(velocity, Vector3(0,velocity.y,0),0.3)
	velocity.y -= 1
	var inputDir =Input.get_vector("Left","Right","Forward","Backward")
	var irt = inputDir.rotated(-rotation.y)
	velocity += Vector3(irt.x,0,irt.y) * MoveSpeed
	
	#Inputs
	if Input.is_action_just_pressed("Shoot"):
		Shoot()
	if Input.is_action_just_pressed("Aim"):
		GunPos = GunAimPos
	if Input.is_action_just_released("Aim"):
		GunPos = GunStartPos
	
	if is_on_floor():
		if inputDir != Vector2.ZERO:
			$AnimationPlayer.play("Walk")
		else:
			$AnimationPlayer.stop(true)
			$CameraPivot/Camera3D.v_offset = lerp($CameraPivot/Camera3D.v_offset,0.0,0.1 )
		if Input.is_action_pressed("Jump"):
			velocity.y += 16
			$AudioStreamPlayer3D.stream = JumpSound
			$AudioStreamPlayer3D.play()
			$AnimationPlayer.stop()
	else:
		$CameraPivot/Camera3D.v_offset = lerp($CameraPivot/Camera3D.v_offset,velocity.y/30,0.1 )
	move_and_slide()
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * Sensitivity
		CamEnd -= event.relative.y * Sensitivity
		CamEnd = clamp(CamEnd, -90.0,90.0)

func Heal(am:float):
	HP += am
	HP = clamp(HP,0.0,100.0)

func Shoot():
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
				
						Cast.get_collider().Hit(false,self,30)
					else:
						var hole = BulletHole.instantiate()
				
						get_parent().add_child(hole)
						hole.position = Cast.get_collision_point() + (Cast.get_collision_normal()/80)
						if abs(Cast.get_collision_normal().y) == 1:
							hole.rotation_degrees.x = 90
						else:
							hole.look_at(Cast.get_collision_point()-Cast.get_collision_normal(),Vector3.FORWARD)
				Cast.queue_free()
	$CameraPivot/Camera3D.rotation_degrees.x += 7
	CamEnd += 3
	CamEnd = clamp(CamEnd,-90,90)
