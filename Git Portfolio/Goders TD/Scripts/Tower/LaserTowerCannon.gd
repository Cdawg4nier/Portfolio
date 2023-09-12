extends Node2D

#LASER TOWER

#GENERIC TOWER INIT
onready var enemy_nodes = []

onready var anime = get_node("Sprite/AnimationPlayer")
var laser_shape
onready var laser_node = get_node("Spin/Laser")
onready var spin = get_node("Spin")
onready var sprite = get_node("Sprite")


var element_type = "Default"
var element_level = 0
var ricochet = 0
var hit_stealth = false
var hit_flyers = false

var base_attack_speed = 3.0
var attack_speed_level = 0
var special_attack_speed_level = 0
var attack_speed_buffed_multiplier = 1.0
var effective_attack_speed = 1.0

var base_attack_damage = 20
var attack_damage_level = 0
var special_attack_damage_level = 0
var attack_damage_buffed_multiplier = 1.0
var effective_attack_damage = 20

var base_attack_range  = 150
var attack_range_level = 0
var special_attack_range_level = 0
var attack_range_buffed_multiplier = 1.0
var effective_attack_range = 150

var isDirty = true

var targeting_mode_MASTER = ["First", "Last", "Strong", "Close", "Far", "Weak", "New", "Random"]
export var targeting_mode = "First"

#LASER TOWER SPECIFIC INIT
var location_locked = false
onready var target = get_node("Target")
onready var timer = get_node("Timer")

func _ready() -> void:
	add_to_group("Turret")
	randomize()
	
	$"Spin/Laser/Attack Range Area/CollisionShape2D".set_shape(CapsuleShape2D.new())
	laser_shape = $"Spin/Laser/Attack Range Area/CollisionShape2D".get_shape()
	
	laser_shape.height = effective_attack_range
	laser_node.position.x = 65
	laser_shape.radius = 15
	
	$"Tower Base Area/CollisionShape2D".set_shape(CircleShape2D.new())
	$"Tower Base Area/CollisionShape2D".get_shape().radius = 65
	
	timer.one_shot = true
	
func calculate_stats():
	effective_attack_speed = (base_attack_speed * attack_speed_buffed_multiplier) - (.1 * special_attack_speed_level)
	effective_attack_damage = base_attack_damage * attack_damage_buffed_multiplier + (special_attack_damage_level * 20 * attack_damage_buffed_multiplier)
	effective_attack_range = base_attack_range * attack_range_buffed_multiplier + (special_attack_range_level * 150 * attack_range_buffed_multiplier)
	laser_shape.height = effective_attack_range
	laser_shape.radius = (effective_attack_range * .04) + 10
	laser_node.position.x = effective_attack_range * .55
	
	effective_attack_speed = max(effective_attack_speed, .1)
	
	effective_element_level = base_element_level
	if (village_elemental_type == element_type):
		effective_element_level += village_elemental_level
		

func upgrade_attack_speed():
	if (attack_speed_level < 5):
		base_attack_speed -= .2
		attack_speed_level += 1
		isDirty = true
func upgrade_attack_damage():
	if (attack_damage_level < 5):
		base_attack_damage += 20
		attack_damage_level += 1 
		isDirty = true
func upgrade_attack_range():
	if (attack_range_level < 5):
		base_attack_range += 150
		attack_range_level += 1
		isDirty = true
func upgrade_element(inco):
	if (base_element_level < 5):
		element_type = inco
		base_element_level += 1
		isDirty = true
func upgrade_special_effects():
	ricochet += 1
func upgrade_hit_stealth():
	hit_stealth = true
func upgrade_hit_flyers():
	hit_flyers = true

func downgrade_attack_speed():
	if (attack_speed_level >= 1):
		base_attack_speed += .2
		attack_speed_level -= 1
		isDirty = true
func downgrade_attack_damage():
	if (attack_damage_level >= 1):
		base_attack_damage -= 20
		attack_damage_level -= 1 
		isDirty = true
func downgrade_attack_range():
	if (attack_range_level >= 1):
		base_attack_range -= 150
		attack_range_level -= 1
		isDirty = true
func downgrade_element():
	if (base_element_level >= 1):
		base_element_level -= 1
	if (base_element_level == 0):
		element_type = "Default"
func change_element_type(inco):
	element_type = inco
func downgrade_special_effects():
	if (ricochet >= 1):
		ricochet -= 1
func downgrade_hit_flyers():
	hit_stealth = false
func downgrade_hit_stealth():
	hit_flyers = false

