extends Node2D


#TRAP TOWER

#GENERIC TOWER INIT

onready var anime = get_node("Sprite/AnimationPlayer")
#onready var attack_range_shape = get_node("Attack Range Area/CollisionShape2D").get_shape()


var element_type = "Default"
var element_level = 0
var ricochet = 0
var hit_stealth = false
var hit_flyers = false

var base_attack_speed = 4.0
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
var effective_attack_range = 300

var isDirty = true

#TRAP TOWER SPECIFIC INIT
var shot = preload("res://Scenes/Towers/Projectiles/TrapProjectile.tscn")
onready var areaTrap = get_node("Area Trap")


func _ready() -> void:
	$"Tower Base Area/CollisionShape2D".set_shape(CircleShape2D.new())
	$"Tower Base Area/CollisionShape2D".get_shape().radius = 65
	
	add_to_group("Turret")
	
	randomize()
	
func update_traps():
	for a in areaTrap.get_children():
		a.update_data(effective_attack_damage, element_type, effective_element_level, effective_attack_range, effective_attack_speed, hit_stealth, hit_flyers)
		

func calculate_stats():
	effective_attack_speed = (base_attack_speed * attack_speed_buffed_multiplier) - (.1 * special_attack_speed_level)
	effective_attack_damage = base_attack_damage * attack_damage_buffed_multiplier + (special_attack_damage_level * 20 * attack_damage_buffed_multiplier)
	effective_attack_range = base_attack_range * attack_range_buffed_multiplier + (special_attack_range_level * 150 * attack_range_buffed_multiplier)
	
	effective_element_level = base_element_level
	if (village_elemental_type == element_type):
		effective_element_level += village_elemental_level
	effective_attack_speed = max(effective_attack_speed, .1)
	update_traps()

func upgrade_attack_speed():
	if (attack_speed_level < 5):
		base_attack_speed -= .3
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
		base_attack_speed += .3
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
		
	attack_speed_buffed_multiplier = 1.0 - (.05 * village_attack_speed_level)
	attack_damage_buffed_multiplier = (.1 * village_attack_damage_level) + 1.0
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
var location_locked = false
var is_selected_tower = false
var is_not_active = true

func _process(_delta):
	
	if (is_selected_tower or is_not_active):
		for a in areaTrap.get_children():
			a.can_draw = true
	else:
		for a in areaTrap.get_children():
			a.can_draw = false
	
	if (!location_locked) : position = get_global_mouse_position()
	if (Input.is_action_just_pressed("PlaceTurret") and !is_active) : 
		location_locked = true
		is_active = true
		is_not_active = false
		anime.play("Idle")
		
	if (is_active and areaTrap.get_children().empty()) :
		var x = shot.instance()
		areaTrap.add_child(x)
	
	if (isDirty):
		calculate_stats()
		isDirty = false
		
	if (is_active):
		if (Input.is_action_just_pressed("print_stats")):
			print("")
			print(self)
			print("Attack Speed: " + effective_attack_speed as String)
			print("Attack Damage: " + effective_attack_damage as String)
			print("Attack Range: " + effective_attack_range as String)
			print("Element Type: " + element_type as String)
			print("Element Level: " + effective_element_level as String)
		

