extends Node2D

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

#SHOTGUN TOWER SPECIFIC INIT
var target_position
var heat_seeking = false
var shot = preload("res://Scenes/Towers/Projectiles/BasicProjectile.tscn")
onready var Projectiles = get_node("Projectiles")
var projectile_speed = 1.0
var waves
onready var muzzle = get_node("Position2D")
var projectileArc
var arcAmount = 8

func _ready() -> void:
	$"Attack Range Area/CollisionShape2D".set_shape(CircleShape2D.new())
	attack_range_shape = $"Attack Range Area/CollisionShape2D".get_shape()
	attack_range_shape.radius = effective_attack_range
	
	$"Tower Base Area/CollisionShape2D".set_shape(CircleShape2D.new())
	$"Tower Base Area/CollisionShape2D".get_shape().radius = 65
	
	add_to_group("Turret")
	randomize()

func calculate_stats():
	effective_attack_speed = base_attack_speed * attack_speed_buffed_multiplier + (special_attack_speed_level * 1.0 * attack_speed_buffed_multiplier)
	effective_attack_damage = base_attack_damage * attack_damage_buffed_multiplier + (special_attack_damage_level * 20 * attack_damage_buffed_multiplier)
	effective_attack_range = base_attack_range * attack_range_buffed_multiplier + (special_attack_range_level * 150 * attack_range_buffed_multiplier)
	attack_range_shape.radius = effective_attack_range
	
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

func _draw():
	if (is_selected_tower or is_not_active):
		draw_circle(Vector2.ZERO, effective_attack_range, Color(0,0,0,.3))

func _process(_delta):
	
	update()
	
	if (!location_locked) : position = get_global_mouse_position()
	if (Input.is_action_just_pressed("PlaceTurret") and !is_active) : 
		location_locked = true
		is_active = true
		is_not_active = false
		anime.play("Idle")
	
	if (is_active):
		if (Input.is_action_just_pressed("print_stats")):
			print("")
			print(self)
			print("Attack Speed: " + effective_attack_speed as String)
			print("Attack Damage: " + effective_attack_damage as String)
			print("Attack Range: " + effective_attack_range as String)
			print("Element Type: " + element_type as String)
			print("Element Level: " + effective_element_level as String)
	
	if (is_active): can_acquire_target = true
	
	if (isDirty):
		calculate_stats()
		isDirty = false
		
	if enemy_nodes.empty() : 
		can_acquire_target = false
		if (!anime.is_playing()): anime.play("Idle")
	
	if (can_acquire_target):
		target = acquire_target(targeting_mode)
		rotate(get_angle_to(target.global_transform.origin))
	
	if (!enemy_nodes.empty() and can_shoot and can_acquire_target) :
		 shoot()
		
	

func shoot():
	can_shoot = false
	
	muzzle = get_node("Position2D").global_position
	projectileArc = (rotation - deg2rad(arcAmount))
	for _n in range(11) :
		var x = shot.instance()
		Projectiles.add_child(x)
		x.set_target(target, muzzle, projectileArc, projectile_speed, effective_attack_damage, heat_seeking, element_type, effective_element_level, hit_flyers, hit_stealth)
		projectileArc += deg2rad(arcAmount / 4)
	
	anime.play("Shoot", -1, effective_attack_speed)
	yield (anime, "animation_finished")
	can_shoot = true


func _on_Attack_Range_Area_area_entered(area):
	if (area.get_parent().has_meta("flying")):
		if (area.get_parent().flying && !hit_flyers): return
	if (area.get_parent().has_meta("stealthed")):
		if (area.get_parent().stealthed && !hit_stealth): return
	if (area.get_groups().has("EnemyHitbox")): enemy_nodes.append(area.get_parent())


func _on_Attack_Range_Area_area_exited(area):
	enemy_nodes.erase(area.get_parent())
