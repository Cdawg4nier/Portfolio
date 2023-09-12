
extends Node2D

#Machine
enum TYPE {IMPORT, EXPORT, CONVEYOR, GROWER, INCREMENTER, STACKER, SENDER, RECEIVER}
var BASIC_ANIMATIONS = {
	TYPE.IMPORT: "Import",
	TYPE.EXPORT: "Export",
	TYPE.GROWER: "Grower",
	TYPE.INCREMENTER: "Incrementer",
	TYPE.STACKER: "Stacker",
	TYPE.SENDER: "Sender",
	TYPE.RECEIVER: "Receiver"
}

var TEXTURES = {
	"Import": load("res://Assets/Machines/machine_importer.png"),
	"Export": load("res://Assets/Machines/machine_export.png"),
	"Conveyor": load("res://Assets/Machines/machine_conveyor.png"),
	"Grower": load("res://Assets/Machines/machine_grower.png"),
	"Incrementer":  load("res://Assets/Machines/machine_incrementer.png"),
	"Stacker":  load("res://Assets/Machines/machine_stacker.png"),
	"Sender":  load("res://Assets/Machines/machine_sender.png"),
	"Receiver":  load("res://Assets/Machines/machine_receiver.png"),
	}

var DIRECTIONS = {
	"ul": Vector2(-1, -1),
	"u": Vector2(0, -1),
	"ur": Vector2(1, -1),
	"l": Vector2(-1, 0),
	"r": Vector2(1, 0),
	"dl": Vector2(-1, 1),
	"d": Vector2(0, 1),
	"dr": Vector2(1, 1)
}

var machine_type
var product_1
var product_2
var filter

var input_direction_1
var input_direction_2
var output_direction

onready var anime = get_node("AnimationPlayer")
var animation_type
var product = preload("res://Scenes/Product.tscn")

onready var my_sprite = get_node("Sprite")

var grid_size
var grid_location
var selectable

var next_machine

onready var product_spawn_point = get_node("Product_Spawn_Point")


func _init():
	machine_type = TYPE.CONVEYOR
	grid_location = Vector2.ZERO
	input_direction_1 = Vector2.ZERO
	input_direction_2 = Vector2.ZERO
	output_direction = Vector2.ZERO
	selectable = true
	

func initialize_with_values(imachine_type, ifilter, iinput_direction_1, iinput_direction_2, ioutput_direction, igrid_size, igrid_location, iselectable):
	machine_type = imachine_type
	filter = ifilter
	input_direction_1 = iinput_direction_1
	input_direction_2 = iinput_direction_2
	output_direction = ioutput_direction
	grid_size = igrid_size
	grid_location = igrid_location
	selectable = iselectable


func activate():
	if (machine_type == TYPE.IMPORT):
		import_product()
		return
	if (!product_1): return
	match machine_type:
		TYPE.EXPORT: export_product()
		TYPE.CONVEYOR: convey()
		TYPE.GROWER: grow_product()
		TYPE.INCREMENTER: increment_product()
		TYPE.STACKER: stack_product()
		TYPE.SENDER: teleport_product()
		TYPE.RECEIVER: push_received_product()



func set_input_direction_1(direction):
	if direction != input_direction_2 and direction != output_direction: 
		input_direction_1 = direction

	
func set_input_direction_2(direction):
	if direction != input_direction_1 and direction != output_direction: 
		input_direction_2 = direction

	
func set_output_direction(direction):
	if direction != input_direction_1 and direction != input_direction_2: 
		output_direction = direction

	
func set_next_machine(next_machine):
	self.next_machine = next_machine


func push_to_next_machine():
	if next_machine.product_1 and next_machine.machine_type == TYPE.STACKER:
		next_machine.product_2 = product_1
	elif !next_machine.product_1: 
		next_machine.product_1 = product_1
	product_1.set_move_direction(output_direction)
	self.product_1 = null

#####################################################################################
#Import specific code

func set_machine_type_import():
	input_direction_1 = Vector2.ZERO
	input_direction_2 = Vector2.ZERO
	output_direction = DIRECTIONS.r
	update_direction_display()
	machine_type = TYPE.IMPORT
	my_sprite.texture = TEXTURES["Import"]


func set_import_filter(filter):
	self.filter = filter
	self.filter.can_move = false
	self.filter.position = Vector2.ZERO
	need_input_button_2 = false
	

func import_product():
	self.product_1 = self.filter.duplicate(8)
	self.product_spawn_point.add_child(self.product_1)
	push_to_next_machine()

#################################################################################
#Export specific code
signal score_points

