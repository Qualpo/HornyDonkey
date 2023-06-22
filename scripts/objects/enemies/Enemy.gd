extends CharacterBody3D

enum STATES {idle, pathfind, seek}

var State = STATES.idle
@onready var NavAgent = $NavigationAgent3D

@export var Enabled = false

@export var MoveSpeed = 1.5
@export var HP = 100
@export var Damage = 100
@export var ViewRadius = 5.0
@export var ViewFov = 75.0
@export var Friction = 0.25

var EyeTarget = null

signal See(P:Player)

func _ready():
	var Shape = SphereShape3D.new()
	Shape.radius = ViewRadius
	$Vision/CollisionShape3D2.shape = Shape
	$Vision/Eye.target_position = Vector3(0,0,-ViewRadius)

func _physics_process(delta):
	if Enabled:
		if EyeTarget != null:
			$Vision/Eye.look_at(EyeTarget.position)
			$Vision/Eye.rotation_degrees.x = clamp($Vision/Eye.rotation_degrees.x, -ViewFov,ViewFov)
			$Vision/Eye.rotation_degrees.y = clamp($Vision/Eye.rotation_degrees.y, -ViewFov,ViewFov)
			$Vision/Eye.rotation_degrees.z = clamp($Vision/Eye.rotation_degrees.z, -ViewFov,ViewFov)
			if $Vision/Eye.is_colliding():
				
				if $Vision/Eye.get_collider() == EyeTarget:
					print("peepoo")
					State = STATES.pathfind
		velocity = lerp(velocity,Vector3(0,velocity.y,0),Friction)
		var dir2Target = Vector3()
		if State == STATES.pathfind:
			dir2Target = position.direction_to(Vector3(NavAgent.get_next_path_position().x,0,NavAgent.get_next_path_position().z))
			rotation.y = Vector2(-position.direction_to(EyeTarget.position).z,-position.direction_to(EyeTarget.position).x).angle()
		else:
			dir2Target = Vector3()
			if velocity > Vector3():
				rotation.y = Vector2(-velocity.z,-velocity.x).angle()
		velocity += Vector3(dir2Target.x,0,dir2Target.z).normalized() *  MoveSpeed
		velocity.y -= 1
		
		move_and_slide()

func UpdateTargetLocation(tarloc):
	NavAgent.set_target_position(tarloc)
func Hit(head,hitter,damage):
	var dam = damage
	if head:
		dam * 2
	HP -= dam
	if HP <= 0:
		queue_free()

func _on_target_timer_timeout():
	UpdateTargetLocation(Global.PlayerPos)


func OnVisionEntered(body):
	if body.is_in_group("Player"):
		EyeTarget = body
		print("ni")
		emit_signal("See",body)


func OnVisionExit(body):
	if body.is_in_group("Player"):
		pass
		print("dou")
