extends Node2D


var selected_tower

var basic_tower = preload("res://Scenes/Towers/SniperTower.tscn")
var ramp_tower = preload("res://Scenes/Towers/RampTower.tscn")
var link_tower = preload("res://Scenes/Towers/Link Tower.tscn") 

var missile_tower = preload("res://Scenes/Towers/MissileTower.tscn")
var trap_tower = preload("res://Scenes/Towers/TrapTower.tscn")
var laser_tower = preload("res://Scenes/Towers/LaserTower.tscn")

var buff_tower = preload("res://Scenes/Towers/VillageTower.tscn")
var player_tower = preload("res://Scenes/Towers/PlayerTower.tscn")
var shotgun_tower = preload("res://Scenes/Towers/ShotgunTower.tscn")

var cursor_shape
var hovered_tower

func _ready():
	
	$"Cursor Selector/CollisionShape2D".set_shape(CircleShape2D.new())
	$"Cursor Selector/CollisionShape2D".get_shape().radius = 5

var can_create_player_tower = true
onready var cursor_selector_area = $"Cursor Selector"

func _process(delta):
	cursor_selector_area.position = get_global_mouse_position()
	
	if (Input.is_action_just_pressed("create_basic_tower") and selected_tower == null):
		var x = basic_tower.instance()
		add_child(x)
		selected_tower = x
	if (Input.is_action_just_pressed("create_ramp_tower") and selected_tower == null):
		var x = ramp_tower.instance()
		add_child(x)
		selected_tower = x
	if (Input.is_action_just_pressed("create_link_tower") and selected_tower == null):
		var x = link_tower.instance()
		add_child(x)
		selected_tower = x
		for a in get_children():
			if a.get_groups().has("Link"):
				if (selected_tower.get_groups().has("Link")):
					a.is_link_tower_selected = true
	if (Input.is_action_just_pressed("create_missile_tower") and selected_tower == null):
		var x = missile_tower.instance()
		add_child(x)
		selected_tower = x
	if (Input.is_action_just_pressed("create_trap_tower") and selected_tower == null):
		var x = trap_tower.instance()
		add_child(x)
		selected_tower = x
	if (Input.is_action_just_pressed("create_laser_tower") and selected_tower == null):
		var x = laser_tower.instance()
		add_child(x)
		selected_tower = x
	if (Input.is_action_just_pressed("create_buff_tower") and selected_tower == null):
		var x = buff_tower.instance()
		add_child(x)
		selected_tower = x
	if (Input.is_action_just_pressed("create_player_tower") and can_create_player_tower and selected_tower == null):
		var x = player_tower.instance()
		add_child(x)
		selected_tower = x
		can_create_player_tower = false
	if (Input.is_action_just_pressed("create_shotgun_tower") and selected_tower == null):
		var x = shotgun_tower.instance()
		add_child(x)
		selected_tower = x
		
	if (Input.is_action_just_pressed("upgrade_1") and selected_tower != null):
		selected_tower.upgrade_attack_speed()
	if (Input.is_action_just_pressed("upgrade_2") and selected_tower != null):
		selected_tower.upgrade_attack_damage()
	if (Input.is_action_just_pressed("upgrade_3") and selected_tower != null):
		selected_tower.upgrade_attack_range()
	if (Input.is_action_just_pressed("upgrade_fire") and selected_tower != null):
		selected_tower.upgrade_element("Fire")
	if (Input.is_action_just_pressed("upgrade_water") and selected_tower != null):
		selected_tower.upgrade_element("Water")
	if (Input.is_action_just_pressed("upgrade_ice") and selected_tower != null):
		selected_tower.upgrade_element("Ice")
	if (Input.is_action_just_pressed("upgrade_earth") and selected_tower != null):
		selected_tower.upgrade_element("Earth")
	if (Input.is_action_just_pressed("upgrade_electricity") and selected_tower != null):
		selected_tower.upgrade_element("Electric")
	if (Input.is_action_just_pressed("upgrade_radiation") and selected_tower != null):
		selected_tower.upgrade_element("Radiation")
	if (Input.is_action_just_pressed("upgrade_poison") and selected_tower != null):
		selected_tower.upgrade_element("Poison")
	if (Input.is_action_just_pressed("upgrade_wind") and selected_tower != null):
		selected_tower.upgrade_element("Wind")
	if (Input.is_action_just_pressed("upgrade_light") and selected_tower != null):
		selected_tower.upgrade_element("Light")
	if (Input.is_action_just_pressed("upgrade_dark") and selected_tower != null):
		selected_tower.upgrade_element("Dark")
	if (Input.is_action_just_pressed("upgrade_acid") and selected_tower != null):
		selected_tower.upgrade_element("Acid")
	if (Input.is_action_just_pressed("downgrade_element") and selected_tower != null):
		selected_tower.downgrade_element()
		
	if (Input.is_action_just_pressed("PlaceTurret")):
		if (selected_tower != null): selected_tower.is_selected_tower = false
		selected_tower = hovered_tower
		for a in get_children():
			if a.get_groups().has("Link"):
				if (selected_tower != null):
					if (selected_tower.get_groups().has("Link")):
						a.is_link_tower_selected = true
				else:
					a.is_link_tower_selected = false
		if (selected_tower != null): selected_tower.is_selected_tower = true
		
	
	if (Input.is_action_just_pressed("print_stats")):
		print (selected_tower)
		
	if (Input.is_action_just_pressed("erase_tower") and selected_tower != null):
		selected_tower.queue_free()
		selected_tower = null


func _on_Cursor_Selector_area_entered(area):
	hovered_tower = area.get_parent()


func _on_Cursor_Selector_area_exited(area):
	hovered_tower = null
