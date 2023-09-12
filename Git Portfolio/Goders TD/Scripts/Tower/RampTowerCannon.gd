extends Node2D

#RAMP TOWER

#GENERIC TOWER INIT
onready var enemy_nodes = []
onready var target

onready var anime = get_node("Sprite/AnimationPlayer")
onready var sprite = get_node("Sprite")
var attack_range_shape


export var element_type = "Default"
export var element_level = 0
var ricochet = 0
var hit_stealth = false
var hit_flyers = false

var base_attack_speed = 20
var attack_speed_level = 0
var special_attack_speed_level = 0
var attack_speed_buffed_multiplier = 1.0
var effective_attack_speed = 1.0

var base_attack_damage = 5
var attack_damage_level = 0
var special_attack_damage_level = 0
var attack_damage_buffed_multiplier = 1.0
var effective_attack_damage = 20

var base_attack_range  = 150
var attack_range_level = 0
var special_attack_range_level = 0
var attack_range_buffed_multiplier = 1.0
var effective_attack_range = 300

var isDirty

var targeting_mode_MASTER = ["First", "Last", "Strong", "Close", "Far", "Weak", "New", "Random"]
export var targeting_mode = "First"

var can_acquire_target = true
var can_shoot = true

#RAMP TOWER SPECIFIC
var max_ramp_attack_damage
var base_ramp_attack_damage
var shoot_timer = 0
var shot_count = 0


func _ready() -> void:
	$"Attack Range Area/CollisionShape2D".set_shape(CircleShape2D.new())
	attack_range_shape = $"Attack Range Area/CollisionShape2D".get_shape()
	attack_range_shape.radius = effective_attack_range
	
	$"Tower Base Area/CollisionShape2D".set_shape(CircleShape2D.new())
	$"Tower Base Area/CollisionShape2D".get_shape().radius = 65

	add_to_group("Turret")
	max_ramp_attack_damage = base_attack_damage * 50
	base_ramp_attack_damage = base_attack_damage
	
	isDirty = true
	randomize()

func calculate_stats():
	effective_attack_speed = (base_attack_speed * attack_speed_buffed_multiplier) + (special_attack_speed_level * 20 * attack_speed_buffed_multiplier)
	base_ramp_attack_damage = base_attack_damage * attack_damage_buffed_multiplier + (special_attack_damage_level * 5 * attack_damage_buffed_multiplier)
	max_ramp_attack_damage = base_ramp_attack_damage * 50
	effective_attack_range = base_attack_range * attack_range_buffed_multiplier + (special_attack_range_level * 150 * attack_range_buffed_multiplier)
	attack_range_shape.radius = effective_attack_range
	
	effective_element_level = base_element_level
	if (village_elemental_type == element_type):
		effective_element_level += village_elemental_level
	
	update()
		

func upgrade_attack_speed():
	if (attack_speed_level < 5):
		base_attack_speed += 1.0
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
		base_attack_speed -= 1.0
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
	attack_speed_buffed_multiplier = (.1 * village_attack_speed_level) + 1.0
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
	
	
func _draw():
	if (target != null):
		draw_line(Vector2.ZERO, to_local(target.global_position), Color(1,1,1,1), .3)
	if (is_selected_tower or is_not_active):
		draw_circle(Vector2.ZERO, effective_attack_range, Color(0,0,0,.3))
		

