extends CharacterBody3D


var FacingDir = Vector2.UP
var Sensitivity = 0.8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _physics_process(delta):
	# Add the gravity.
	velocity = lerp(velocity, Vector3(0,velocity.y,0),0.3)
	var inputDir =Input.get_vector("Left","Right","Forward","Backward")
	var irt = inputDir.rotated(-rotation.y)
	velocity += Vector3(irt.x,0,irt.y)
	if inputDir != Vector2.ZERO:
		$AnimationPlayer.play("Walk")
	else:
		$AnimationPlayer.play("Idle")
	move_and_slide()
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * Sensitivity
		$Camera3D.rotation_degrees.x -= event.relative.y * Sensitivity
		$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -90.0,90.0)
