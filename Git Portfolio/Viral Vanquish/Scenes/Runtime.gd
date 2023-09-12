extends Node2D

#This Scene will:
# PRE GAMEPLAY
# - Handle the moment to moment gameplay
# - On Call, load the Grid and Factories from the "Map" (received from the Map_Select scene)
# - After loading grid and enemy, show an overview to player
# - Allow player to select the elements they would like to bring (Up to their max)
# - Grab the element data, Prestige data, and XP data from the Profile for each element
# - Grab the Virus sprite and background data from the map, load it, display it
# DURING GAMEPLAY
# - Upon the player confirming their selected elements, begin the "Timer"
# - Provide timer data to the factories
# - Upgrade the factories at the appropriate time according to the data loaded from the "Map"
# - Load elemental images (from the periodic table) and their buttons in the top
# - Keep track of the Mouse's current location, as well as which "slot" on the grid it is occupying
# - Keep track of every Cell that is added to the Grid
# - Keep track of which cells have had elements implemented or bonded onto them
# - Provide location data to the viruses about the location of cells
# - CELL NETWORK
# - Keep track of the "Network" of cells
# - Disable all cells not connected to the network
# - When the network connects to a virus factory, start the process of shutting down the factory
# - Disable (but not destroy) Virus factories that have been connected to the network for a period of time
# POST GAMEPLAY
# - Give the player the victory when all virus factories have been shut down
# - Display Win screen
# - Display XP reward scene
# - Keep a running total of XP from eliminated viruses (Viruses will tell Runtime when to add XP)
# - Distribute XP to the towers based on the number of towers (communicate this XP to the Profile scene)
# - Award additional completion rewards from the Map
# - Take the player back to the Map_Select  or the Main_Menu or the Profile scene


var current_map
var camera_move_speed
var game_timer_starting_point
var game_timer = 0
var game_timer_last_frame = 0


var mouse_coordinates = Vector2.ZERO
var selected_slot = null
var temp_selected_slot

var base_cell_scene = preload("res://Scenes/Player/Elements/Base_Cell.tscn")

@onready var main_camera = get_node("Camera2D")
@onready var map_node = get_node("Map")

# Called when the node enters the scene tree for the first time.
func _ready():
	game_timer_starting_point = Time.get_ticks_msec()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	game_timer = Time.get_ticks_msec() - game_timer_starting_point
	send_time_data_to_children(game_timer - game_timer_last_frame)
	game_timer_last_frame = game_timer
	
	
	mouse_coordinates.x = get_global_mouse_position().x
	mouse_coordinates.y = get_global_mouse_position().y
	
	
	camera_move_speed = 10 / main_camera.zoom.x
	if (Input.is_action_pressed("move_camera_up", true)): main_camera.position.y -= camera_move_speed
	if (Input.is_action_pressed("move_camera_down", true)): main_camera.position.y += camera_move_speed
	if (Input.is_action_pressed("move_camera_left", true)): main_camera.position.x -= camera_move_speed
	if (Input.is_action_pressed("move_camera_right", true)): main_camera.position.x += camera_move_speed
	

var temp_zoom

func _unhandled_input(event):
	if (event.is_action_pressed("zoom_in")): 
		main_camera.zoom *= 1.08
		temp_zoom = min(main_camera.zoom.x, 2)
		main_camera.zoom = Vector2(temp_zoom, temp_zoom)
	if (event.is_action_pressed("zoom_out")): 
		main_camera.zoom *= .92
		temp_zoom = max(main_camera.zoom.x, .25)
		main_camera.zoom = Vector2(temp_zoom, temp_zoom)
	if (event.is_action_pressed("select_slot")):
		temp_selected_slot = current_map.find_slot_at_coordinates(mouse_coordinates)
		if (temp_selected_slot != null):
			if (selected_slot == null): selected_slot = temp_selected_slot
			if (temp_selected_slot != selected_slot):
				selected_slot.visible = true
				selected_slot = temp_selected_slot
			selected_slot.visible = !selected_slot.visible
		else:
			selected_slot.visible = true
			selected_slot = null
	if (event.is_action_pressed("create_new_cell")):
		var new_cell = base_cell_scene.instantiate()
		current_map.slot_node.add_child(new_cell)

func set_map_data(node: Node):
	self.add_child(node)
	current_map = node
	
	#connect_functions_from_map_to_self()

func send_time_data_to_children(time_passed):
	var nodes = get_tree().get_nodes_in_group("looking_for_time")
	for node in nodes:
		node.update_game_timer(time_passed)
	pass