func set_machine_type_export():
	input_direction_1 = DIRECTIONS.l
	input_direction_2 = Vector2.ZERO
	output_direction = Vector2.ZERO
	update_direction_display()
	need_input_button_2 = false
	machine_type = TYPE.EXPORT
	my_sprite.texture = TEXTURES["Export"]


func set_export_filter(ifilter):
	filter = ifilter
	filter.can_move = false
	filter.position = Vector2.ZERO

	
func export_product():
	if (
		filter.color == product_1.color and
		filter.sides == product_1.sides and
		filter.size == product_1.size
	): #If product matches filter, check for children
		if (filter.child): #if the filter has a child, go on
			if (product_1.child): #if the product also has a child
				if (
					filter.child.color == product_1.child.color and
					filter.child.sides == product_1.child.sides and
					filter.child.size == product_1.child.size
				): #Compare the children to each other, go on if they match
					if (filter.child.child): #If the filter is a 3 stack
						if (product_1.child.child): #if the product is also a 3 stack
							if (
								filter.child.child.color == product_1.child.child.color and
								filter.child.child.sides == product_1.child.child.sides and
								filter.child.child.size == product_1.child.child.size
							): #compare the 3 stack. If everything checks out, give points
								print ("Everything matches on the 3 stacks, scoring points")
								emit_signal("score_points")
							else: 
								#return if the 3rd stacked item does not match
								pass
						else: 
							#return if the product does not have a 3 stack
							pass
					elif (product_1.child.child): 
						#If the filter does not have 3, but product does
						pass
					else: 
						#The filter doesn't have a 3 stack, and neither does the product
						emit_signal ("score_points") 
				else:
					#return if the children do not match
					pass
			else:
				#the product does not have a child, but the filter does
				pass
		elif (product_1.child): 
			#Filter has no child, but the product does
			pass
		else:
			#The filter and product are 1 stacks, and they match
			emit_signal("score_points") 
	else: 
		 #The first product of the product_1 does not match the filter
		pass
	product_1.queue_free()
	
	
##########################################################################################
#Conveyor specific code
func set_machine_type_conveyor():
	input_direction_1 = DIRECTIONS.l
	input_direction_2 = Vector2.ZERO
	output_direction = DIRECTIONS.r
	update_direction_display()
	need_input_button_2 = false
	machine_type = TYPE.CONVEYOR
	my_sprite.texture = TEXTURES["Conveyor"]
	

func set_convey_animation_direction():
	pass #TODO: write code


func convey():
	push_to_next_machine()

######################################################################################
#Grower specific code

func set_machine_type_grower():
	input_direction_1 = DIRECTIONS.l
	input_direction_2 = Vector2.ZERO
	output_direction = DIRECTIONS.r
	update_direction_display()
	need_input_button_2 = false
	machine_type = TYPE.GROWER
	my_sprite.texture = TEXTURES["Grower"]
	

func grow_product():
	product_1.increase_size()
	push_to_next_machine()
	
#####################################################################################
#Incrementer specific code

func set_machine_type_incrementer():
	input_direction_1 = DIRECTIONS.l
	input_direction_2 = Vector2.ZERO
	output_direction = DIRECTIONS.r
	update_direction_display()
	need_input_button_2 = false
	
	machine_type = TYPE.INCREMENTER
	my_sprite.texture = TEXTURES["Incrementer"]

func increment_product():
	product_1.increase_sides()
	push_to_next_machine()

#######################################################################################
#Stacker specific code

func set_machine_type_stacker():
	input_direction_1 = DIRECTIONS.l
	input_direction_2 = DIRECTIONS.u
	output_direction = DIRECTIONS.r
	update_direction_display()
	
	machine_type = TYPE.STACKER
	my_sprite.texture = TEXTURES["Stacker"]
	need_input_button_2 = true

func stack_product():
	if (product_1 and product_2):
		if (product_1.stack(product_2)):
			push_to_next_machine()

#########################################################################################
#Teleporter specific code
var network
var receivers_on_my_network
var senders_on_my_network


func set_machine_type_sender():
	input_direction_1 = DIRECTIONS.l
	input_direction_2 = Vector2.ZERO
	output_direction = Vector2.ZERO
	update_direction_display()
	need_input_button_2 = false
	machine_type = TYPE.SENDER
	my_sprite.texture = TEXTURES["Sender"]
	

func set_machine_type_receiver():
	input_direction_1 = Vector2.ZERO
	input_direction_2 = Vector2.ZERO
	output_direction = DIRECTIONS.r
	update_direction_display()
	need_input_button_2 = false
	machine_type = TYPE.RECEIVER
	my_sprite.texture = TEXTURES["Receiver"]
	