func acquire_target(method):
	if (enemy_nodes.empty()):
		return
	elif (method == targeting_mode_MASTER[0]):
		var first = enemy_nodes[0]
		for i in enemy_nodes:
			if (i.offset > first.offset):
				first = i
		return first
	elif (method == targeting_mode_MASTER[1]):
		var last = enemy_nodes[0]
		for i in enemy_nodes:
			if (i.offset < last.offset):
				last = i
		return last
	elif (method == targeting_mode_MASTER[2]):
		var strong = enemy_nodes[0]
		for i in enemy_nodes:
			if (i.health > strong.health):
				strong = i
		return strong
	elif (method == targeting_mode_MASTER[3]):
		var close = enemy_nodes[0]
		var pos2d = Vector2.ZERO
		for i in enemy_nodes:
			if (pos2d.distance_squared_to(to_local(i.position)) < pos2d.distance_squared_to(to_local(close.position))):
				close = i
		return close
	elif (method == targeting_mode_MASTER[4]):
		var far = enemy_nodes[0]
		var pos2d = get_parent().position
		for i in enemy_nodes:
			if (pos2d.distance_squared_to(i.position) > pos2d.distance_squared_to(far.position)):
				far = i
		return far
	elif (method == targeting_mode_MASTER[5]):
		var weak = enemy_nodes[0]
		for i in enemy_nodes:
			if (i.health < weak.health):
				weak = i
		return weak
	elif (method == targeting_mode_MASTER[6]):
		if (element_type == "Default"):
			var strong = enemy_nodes[0]
			for i in enemy_nodes:
				if (i.health > strong.health):
					strong = i
			return strong
		elif (element_type == "Fire"):
			for i in enemy_nodes:
				if (i.has_meta("isBurning")):
					if (!i.isBurning):
						return i
			return enemy_nodes[0]
		elif (element_type == "Water"):
			for i in enemy_nodes:
				if (i.has_meta("isSoaked")):
					if (!i.isSoaked):
						return i
			return enemy_nodes[0]
		elif (element_type == "Lightning"):
			var first = enemy_nodes[0]
			for i in enemy_nodes:
				if (i.offset > first.offset):
					first = i
			return first
		elif (element_type == "Earth"):
			for i in enemy_nodes:
				if (i.has_meta("isBrittle")):
					if(!i.isBrittle):
						return i
			return enemy_nodes[0]
		elif (element_type == "Poison"):
			for i in enemy_nodes:
				if (i.has_meta("isPoisoned")):
					if(!i.isPoisoned):
						return i
			return enemy_nodes[0]
		elif (element_type == "Ice"):
			for i in enemy_nodes:
				if (i.has_meta("isFrozen")):
					if(!i.isFrozen):
						return i
			return enemy_nodes[0]
		elif (element_type == "Acid"):
			for i in enemy_nodes:
				if (i.has_meta("isMelting")):
					if(!i.isMelting):
						return i
			return enemy_nodes[0]
		elif (element_type == "Radiation"):
			for i in enemy_nodes:
				if (i.has_meta("isIrradiated")):
					if(!i.isIrradiated):
						return i
			return enemy_nodes[0]
		elif (element_type == "Wind"):
			var first = enemy_nodes[0]
			for i in enemy_nodes:
				if (i.offset > first.offset):
					first = i
			return first
		else :
			var strong = enemy_nodes[0]
			for i in enemy_nodes:
				if (i.health > strong.health):
					strong = i
			return strong
	elif (method == targeting_mode_MASTER[7]):
		var temp = enemy_nodes.duplicate()
		temp.shuffle()
		return temp[0]
	else:
		print ("Targeting mode not properly set")
		return enemy_nodes[0]
	
	
var is_active = false
var location_locked = false
var is_selected_tower = false
var is_not_active = true

func _process(_delta):
	
	if (isDirty):
		calculate_stats()
		isDirty = false
	
	if (!location_locked) : position = get_global_mouse_position()
	if (Input.is_action_just_pressed("PlaceTurret") and !is_active) : 
		location_locked = true
		is_active = true
		is_not_active = false
		anime.play("Idle")
	
	if (Input.is_action_just_pressed("print_stats")):
		print("")
		print(self)
		print("Attack Speed: " + effective_attack_speed as String)
		print("Attack Damage: " + effective_attack_damage as String)
		print("Attack Range: " + effective_attack_range as String)
		print("Element Type: " + element_type as String)
		print("Element Level: " + effective_element_level as String)
		
	if (is_active): update()
	
	if (is_active): can_acquire_target = true
	
	
	shoot_timer += 1
	
	if enemy_nodes.empty() : 
		can_acquire_target = false
		target = get_node("Position2D")
		if (!anime.is_playing() and is_active): anime.play("Idle")
	
	if (is_instance_valid(target) and enemy_nodes.has(target)):
		can_acquire_target = false
		sprite.rotate(sprite.get_angle_to(target.global_transform.origin) + deg2rad(90))
	
	if (can_acquire_target):
		effective_attack_damage = base_ramp_attack_damage
		target = acquire_target(targeting_mode)
		sprite.rotate(sprite.get_angle_to(target.global_transform.origin))
		can_shoot = true
	
	
	for i in range(10):
		shoot_timer += 1
		if (!enemy_nodes.empty() and can_shoot and shoot_timer%max(int(10000/effective_attack_speed), 10) == 0):
			shoot()
			shot_count += 1
			if (shot_count%2 == 0):
				if (effective_attack_damage < max_ramp_attack_damage):
					effective_attack_damage += base_attack_damage
					if (effective_attack_damage > max_ramp_attack_damage):
						effective_attack_damage = max_ramp_attack_damage
		


func shoot():
	if (target != null and target.has_method("update_healthbar")) : target.update_healthbar(effective_attack_damage * -1)
	if (target != null and target.has_method("apply_element") and effective_element_level > 0): target.apply_element(element_type, effective_element_level, effective_attack_damage)
	
func _on_Attack_Range_Area_area_entered(area):
	if (area.get_parent().has_meta("flying")):
		if (area.get_parent().flying && !hit_flyers): return
	if (area.get_parent().has_meta("stealthed")):
		if (area.get_parent().stealthed && !hit_stealth): return
	if (area.get_groups().has("EnemyHitbox")): enemy_nodes.append(area.get_parent())

func _on_Attack_Range_Area_area_exited(area):
	enemy_nodes.erase(area.get_parent())
