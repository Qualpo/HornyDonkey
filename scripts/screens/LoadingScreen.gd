extends Control
@export var scene:String = "res://scenes/levels/Level1.tscn"
var Progress = []
var SceneLoadStatus = 0
var doing = false
# Called when the node enters the scene tree for the first time.
func _ready():
	discord_sdk.state = "Loading"
	discord_sdk.refresh()
	scene = Global.TargetScenePath
	ResourceLoader.load_threaded_request(scene)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	SceneLoadStatus = ResourceLoader.load_threaded_get_status(scene,Progress)
	$ProgressBar.value = Progress[0] * 100
	if SceneLoadStatus == ResourceLoader.THREAD_LOAD_LOADED:
		if not doing:
			doing = true
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene))
