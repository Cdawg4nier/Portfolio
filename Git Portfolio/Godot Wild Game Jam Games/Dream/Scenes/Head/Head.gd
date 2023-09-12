extends Node2D

const INITIAL_SCREEN_WIDTH = 1920
const INITIAL_SCREEN_HEIGHT = 1080
const IMAGE_DIMENSIONS = Vector2(1920, 2000)

const INITIAL_CAMERA_POSITION = Vector2(INITIAL_SCREEN_WIDTH / 2, (INITIAL_SCREEN_HEIGHT)/2)
const LOWER_CAMERA_POSITION = 920

onready var camera = get_node("Camera2D")
onready var tween = Tween.new()

var cell = preload("res://Scenes/Cell.tscn")

var systems = []
var invisible_systems = []
var ailments = []
var invisible_ailments = []
var current_layer
var grid = []

var simplex_noise
var brush_timer

func _ready():
	simplex_noise = OpenSimplexNoise.new()
	simplex_noise.seed = 70
	camera.position = INITIAL_CAMERA_POSITION
	add_child(tween)
	systems = [$Nervous, $Skeletal, $Cardiovascular, $Muscular, $Integumentary]
	ailments = [$Nervous/Cells, $Skeletal/Cells, $Cardiovascular/Cells, $Muscular/Cells, $Integumentary/Cells]
	current_layer = systems[-1]
	disable_brush_monitorable()
	setup_ailments()
	
	
func disable_brush_monitorable():
	$Brush/Area2D.monitorable = false
	brush_timer = Timer.new()
	self.add_child(brush_timer)
	brush_timer.start(.5)
	brush_timer.connect("timeout", self, "enable_brush_monitorable")

func enable_brush_monitorable():
	$Brush/Area2D.monitorable = true
	brush_timer.queue_free()

func setup_ailments():
	#scan_for_ailments($Nervous/Cells, 626)
	#scan_for_ailments($Skeletal/Cells, 90)
	#scan_for_ailments($Cardiovascular/Cells, 71)
	#scan_for_ailments($Muscular/Cells, 48)
	scan_for_ailments($Integumentary/Cells, "user://Integumentary.dat")
	$Nervous/Cells.visible = false
	$Skeletal/Cells.visible = false
	$Muscular/Cells.visible = false
	$Cardiovascular/Cells.visible = false
	set_monitorable_on_cells(false, $Nervous/Cells)
	set_monitorable_on_cells(false, $Skeletal/Cells)
	set_monitorable_on_cells(false, $Muscular/Cells)
	set_monitorable_on_cells(false, $Cardiovascular/Cells)
	
func set_monitorable_on_cells(monitorable, node):
	for i in node.get_children():
		i.get_child(0).set_monitorable(monitorable)
	
var placement_position = Vector2(0, 0)
const CULLING_BIAS = 65.0

#func scan_for_ailments(node, iseed):
#	var culling_number = (CULLING_BIAS/50) - 1
#	simplex_noise.seed = iseed
#	for a in 192:
#		for b in 200:
#			var a10 = a*10
#			var b10 = b*10
#			var value = simplex_noise.get_noise_2d(a10, b10)
#			if value < culling_number : continue
#			var temp = cell.instance()
#			node.add_child(temp)
#			temp.position += Vector2(a10, b10)

func scan_for_ailments(node, path):
	var array = convert_file_to_array(path)
	for i in array:
		var new_cell = cell.instance()
		node.add_child(new_cell)
		new_cell.position += i

var brush_1 = preload("res://Assets/Game/Placeholder_brush_1.png")
var brush_2 = preload("res://Assets/Game/Placeholder_brush_2.png")
var brush_3 = preload("res://Assets/Game/Placeholder_brush_3.png")
var brush_4 = preload("res://Assets/Game/Placeholder_brush_4.png")
onready var brush_sprite = $Brush/Sprite

func move_camera_to_position(position: Vector2):
	tween.interpolate_property(camera, "position", null, position, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start()
	 
func _input(event):
	if event.is_action_pressed("pan_camera_up"):
		move_camera_to_position(INITIAL_CAMERA_POSITION)
	if event.is_action_pressed("pan_camera_down"):
		move_camera_to_position(Vector2(INITIAL_CAMERA_POSITION.x, INITIAL_CAMERA_POSITION.y + LOWER_CAMERA_POSITION))
	if event.is_action_pressed("remove_system_layer"):
		remove_system_layer()
		covered_cells.clear()
	if event.is_action_pressed("add_system_layer"):
		add_system_layer()
		covered_cells.clear()
	if event.is_action_pressed("set_brush_1"):
		brush_sprite.texture = brush_1
		for i in $Integumentary/Cells2.get_children():
			i.queue_free()
		scan_for_ailments($Integumentary/Cells, "user://Integumentary.dat")
	if event.is_action_pressed("set_brush_2"):
		brush_sprite.texture = brush_2
		for i in $Integumentary/Cells.get_children():
			i.queue_free()
		scan_for_ailments($Integumentary/Cells2, "user://Muscular.dat")
	if event.is_action_pressed("set_brush_3"):
		brush_sprite.texture = brush_3
	if event.is_action_pressed("set_brush_4"):
		brush_sprite.texture = brush_4
	
func remove_system_layer():
	if (systems.size() > 1):
			invisible_systems.push_back(systems.pop_back())
			invisible_systems[-1].visible = false
			
			ailments[-1].visible = false
			set_monitorable_on_cells(false, ailments[-1])
			invisible_ailments.push_back(ailments.pop_back())
			ailments[-1].visible = true
			set_monitorable_on_cells(true, ailments[-1])
			
			current_layer = systems[-1]

func add_system_layer():
	if (invisible_systems.size() > 0):
			systems.push_back((invisible_systems.pop_back()))
			systems[-1].visible = true
			
			ailments[-1].visible = false
			set_monitorable_on_cells(false, ailments[-1])
			ailments.push_back(invisible_ailments.pop_back())
			ailments[-1].visible = true
			set_monitorable_on_cells(true, ailments[-1])
			
			current_layer = systems[-1]

func _process(_delta):
	$Brush.position = get_global_mouse_position()
	
	if Input.is_action_pressed("left_click"):
		for i in covered_cells:
			i.queue_free()

var can_print = false

func _on_ScannerHead_area_entered(_area):
	can_print = true

func _on_ScannerHead_area_exited(_area):
	can_print = false

var covered_cells = []

func _on_Area2D_area_entered(area):
	if (!covered_cells.has(area.get_parent())):
		covered_cells.append(area.get_parent())


func _on_Area2D_area_exited(area):
	if covered_cells.has(area.get_parent()): covered_cells.erase(area.get_parent())

func convert_file_to_array(path):
	var temp_file = File.new()
	var file_path = path
	var array = []
	if (temp_file.open(file_path, File.READ)) != OK:
		print ("Error opening file")
	
	while !temp_file.eof_reached():
		var line = temp_file.get_line()
		if line != "":
			var values = line.split(", ")
			var x = values[0].substr(1).to_int()
			var y = values[1].substr(0, values[1].length()-1).to_int()
			var vector = Vector2(x, y)
			array.append(vector)
	temp_file.close()
	return array
