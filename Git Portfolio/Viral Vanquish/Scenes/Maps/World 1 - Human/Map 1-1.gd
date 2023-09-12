extends Node2D

#This Scene Will:
# - Contain Hardcoded data for the grid size and boundry
# - Contain Hardcoded data for the location of the virus factories within the grid
# - Contain hardcoded data for the location of the player's starting point within the grid
# - Contain Hardcoded data for each virus factory, determining what it spawns, how frequently, and when it upgrades
# - Contain hardcoded data for special end of level rewards
# - Provide the background for the battle, as well as the sprites for the viruses
# - //The grid will start at (0, 0) and go positive from there (to keep everything positive)//

# This section will need to be rewritten manually for every level
@onready var factory_1 = get_node("Factories/Factory_1")
var factory_1_grid_location = Vector2(30,30)

func initialize_factories():
	factory_1.position += (factory_1_grid_location * SLOT_DIMENSIONS + Vector2(50, 50))


# Sets the number of grid tiles in the X and Y direction. A standard map is 50x50
const SLOT_GRID = Vector2(50,50)

#Slot dimensions will always be square (e.g. 100 by 100)
const SLOT_DIMENSIONS = Vector2(100,100)

@onready var grid_slots_node = get_node("Grid Slots")

var grid_array = []
var mouse_coordinates = Vector2.ZERO

@onready var slot_node = get_node("Player")

func _ready():
	initialize_grid()
	initialize_factories()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	mouse_coordinates.x = get_global_mouse_position().x
	mouse_coordinates.y = get_global_mouse_position().y
	
	
	pass
	

func _unhandled_input(event):
	
	#if (event.is_action_pressed("select_slot")):
	#	var temp_vector = find_slot_at_coordinates(mouse_coordinates)
	#	var selected_slot = grid_array[temp_vector.x][temp_vector.y]
	#	selected_slot.visible = false
	
	pass

func initialize_grid():
	for x in SLOT_GRID.x:
		var temp_array = []
		for y in SLOT_GRID.y:
			var new_slot = Sprite2D.new()
			new_slot.texture = load("res://Assets/Sprites/slot_border.png")
			grid_slots_node.add_child(new_slot)
			new_slot.position += Vector2(x * SLOT_DIMENSIONS.x + SLOT_DIMENSIONS.x * .5, y * SLOT_DIMENSIONS.x + SLOT_DIMENSIONS.x * .5)
			new_slot.scale *= 2
			temp_array.append(new_slot)
		grid_array.append(temp_array)

func find_slot_at_coordinates(coordinates: Vector2):
	if (coordinates.x < 0 or coordinates.y < 0): return
	if (coordinates.x > (SLOT_DIMENSIONS.x * SLOT_GRID.x) or coordinates.y > (SLOT_DIMENSIONS.x * SLOT_GRID.y)): return
	var temp_vector = Vector2(floor(coordinates.x / SLOT_DIMENSIONS.x), floor(coordinates.y / SLOT_DIMENSIONS.x))
	return grid_array[temp_vector.x][temp_vector.y]
