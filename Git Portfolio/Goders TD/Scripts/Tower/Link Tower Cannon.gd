extends Node2D

#SNIPER TOWER

#GENERIC TOWER INIT
onready var enemy_nodes = []
onready var target

onready var anime = get_node("Sprite/AnimationPlayer")
var attack_range_shape

var element_type = "Default"
var element_level = 0
var ricochet = 0
var hit_stealth = false
var hit_flyers = false

var base_attack_speed = 1.0
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

var targeting_mode_MASTER = ["First", "Last", "Strong", "Close", "Far", "Weak", "New", "Random"]
export var targeting_mode = "First"

var can_shoot = true
var can_acquire_target = true

func _ready() -> void:
	$"Attack Range Area/CollisionShape2D".set_shape(CircleShape2D.new())
	attack_range_shape = $"Attack Range Area/CollisionShape2D".get_shape()
	attack_range_shape.radius = effective_attack_range
	
	$"Tower Base Area/CollisionShape2D".set_shape(CircleShape2D.new())
	$"Tower Base Area/CollisionShape2D".get_shape().radius = 65
	
	$"Link Tower Area/CollisionShape2D".set_shape(CircleShape2D.new())
	link_tower_shape = $"Link Tower Area/CollisionShape2D".get_shape()
	link_tower_shape.radius = 5
	
	$"Link Tower Area".monitorable = false
	$"Link Tower Area".monitoring = false
	
	
	add_to_group("Link")
	add_to_group("Turret")
	randomize()

var link_tower_shape 
var link_nodes = []
var link_nodes_actually_in_range = []
var is_master = false
var network_target
var network_shooter
var network_can_shoot = true
var has_network = false
var network_hit_flyers = false
var network_hit_stealth = false
var network_has_target = true

func determine_network_shooter():
	#Possible that "collecting all enemies" and acquiring target is faster
	var temp_enemy_nodes = []
	var ally_nodes_with_targets = []
	for a in link_nodes:
		if (!a.enemy_nodes.empty()):
			a.target = a.acquire_target(targeting_mode, a.enemy_nodes)
			temp_enemy_nodes.append(a.target)
			ally_nodes_with_targets.append(a)
	if (temp_enemy_nodes.empty()):
		network_has_target = false
		return
	network_target = acquire_target(targeting_mode, temp_enemy_nodes)
	network_has_target = true
	
	for a in ally_nodes_with_targets:
		if (a.target == network_target):
			return a
	
	
func gather_network_shoot_data():
	var array = []
	var network_damage = 0
	var network_attack_speed = 0
	var network_element_type = "Default"
	var network_element_level = 0
	
	for a in link_nodes:
		network_damage += a.effective_attack_damage
		network_attack_speed += a.effective_attack_speed
		network_element_level += a.effective_element_level
	array.append(network_damage)
	array.append(network_attack_speed)
	array.append(network_element_type)
	array.append(network_element_level)
	return array
	
func calculate_stats():
	effective_attack_speed = base_attack_speed * attack_speed_buffed_multiplier + (special_attack_speed_level * 1.0 * attack_speed_buffed_multiplier)
	effective_attack_damage = base_attack_damage * attack_damage_buffed_multiplier + (special_attack_damage_level * 20 * attack_damage_buffed_multiplier)
	effective_attack_range = base_attack_range * attack_range_buffed_multiplier + (special_attack_range_level * 150 * attack_range_buffed_multiplier)
	attack_range_shape.radius = effective_attack_range
	link_tower_shape.radius = effective_attack_range
	
	for a in link_nodes:
		if (!a.link_nodes.has(self)):
			a.link_nodes.append(self)
	
	effective_element_level = base_element_level
	if (village_elemental_type == element_type):
		effective_element_level += village_elemental_level
		

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
		if (!link_nodes.empty()):
			for a in link_nodes:
				a.element_type = inco
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
	if (!link_nodes.empty()):
		for a in link_nodes:
			a.element_type = inco
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
	
func acquire_target(method, array):
	if (array.empty()):
		return
	elif (method == targeting_mode_MASTER[0]):
		var first = array[0]
		for i in array:
			if (i.offset > first.offset):
				first = i
		return first
	elif (method == targeting_mode_MASTER[1]):
		var last = array[0]
		for i in array:
			if (i.offset < last.offset):
				last = i
		return last
	elif (method == targeting_mode_MASTER[2]):
		var strong = array[0]
		for i in array:
			if (i.health > strong.health):
				strong = i
		return strong
	elif (method == targeting_mode_MASTER[3]):
		var close = array[0]
		var pos2d = Vector2.ZERO
		for i in array:
			if (pos2d.distance_squared_to(to_local(i.position)) < pos2d.distance_squared_to(to_local(close.position))):
				close = i
		return close
	elif (method == targeting_mode_MASTER[4]):
		var far = array[0]
		var pos2d = get_parent().position
		for i in array:
			if (pos2d.distance_squared_to(i.position) > pos2d.distance_squared_to(far.position)):
				far = i
		return far
	elif (method == targeting_mode_MASTER[5]):
		var weak = array[0]
		for i in array:
			if (i.health < weak.health):
				weak = i
		return weak
	elif (method == targeting_mode_MASTER[6]):
		if (element_type == "Default"):
			var strong = array[0]
			for i in array:
				if (i.health > strong.health):
					strong = i
			return strong
		elif (element_type == "Fire"):
			for i in array:
				if (i.has_meta("isBurning")):
					if (!i.isBurning):
						return i
			return array[0]
		elif (element_type == "Water"):
			for i in array:
				if (i.has_meta("isSoaked")):
					if (!i.isSoaked):
						return i
			return array[0]
		elif (element_type == "Lightning"):
			var first = array[0]
			for i in array:
				if (i.offset > first.offset):
					first = i
			return first
		elif (element_type == "Earth"):
			for i in array:
				if (i.has_meta("isBrittle")):
					if(!i.isBrittle):
						return i
			return array[0]
		elif (element_type == "Poison"):
			for i in array:
				if (i.has_meta("isPoisoned")):
					if(!i.isPoisoned):
						return i
			return array[0]
		elif (element_type == "Ice"):
			for i in array:
				if (i.has_meta("isFrozen")):
					if(!i.isFrozen):
						return i
			return array[0]
		elif (element_type == "Acid"):
			for i in array:
				if (i.has_meta("isMelting")):
					if(!i.isMelting):
						return i
			return array[0]
		elif (element_type == "Radiation"):
			for i in array:
				if (i.has_meta("isIrradiated")):
					if(!i.isIrradiated):
						return i
			return array[0]
		elif (element_type == "Wind"):
			var first = array[0]
			for i in array:
				if (i.offset > first.offset):
					first = i
			return first
		else :
			var strong = array[0]
			for i in array:
				if (i.health > strong.health):
					strong = i
			return strong
	elif (method == targeting_mode_MASTER[7]):
		var temp = array.duplicate()
		temp.shuffle()
		return temp[0]
	else:
		print ("Targeting mode not properly set")
		return array[0]
	
