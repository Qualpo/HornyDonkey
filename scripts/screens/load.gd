extends Node

@onready var Menu = preload("res://scenes/screens/MainMenu.tscn")
var Mods = true
# Called when the node enters the scene tree for the first time.
func _ready():
	print("poop")
	var udir = DirAccess.open("user://")
	if not udir.dir_exists("patch"):
		udir.make_dir("patch")
	var dir = DirAccess.open("user://patch")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	if Mods:
			if not udir.dir_exists("mods"):
				udir.make_dir("mods")
			var mdir = DirAccess.open("user://mods")
			if mdir:
				mdir.list_dir_begin()
				var file_name = mdir.get_next()
				while file_name != "":
					if mdir.current_is_dir():
						print("Found directory: " + file_name)
					else:
						print("Found file: " + file_name)
					file_name = mdir.get_next()
			else:
				print("An error occurred when trying to access the path.")
	get_tree().change_scene_to_packed(Menu)
