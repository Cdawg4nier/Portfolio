extends Node2D

#This Scene will:
# - Open when the "level select" button is pressed on the main menu
# - Display a small graphic for each "world"
# - Have arrow buttons on the left and right for rotating through the worlds
# - Respond to user inputs to switch between worlds
# - When a world is selected, zoom in on the world and show the individual maps
# - Allow the user to select a map
# - Confirm the user would like to start a map
# - Send the map data to Runtime and switch to the runtime scene once it is ready
# - Stall for time while the Runtime node gets the game ready

var runtime_scene = preload("res://Scenes/Runtime.tscn")

var map_1_1_scene = "res://Scenes/Maps/World 1 - Human/Map 1-1.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed("load_level")):
		if (ResourceLoader.load_threaded_get_status(map_1_1_scene) != 3):
			background_load(map_1_1_scene)

		elif (ResourceLoader.load_threaded_get_status(map_1_1_scene) == 3):
			var scene_to_load = ResourceLoader.load_threaded_get(map_1_1_scene).instantiate()
			
			runtime_scene = runtime_scene.instantiate()
			get_tree().root.add_child(runtime_scene)
			runtime_scene.set_map_data(scene_to_load)
			queue_free()

	pass
	

func background_load(level_path: String):
	ResourceLoader.load_threaded_request(level_path)