var timer = 0

func _draw():
	if (!link_nodes_actually_in_range.empty()):
		for a in link_nodes_actually_in_range:
			draw_line(Vector2.ZERO, to_local(a.global_position), Color(1,1,1,1), .3)
	if (is_selected_tower or is_not_active or is_link_tower_selected):
		draw_circle(Vector2.ZERO, effective_attack_range, Color(0,0,0,.3))
		#draw_circle(Vector2.ZERO, 65,  Color(0,1,1,.3))
		
		
var is_active = false
var location_locked = false
var is_selected_tower = false
var is_not_active = true
var is_link_tower_selected = false
	

func _process(_delta):
	
	if (!location_locked) : position = get_global_mouse_position()
	if (Input.is_action_just_pressed("PlaceTurret") and !is_active) : 
		location_locked = true
		is_active = true
		is_not_active = false
		anime.play("Idle")
		$"Link Tower Area".monitorable = true
		$"Link Tower Area".monitoring = true
	
	update()
	
	if (Input.is_action_just_pressed("print_stats")):
		print("")
		calculate_stats()
		if (is_master): print ("I am the Master")
		print ("Allies in network:")
		for a in link_nodes:
			print (a)
	
	if (isDirty):
		calculate_stats()
		isDirty = false
	
	if (link_nodes.empty()):
		has_network = false
		if (is_active): can_acquire_target = true
	else:
		has_network = true
		if (is_master):
			for a in link_nodes:
				if (a != self):
					a.is_master = false
		else:
			var network_has_master = false
			for a in link_nodes:
				if (a.is_master):
					network_has_master = true
			if (!network_has_master):
				is_master = true
	
	if (is_master):
		for a in link_nodes:
			for b in a.link_nodes:
				if (!link_nodes.has(b)):
					link_nodes.append(b)
		#On every node in the network, which is now a master list:
		for a in link_nodes:
			for b in link_nodes:
				if (!a.link_nodes.has(b)):
					a.link_nodes.append(b)
		
		if (has_network):
			for a in link_nodes:
				a.can_acquire_target = false
		for a in link_nodes:
			if (a.hit_flyers):
				network_hit_flyers = true
			if (a.hit_stealth):
				network_hit_stealth = true
		network_shooter = determine_network_shooter()
		if (network_can_shoot and network_has_target and is_active):
			network_shooter.rotate(network_shooter.get_angle_to(network_target.global_transform.origin))
			network_shooter.shoot(gather_network_shoot_data(), network_target)
		else:
			if (!anime.is_playing()): anime.play("Idle")
	
	
	
	if enemy_nodes.empty(): 
		can_acquire_target = false
	
	if (can_acquire_target):
		target = acquire_target(targeting_mode, enemy_nodes)
		rotate(get_angle_to(target.global_transform.origin))
	
	if (!enemy_nodes.empty() and can_shoot and can_acquire_target) :
		shoot([effective_attack_damage, effective_attack_speed, element_type, effective_element_level], target)
		
func shoot(array, local_target):
	network_can_shoot = false
	for a in link_nodes:
		a.network_can_shoot = false
	can_shoot = false
	
	if (local_target != null and local_target.has_method("update_healthbar")) : 
		local_target.update_healthbar(array[0] * -1)
	if (local_target != null and local_target.has_method("apply_element") and array[3] > 0):
		local_target.apply_element(array[2], array[3], array[0])
	
	anime.play("Shoot", -1, array[1])
	yield (anime, "animation_finished")
	network_can_shoot = true
	for a in link_nodes:
		a.network_can_shoot = true
	can_shoot = true
	
func _on_Attack_Range_Area_area_entered(area):
	if (area.get_parent().has_meta("flying")):
		if (area.get_parent().flying && !hit_flyers): return
	if (area.get_parent().has_meta("stealthed")):
		if (area.get_parent().stealthed && !hit_stealth): return
	if (area.get_groups().has("EnemyHitbox")): 
		enemy_nodes.append(area.get_parent())

func _on_Attack_Range_Area_area_exited(area):
	enemy_nodes.erase(area.get_parent())


func _on_Link_Tower_Area_area_entered(area):
	if (area.get_parent() == self):
		return
	link_nodes.append(area.get_parent())
	link_nodes_actually_in_range.append(area.get_parent())
	isDirty = true


func _on_Link_Tower_Area_area_exited(area):
	link_nodes.erase(area.get_parent())
	link_nodes_actually_in_range.erase(area.get_parent())
