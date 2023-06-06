extends CharacterBody3D

enum STATES {idle, pathfind, seek}

var State = STATES.idle
@onready var NavAgent = $NavigationAgent3D

@export var MoveSpeed = 1.5
@export var HP = 100

var EyeTarget = null


func _physics_process(delta):
	if EyeTarget != null:
		$Eye.target_position = ($Eye.position + position).direction_to(EyeTarget.position) * 100
		if $Eye.is_colliding():
			if $Eye.get_collider() == EyeTarget:
				State = STATES.pathfind
	velocity = lerp(velocity,Vector3(0,velocity.y,0),0.25)
	var dir2Target = Vector3()
	if State == STATES.pathfind:
		dir2Target = position.direction_to(Vector3(NavAgent.get_next_path_position().x,0,NavAgent.get_next_path_position().z))
		rotation.y = Vector2(-position.direction_to(EyeTarget.position).z,-position.direction_to(EyeTarget.position).x).angle()
	else:
		dir2Target = Vector3()
		rotation.y = Vector2(-velocity.z,-velocity.x).angle()
	velocity += Vector3(dir2Target.x,0,dir2Target.z) *  MoveSpeed
	velocity.y -= 1
	
	$Eye.global_rotation.y = 0
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


func OnVisionExit(body):
	if body.is_in_group("Player"):
		pass
		print("dou")
