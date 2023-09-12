
extends Node2D

#Level
var machine = preload("res://Scenes/Machine.tscn")
var product = preload("res://Scenes/Product.tscn") # must use .instance(), since it's a packed scene
var cell = preload("res://Scenes/Cell.tscn")

var assembly_line_sequence_1 = []
var assembly_line_sequence_2 = []
var assembly_line_sequence_3 = []
var assembly_line_sequence_4 = []
var assembly_line_sequence_5 = []
var cells_on_grid = []

onready var cell_ring = $"Selected Cell Ring"

onready var my_viewport = get_viewport()

const SPRITE_DELTA = 39 # The 39 accounts for the size of the sprite
const GRID_SIZE = 78

var grid_size

func find_cell_at_grid_coordinates(coordinates):
	coordinates.x -= (219 - SPRITE_DELTA) 
	coordinates.y -= (241 - SPRITE_DELTA)
	if (coordinates.x < 0 or coordinates.y < 0): return
	if (coordinates.x > (GRID_SIZE * 20) or coordinates.y > (GRID_SIZE * 11)): return
	return Vector2(floor(coordinates.x / GRID_SIZE), floor(coordinates.y / GRID_SIZE))


func set_grid_size(grid_size):
	self.grid_size = grid_size

	## IMPORTANT ## I am manually setting the machine and Products scale to .78 to make this work
	
	#Theres room for (360) 180 pixels of buffer on either side of the horizontal grid
	#That leaves 222 pixels for space above the buttons, between buttons and grid, buttons, and below grid
	#100 of those pixels are for another machine to be the "button", leaving 122
	#that leaves 40 pixels between top of screen and buttons, 22 pixels between grid and buttons, and 60 pixels between grid and bottom of screen
	#there will be 4 pixels on the edge of each "grid" square, giving the image inside a 70x70 display area


func _ready():
	grid_size = GRID_SIZE #I'm hardcoding this number because the window will scale it and everything else when the window scales
	var x_position = 219
	var y_position = 241
	for a in range(20):
		var column_array = []
		for i in range(11):
			var new_sprite = cell.instance()
			column_array.append(new_sprite)
			$Cells.add_child(new_sprite)
			new_sprite.position = Vector2(x_position, y_position)
			y_position += 78
		y_position = 241
		x_position += 78
		cells_on_grid.append(column_array)
	$"Selected Cell Flicker".start(.25)
	ghost_machine = machine.instance()
	$Cells.add_child(ghost_machine)
	ghost_machine.visible = false
	
var mouse_coordinates = Vector2(0, 0)
var check_selected_cell = false
var selected_cell
var desired_machine
var ghost_machine
var display_ghost_machine
var edit_mode = false


func update_selected_cell():
	if (edit_mode): return
	var temp_vector
	var temp_cell
	temp_vector = find_cell_at_grid_coordinates(get_global_mouse_position())
	if (temp_vector != null):
		temp_cell = cells_on_grid[temp_vector.x][temp_vector.y]
		if (selected_cell and temp_cell != selected_cell): selected_cell.visible = true
		selected_cell = temp_cell


