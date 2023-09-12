
extends Node2D


#Product
var TEXTURES = {
	"red_circle": load("res://Assets/red_circle.png"),
	"red_triangle": load("res://Assets/red_triangle.png"),
	"red_square": load("res://Assets/red_square.png"),
	"red_pentagon": load("res://Assets/red_pentagon.png"),
	"red_hexagon":  load("res://Assets/red_hexagon.png"),
	
	"yellow_circle": load("res://icon.png"),
	"yellow_triangle": load("res://icon.png"),
	"yellow_square": load("res://icon.png"),
	"yellow_pentagon": load("res://icon.png"),
	"yellow_hexagon": load("res://icon.png"),
	
	"green_circle": load("res://icon.png"),
	"green_triangle": load("res://icon.png"),
	"green_square": load("res://icon.png"),
	"green_pentagon": load("res://icon.png"),
	"green_hexagon": load("res://icon.png"),
	
	"blue_circle": load("res://icon.png"),
	"blue_triangle": load("res://icon.png"),
	"blue_square": load("res://icon.png"),
	"blue_pentagon": load("res://icon.png"),
	"blue_hexagon": load("res://icon.png"),
	
	"purple_circle": load("res://icon.png"),
	"purple_triangle": load("res://icon.png"),
	"purple_square": load("res://icon.png"),
	"purple_pentagon": load("res://icon.png"),
	"purple_hexagon": load("res://icon.png")
	}

var color
var grid_location
var grid_size
var sides
var size
var child
onready var my_sprite = get_node("Sprite")
onready var tween = get_node("Tween")
var entangled_partners

var can_move


func _init(icolor, igrid_location, igrid_size, isides, isize, ichild):
	color = "red"
	grid_location = Vector2(0, 0)
	grid_size = 0
	sides = 2
	size = 0
	child = null
	entangled_partners = []
	can_move = true
	my_sprite = get_node("Sprite")
	tween = get_node("Tween")
	initialize_with_data(icolor, igrid_location, igrid_size, isides, isize, ichild)


func initialize_with_data(icolor, igrid_location, igrid_size, isides, isize, ichild):
	color = icolor
	grid_location = igrid_location
	grid_size = igrid_size
	sides = isides
	size = isize
	child = ichild
	
	update_texture()
	#test code:
	self.position = grid_location
	

func update_texture():
	var temp = ""
	var temp_shape = ""
	match sides:
		2:
			temp_shape = "circle"
		3:
			temp_shape = "triangle"
		4:
			temp_shape = "square"
		5:
			temp_shape = "pentagon"
		6:
			temp_shape = "hexagon"
		_:
			print (sides as String + " was an input that didn't work")
	temp = ("_".join([color, temp_shape]))
	my_sprite.texture = TEXTURES[temp]
	var scalar = (.25 * (size + 1))
	$Sprite.scale = Vector2(scalar, scalar)


func increase_sides(quantum:bool=false):
	if (sides >= 6) : return
	sides += 1
	if (child != null):
		child.increase_sides(true)
	update_texture()
	if (quantum and entangled_partners.size() > 0):
		for a in entangled_partners:
			a.increase_sides()


func increase_size(quantum:bool=false):
	if (size >= 2): return
	size += 1
	#if (incoming and child != null):
	#	if (child.size+1 < size):
	#		child.increase_size(true)
	update_texture()
	if (quantum and entangled_partners.size()):
		for a in entangled_partners:
			a.increase_size()
	

func entangle(array):
	entangled_partners = array.duplicate()
	entangled_partners.erase(self)
	

func set_move_direction(move_direction):
	tween.interpolate_property(self, "position",
		position, position + move_direction*grid_size, .1,
		Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
		

func start_move():
	if (can_move): tween.start()


func stack(ichild):
	if (ichild.size < self.size):
		ichild.get_parent().remove_child(ichild)
		add_child(ichild)
		ichild.position = Vector2.ZERO
		ichild.can_move = false
		child = ichild
		return true
	return false
	

func _ready():
	update_texture()


func _process(delta):
	if (Input.is_action_just_pressed("spacebar")):
		set_move_direction(Vector2.UP)
		start_move()
	if (Input.is_action_just_pressed("increase_size")):
		set_move_direction(Vector2.DOWN)
		start_move()

