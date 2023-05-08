extends CharacterBody3D


@export var MoveSpeed = 1.0

var FacingDir = Vector2.UP
var Sensitivity = 0.5


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _physics_process(delta):
	velocity = lerp(velocity, Vector3(0,velocity.y,0),0.3)
	velocity.y -= 1
	var inputDir =Input.get_vector("Left","Right","Forward","Backward")
	var irt = inputDir.rotated(-rotation.y)
	velocity += Vector3(irt.x,0,irt.y) * MoveSpeed
	if is_on_floor():
		if inputDir != Vector2.ZERO:
			$AnimationPlayer.play("Walk")
		else:
			$AnimationPlayer.play("Idle")
		if Input.is_action_pressed("Jump"):
			velocity.y += 16
	else:
		$Camera3D.v_offset = lerp($Camera3D.v_offset,velocity.y/30,0.1 )
	move_and_slide()
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * Sensitivity
		$Camera3D.rotation_degrees.x -= event.relative.y * Sensitivity
		$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -90.0,90.0)