func _process(delta):
	mouse_coordinates.x = get_global_mouse_position().x - (219 - 39) #The 39 accounts for the size of the sprite
	mouse_coordinates.y = get_global_mouse_position().y - (241 - 39)
	if (mouse_coordinates.x < 0 or mouse_coordinates.y < 0): check_selected_cell = false
	elif (mouse_coordinates.x > (78 * 20) or mouse_coordinates.y > (78 * 11)): check_selected_cell = false
	else: check_selected_cell = true
	
	if (display_selector_ring and selected_cell):
		cell_ring.position = selected_cell.position
		cell_ring.visible = true
	else: cell_ring.visible = false
	
	if (Input.is_action_just_pressed("left_click")):
		if (check_selected_cell):
			update_selected_cell()
		else:
			if (selected_cell != null): selected_cell.visible = true
			selected_cell = null
		if (selected_cell != null):
			if(selected_cell.machine != null and !display_ghost_machine):
				edit_mode = true
				selected_cell.raise()
				selected_cell.machine.enable_edit_mode()
			pass
		if (display_ghost_machine):
			if (check_selected_cell and selected_cell != null):
				if (selected_cell.machine == null):
					selected_cell.machine = machine.instance()
					#selected_cell.machine.position = selected_cell.position
					selected_cell.add_child(selected_cell.machine)
					if (is_selected_button_conveyor): selected_cell.machine.set_machine_type_conveyor()
					elif (is_selected_button_grower): selected_cell.machine.set_machine_type_grower()
					elif (is_selected_button_incrementer): selected_cell.machine.set_machine_type_incrementer()
					elif (is_selected_button_stacker): selected_cell.machine.set_machine_type_stacker()
					elif (is_selected_button_sender): selected_cell.machine.set_machine_type_sender()
					elif (is_selected_button_receiver): selected_cell.machine.set_machine_type_receiver()
					selected_cell.visible = true
					selected_cell = null
					
					display_ghost_machine = false
					is_selected_button_conveyor = false
					is_selected_button_grower = false
					is_selected_button_incrementer = false
					is_selected_button_stacker = false
					is_selected_button_sender = false
					is_selected_button_receiver = false
	cell_ring.raise()
	
	if (Input.is_action_just_pressed("right_click")):
		edit_mode = false
		if (selected_cell):
			selected_cell.visible = true
			if (selected_cell.machine): selected_cell.machine.disable_edit_mode()
		selected_cell = null
		
		
	if (display_ghost_machine):
		ghost_machine.raise()
		ghost_machine.visible = true
		if (check_selected_cell):
			update_selected_cell()
			if (selected_cell != null): ghost_machine.position = selected_cell.position
		else:
			ghost_machine.position = Vector2(950, 100)
			selected_cell = null
		pass
	else:
		ghost_machine.visible = false


var is_selected_button_conveyor = false
var is_selected_button_grower = false
var is_selected_button_incrementer = false
var is_selected_button_stacker = false
var is_selected_button_sender = false
var is_selected_button_receiver = false


var display_selector_ring = false
func _on_Selected_Cell_Flicker_timeout():
	display_selector_ring = !display_selector_ring


func _on_Conveyor_Button_pressed():
	ghost_machine.set_machine_type_conveyor()
	if (is_selected_button_conveyor): display_ghost_machine = false
	else: display_ghost_machine = true
	is_selected_button_conveyor = !is_selected_button_conveyor
	is_selected_button_grower = false
	is_selected_button_incrementer = false
	is_selected_button_stacker = false
	is_selected_button_sender = false
	is_selected_button_receiver = false


func _on_Grower_Button_pressed():
	ghost_machine.set_machine_type_grower()
	if (is_selected_button_grower): display_ghost_machine = false
	else: display_ghost_machine = true
	is_selected_button_conveyor = false
	is_selected_button_grower = !is_selected_button_grower
	is_selected_button_incrementer = false
	is_selected_button_stacker = false
	is_selected_button_sender = false
	is_selected_button_receiver = false


func _on_Incrementer_Button_pressed():
	ghost_machine.set_machine_type_incrementer()
	if (is_selected_button_incrementer): display_ghost_machine = false
	else: display_ghost_machine = true
	is_selected_button_conveyor = false
	is_selected_button_grower = false
	is_selected_button_incrementer = !is_selected_button_incrementer
	is_selected_button_stacker = false
	is_selected_button_sender = false
	is_selected_button_receiver = false


func _on_Stacker_Button_pressed():
	ghost_machine.set_machine_type_stacker()
	if (is_selected_button_stacker): display_ghost_machine = false
	else: display_ghost_machine = true
	is_selected_button_conveyor = false
	is_selected_button_grower = false
	is_selected_button_incrementer = false
	is_selected_button_stacker = !is_selected_button_stacker
	is_selected_button_sender = false
	is_selected_button_receiver = false


func _on_Sender_Button_pressed():
	ghost_machine.set_machine_type_sender()
	if (is_selected_button_sender): display_ghost_machine = false
	else: display_ghost_machine = true
	is_selected_button_conveyor = false
	is_selected_button_grower = false
	is_selected_button_incrementer = false
	is_selected_button_stacker = false
	is_selected_button_sender = !is_selected_button_sender
	is_selected_button_receiver = false


func _on_Receiver_Button_pressed():
	ghost_machine.set_machine_type_receiver()
	if (is_selected_button_receiver): display_ghost_machine = false
	else: display_ghost_machine = true
	is_selected_button_conveyor = false
	is_selected_button_grower = false
	is_selected_button_incrementer = false
	is_selected_button_stacker = false
	is_selected_button_sender = false
	is_selected_button_receiver = !is_selected_button_receiver


func _on_TextureButton7_pressed():
	ghost_machine.set_machine_type_conveyor()