var village_towers = []
var village_attack_range_level = 0
var village_attack_range_super_buff = false
var village_attack_damage_level = 0
var village_attack_damage_super_buff = false
var village_attack_speed_level = 0
var village_attack_speed_super_buff = false
var village_elemental_level = 0
var village_elemental_super_buff = false
var village_elemental_type = "Default"
var effective_element_level = 0
var base_element_level = 0

func add_me_to_tower(node):
	village_towers.append(node)
	
func remove_me_from_tower (node):
	village_towers.erase(node)
	
func calculate_buffed_multipliers():
	village_attack_range_level = 0
	village_attack_damage_level = 0
	village_attack_speed_level = 0
	
	village_elemental_level = 0
	village_elemental_type = "Default"
	
	village_attack_damage_super_buff = false
	village_attack_speed_super_buff = false
	village_attack_range_super_buff = false
	
	village_elemental_super_buff = false
	
	for a in village_towers:
		village_attack_range_level += a.attack_range_level
		if (a.attack_range_level >= 5): village_attack_range_super_buff = true
		
		village_attack_damage_level += a.attack_damage_level
		if (a.attack_damage_level >= 5): village_attack_damage_super_buff = true
		
		village_attack_speed_level += a.attack_speed_level
		if (a.attack_speed_level >= 5): village_attack_speed_super_buff = true
		
		#This is just to set the village elemental type
		if (a.element_level > village_elemental_level):
			if (a.element_type != village_elemental_type):
				village_elemental_type = a.element_type
				village_elemental_level = a.element_level
		if (a.element_level >= 5): village_elemental_super_buff = true
	
	
	if (village_attack_damage_super_buff):
		special_attack_damage_level = 2
	else:
		special_attack_damage_level = 0
		
	if (village_attack_speed_super_buff):
		special_attack_speed_level = 2
	else:
		special_attack_speed_level = 0
		
	if (village_attack_range_super_buff):
		special_attack_range_level = 2
	else:
		special_attack_range_level = 0
		
	attack_damage_buffed_multiplier = (.1 * village_attack_damage_level) + 1.0
	attack_speed_buffed_multiplier = 1.0 - (.05 * village_attack_speed_level)
	attack_range_buffed_multiplier = (.1 * village_attack_range_level) + 1.0
	
	village_elemental_level = 0
	for a in village_towers :
		if (a.element_type == village_elemental_type):
			village_elemental_level += a.element_level
	if (element_type == "Default" and village_elemental_type != "Default"):
		element_type = village_elemental_type
	if (village_elemental_super_buff):
		village_elemental_level += 2
	isDirty = true
	
	
var is_active = false
var base_location_locked = false
var is_selected_tower = false
var is_not_active = true

func _draw():
	if (is_selected_tower or is_not_active):
		draw_circle(Vector2.ZERO, effective_attack_range, Color(0,0,0,.3))

func _process(delta):
	
	update()
	if (!location_locked and is_active) : target.position = to_local(get_global_mouse_position()).clamped(laser_shape.height*1.1)
	if (Input.is_action_just_pressed("PlaceTurret") and is_active) : location_locked = true
	if (Input.is_action_just_pressed("UpliftTurret") and is_active) : location_locked = false
	
	if (!base_location_locked) : position = Vector2(get_global_mouse_position().x + .1, get_global_mouse_position().y)
	if (Input.is_action_just_pressed("PlaceTurret") and !is_active) : 
		base_location_locked = true
		is_active = true
		is_not_active = false
		anime.play("Idle")
		
	
	
	
	if (isDirty):
		calculate_stats()
		isDirty = false
	
	if (timer.is_stopped() and is_active): 
		timer.start(effective_attack_speed)
	if (is_active): sprite.rotate(sprite.get_angle_to(target.global_transform.origin) + deg2rad(90))
	if (is_active): spin.rotate(spin.get_angle_to(target.global_transform.origin))

func _on_Timer_timeout() -> void:
	for a in enemy_nodes :
			if (a.has_method("update_healthbar")) : a.update_healthbar(effective_attack_damage * -1)
			if (effective_element_level >0): a.apply_element(element_type, effective_element_level, effective_attack_damage)


func _on_Attack_Range_Area_area_entered(area):
	if (area.get_parent().has_meta("flying")):
		if (area.get_parent().flying && !hit_flyers): return
	if (area.get_parent().has_meta("stealthed")):
		if (area.get_parent().stealthed && !hit_stealth): return
	if (area.get_groups().has("EnemyHitbox")): enemy_nodes.append(area.get_parent())


func _on_Attack_Range_Area_area_exited(area):
	enemy_nodes.erase(area.get_parent())
	
	
