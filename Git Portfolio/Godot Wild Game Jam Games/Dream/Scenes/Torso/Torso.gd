extends Node2D

const INITIAL_SCREEN_WIDTH = 1920
const INITIAL_SCREEN_HEIGHT = 1080
const IMAGE_DIMENSIONS = Vector2(1920, 2000)

const INITIAL_CAMERA_POSITION = Vector2(INITIAL_SCREEN_WIDTH / 2, (INITIAL_SCREEN_HEIGHT)/2)
const LOWER_CAMERA_POSITION = 920

onready var camera = get_node("Camera2D")
onready var tween = Tween.new()
onready var tween2 = Tween.new()

var systems = []
var invisible_systems = []
var ailments = []
var invisible_ailments = []
var current_layer

var brush_texture_1 = preload("res://Assets/Game/Placeholder_brush_1.png")
var brush_texture_2 = preload("res://Assets/Game/Placeholder_brush_2.png")
var brush_texture_3 = preload("res://Assets/Game/Placeholder_brush_3.png")
var brush_texture_4 = preload("res://Assets/Game/Placeholder_brush_4.png")

var brush_1_scene = preload("res://Scenes/Brushes/Brush1.tscn")
var brush_2_scene = preload("res://Scenes/Brushes/Brush2.tscn")
var brush_3_scene = preload("res://Scenes/Brushes/Brush3.tscn")
var brush_4_scene = preload("res://Scenes/Brushes/Brush4.tscn")


onready var brush_sprite = $Brush

func _ready():
	camera.position = INITIAL_CAMERA_POSITION
	add_child(tween)
	add_child(tween2)
	systems = [
		$Nervous, 
		$Cardiovascular, 
		$Respiratory, 
		$Digestive, 
		$Skeletal, 
		$Muscular, 
		$Integumentary]
	ailments = [
		$Nervous/Ailments, 
		$Cardiovascular/Ailments, 
		$Respiratory/Ailments, 
		$Digestive/Ailments, 
		$Skeletal/Ailments, 
		$Muscular/Ailments, 
		$Integumentary/Ailments]
	current_layer = systems[-1]
	setup_brush()
	for i in 7: remove_system_layer()
	for i in 7: add_system_layer()
	
func setup_brush():
	disable_all_brushes()
	set_brush_to_brush(brush_1_scene, brush_texture_1)

var current_brush
var current_texture

func set_brush_to_brush(brush, texture):
	disable_all_brushes()
	var new_brush = brush.instance()
	$Brush.add_child(new_brush)
	brush_sprite.texture = texture
	current_brush = brush
	current_texture = texture

func disable_all_brushes():
	for i in $Brush.get_children():
		i.queue_free()
	
func move_camera_to_position(position: Vector2, boolean, zoom):
	tween.interpolate_property(camera, "position", null, position, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start()
	if (boolean):
		tween2.interpolate_property(camera, "zoom", null, zoom, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		tween2.start()

var is_camera_top = true
var is_camera_zoomed_out = false

func zoom_out_camera():
	move_camera_to_position(Vector2(960, 1000), true, Vector2(2, 2))
	is_camera_zoomed_out = true
func zoom_in_camera():
	if (is_camera_top):
		move_camera_to_position(INITIAL_CAMERA_POSITION, true, Vector2(1, 1))
	else :
		move_camera_to_position(Vector2(960, 1460), true, Vector2(1, 1))
	is_camera_zoomed_out = false

func _input(event):
	if event.is_action_pressed("pan_camera_up"):
		if !is_camera_zoomed_out:
			move_camera_to_position(INITIAL_CAMERA_POSITION, false, null)
			is_camera_top = true
	if event.is_action_pressed("pan_camera_down"):
		if !is_camera_zoomed_out:
			move_camera_to_position(Vector2(INITIAL_CAMERA_POSITION.x, INITIAL_CAMERA_POSITION.y + LOWER_CAMERA_POSITION), false, null)
			is_camera_top = false
	if event.is_action_pressed("zoom_camera_out"):
		zoom_out_camera()
	if event.is_action_pressed("zoom_camera_in"):
		zoom_in_camera()
	if event.is_action_pressed("remove_system_layer"):
		remove_system_layer()
	if event.is_action_pressed("add_system_layer"):
		add_system_layer()
	if event.is_action_pressed("set_brush_1"):
		set_brush_to_brush(brush_1_scene, brush_texture_1)
	if event.is_action_pressed("set_brush_2"):
		set_brush_to_brush(brush_2_scene, brush_texture_2)
	if event.is_action_pressed("set_brush_3"):
		set_brush_to_brush(brush_3_scene, brush_texture_3)
	if event.is_action_pressed("set_brush_4"):
		set_brush_to_brush(brush_4_scene, brush_texture_4)
		
func remove_system_layer():
	if (systems.size() > 1):
			invisible_systems.push_back(systems.pop_back())
			invisible_systems[-1].visible = false
			
			ailments[-1].visible = false
			set_monitoring_on_ailments(false, ailments[-1])
			invisible_ailments.push_back(ailments.pop_back())
			ailments[-1].visible = true
			set_monitoring_on_ailments(true, ailments[-1])
			
			set_brush_to_brush(current_brush, current_texture)
			
			for i in systems:
				i.get_child(0).set_modulate(Color(1, 1, 1, .1))
			for i in invisible_systems:
				i.get_child(0).set_modulate(Color(1, 1, 1, .1))
			
			
			current_layer = systems[-1]
			current_layer.get_child(0).set_modulate(Color(1, 1 ,1, 1))

func add_system_layer():
	if (invisible_systems.size() > 0):
			systems.push_back((invisible_systems.pop_back()))
			systems[-1].visible = true
			
			ailments[-1].visible = false
			set_monitoring_on_ailments(false, ailments[-1])
			ailments.push_back(invisible_ailments.pop_back())
			ailments[-1].visible = true
			set_monitoring_on_ailments(true, ailments[-1])
			
			set_brush_to_brush(current_brush, current_texture)
			
			for i in systems:
				i.get_child(0).set_modulate(Color(1, 1, 1, .1))
			for i in invisible_systems:
				i.get_child(0).set_modulate(Color(1, 1, 1, .1))
			
			current_layer = systems[-1]
			current_layer.get_child(0).set_modulate(Color(1, 1 ,1, 1))

func set_monitoring_on_ailments(monitoring, node):
	for i in node.get_children():
		i.get_child(0).set_monitoring(monitoring)

func _process(_delta):
	$Brush.position = get_global_mouse_position()
	check_for_ailments()

func check_for_ailments():
	if $Nervous/Ailments.get_children().size() > 0: return
	if $Cardiovascular/Ailments.get_children().size() > 0: return
	if $Respiratory/Ailments.get_children().size() > 0: return
	if $Digestive/Ailments.get_children().size() > 0: return
	if $Skeletal/Ailments.get_children().size() > 0: return
	if $Muscular/Ailments.get_children().size() > 0: return
	if $Intgeumentary/Ailments.get_children().size() > 0: return
	print ("You win!")