func set_network(inetwork):
	network = inetwork
	
	
func set_receivers_on_my_network(array):
	receivers_on_my_network = array.duplicate()
	for a in receivers_on_my_network:
		if (a.network != network):
			receivers_on_my_network.remove(a)
	

func set_senders_on_my_network(array):
	senders_on_my_network = array.duplicate()
	for a in senders_on_my_network:
		if (a.network != network):
			senders_on_my_network.erase(a)
	
	
func teleport_product():
	var temp_array = []
	for machine in receivers_on_my_network:
		var temp = product_1.duplicate(8)
		temp_array.append(temp)
		machine.product_1 = temp
		product_spawn_point.add_child(temp)
		temp.position = to_local(machine.global_position)
	for a in temp_array:
		a.entangle(temp_array)
	product_1.queue_free()
	
		
func push_received_product():
	push_to_next_machine()
	
###########################################################################################

var highlighted_direction_buttons = []
var need_input_button_2 = false
var arrow_distance_vector = Vector2(80, 0)
var selected_arrow = null
var is_input_arrow_1_selected = false
var is_input_arrow_2_selected = false
var is_output_arrow_selected = false


func update_direction_display():
	$"Input Button 1".position = arrow_distance_vector * input_direction_1
	if (need_input_button_2):
		$"Input Button 2".position = arrow_distance_vector * input_direction_2
		$"Output Button 1".position = arrow_distance_vector * output_direction
	var temp = arrow_distance_vector * output_direction
	

func enable_edit_mode():
	$"Input Button 1/Area2D".monitoring = true
	if (need_input_button_2): 
		$"Input Button 2/Area2D".monitoring = true
		$"Output Button 1/Area2D".monitoring = true
		$"Input Button 1".visible = true
	if (need_input_button_2): 
		$"Input Button 2".visible = true
		$"Output Button 1".visible = true

	
func disable_edit_mode():
	$"Input Button 1/Area2D".monitoring = false
	$"Input Button 2/Area2D".monitoring = false
	$"Output Button 1/Area2D".monitoring = false
	$"Input Button 1".visible = false
	$"Input Button 2".visible = false
	$"Output Button 1".visible = false


func _ready():
	set_machine_type_import()
	disable_edit_mode()
	

func _process(delta):
	if (Input.is_action_just_pressed("left_click")):
		handle_left_click()
	if (selected_arrow != null):
		handle_selected()


func handle_left_click():
	if (selected_arrow):
		if (is_input_arrow_1_selected):
			input_direction_1 = selected_arrow.position/80
		elif (is_input_arrow_2_selected):
			input_direction_2 = selected_arrow.position/80
		elif (is_output_arrow_selected):
			output_direction = selected_arrow.position/80
		selected_arrow = null
		is_input_arrow_1_selected = false
		is_input_arrow_2_selected = false
		is_output_arrow_selected = false
	if (highlighted_direction_buttons.size() >= 1):
		selected_arrow = highlighted_direction_buttons[0]


func handle_selected():
	var mouse_position = get_local_mouse_position()
	mouse_position = mouse_position.normalized() * 80
	mouse_position.x = stepify(mouse_position.x, 80)
	mouse_position.y = stepify(mouse_position.y, 80)
	selected_arrow.position = mouse_position
	if (is_input_arrow_1_selected):
		input_direction_1 = selected_arrow.position/80
	elif (is_input_arrow_2_selected):
		input_direction_2 = selected_arrow.position/80
	elif (is_output_arrow_selected):
		output_direction = selected_arrow.position/80


func _on_input_button_1_mouse_entered():
	highlighted_direction_buttons.append($"Input Button 1")
	is_input_arrow_1_selected = true


func _on_input_button_1_mouse_exited():
	highlighted_direction_buttons.erase($"Input Button 1")
	if (selected_arrow!= $"Input Button 1"): is_input_arrow_1_selected = false


func _on_input_button_2_mouse_entered():
	if (need_input_button_2): 
		highlighted_direction_buttons.append($"Input Button 2")
		is_input_arrow_2_selected = true


func _on_input_button_2_mouse_exited():
	highlighted_direction_buttons.erase($"Input Button 2")
	if (selected_arrow!= $"Input Button 2"): is_input_arrow_2_selected = false


func _on_output_button_1_mouse_entered():
	highlighted_direction_buttons.append($"Output Button 1")
	is_output_arrow_selected = true

func _on_output_button_1_mouse_exited():
	highlighted_direction_buttons.erase($"Output Button 1")
	if (selected_arrow!= $"Output Button 1"): is_output_arrow_selected = false

