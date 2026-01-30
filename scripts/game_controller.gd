extends Node


@export var editor_scenes :Array[PackedScene]


var player : PlayerCharacter
var camera: Camera2D
var unloaded_scenes : Array[UnloadedScene]
var scene_stack: Array[int] = []
var current_scene : LoadedScene

class UnloadedScene:
	var scene : PackedScene
	var scene_name : String


class LoadedScene:
	var index : int
	var scene : Node
	var scene_name : String

	func _init(scene_to_load :UnloadedScene,i:int) -> void:
		self.index = i
		scene_name = scene_to_load.scene_name
		scene = scene_to_load.scene.instantiate()


func load_next_scene():
	print("changing from scene ",current_scene.scene_name, " to ", unloaded_scenes[(current_scene.index+1) % unloaded_scenes.size()].scene_name )
	load_scene_by_index((current_scene.index+1) % unloaded_scenes.size())
	
	
func go_back():
	if scene_stack.is_empty():
		return
	var previous_index = scene_stack.pop_back()
	print(previous_index)
	load_scene_by_index(previous_index)


func _ready() -> void:
	for scene in editor_scenes:
		var new_scene = UnloadedScene.new()
		new_scene.scene = scene
		new_scene.scene_name = scene._bundled["names"][0]
		unloaded_scenes.append(new_scene)
	load_scene_by_index(0)


func load_scene_by_name(scene_name : String):
	var my_index = unloaded_scenes.find(func (s : UnloadedScene): return s.scene_name == scene_name)
	load_scene_by_index(my_index)


func load_scene_by_index( i :int):
	if current_scene != null:
		if scene_stack.is_empty() or scene_stack.back() != current_scene.index:
			scene_stack.append(current_scene.index)
		current_scene.scene.queue_free()
		current_scene = null
	current_scene = LoadedScene.new(unloaded_scenes[i],i)
	add_sibling.call_deferred(current_scene.scene)
	music_manager.play_music(current_scene.scene_name)
	
