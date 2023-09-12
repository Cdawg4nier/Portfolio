extends Node2D

#SNIPER TOWER

#GENERIC TOWER INIT
onready var anime = get_node("Drone/Sprite/AnimationPlayer")


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

onready var projectiles = get_node("Drone/Projectiles")

var heat_seeking = false
var missile_shot = preload("res://Scenes/Towers/Projectiles/MissileProjectile.tscn")
onready var missile_muzzle_1 = get_node("Drone/Muzzles/Missile Muzzle 1")
onready var missile_muzzle_2 = get_node("Drone/Muzzles/Missile Muzzle 2")

var projectile_speed = 1.0
var gun_shot = preload("res://Scenes/Towers/Projectiles/BasicProjectile.tscn")
onready var gun_muzzle = get_node("Drone/Muzzles/Gun Muzzle")

func _ready() -> void:
	anime.play("Idle")
	drone.visible = false
	
	$"Turret Base Area/CollisionShape2D".set_shape(CircleShape2D.new())
	$"Turret Base Area/CollisionShape2D".get_shape().radius = 65
	
	add_to_group("Turret")
	randomize()
	projectiles.position = Vector2.ZERO

func calculate_stats():
	effective_attack_speed = base_attack_speed * attack_speed_buffed_multiplier + (special_attack_speed_level * 1.0 * attack_speed_buffed_multiplier)
	effective_attack_damage = base_attack_damage * attack_damage_buffed_multiplier + (special_attack_damage_level * 20 * attack_damage_buffed_multiplier)
	effective_attack_range = base_attack_range * attack_range_buffed_multiplier + (special_attack_range_level * 150 * attack_range_buffed_multiplier)
	
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
	
	
var x_velocity = 0
var y_velocity = 0
onready var drone = get_node("Drone")

var is_active = false
var location_locked = false
var is_selected_tower = false
var is_not_active = true

func _draw():
	if (is_selected_tower or is_not_active):
		draw_circle(Vector2.ZERO, effective_attack_range, Color(0,0,0,.3))

func _process(delta):
	
	update()
	if (!location_locked) : position = get_global_mouse_position()
	if (Input.is_action_just_pressed("PlaceTurret") and !is_active) : 
		location_locked = true
		is_active = true
		is_not_active = false
		anime.play("Idle")
		drone.visible = true
	
	if (Input.is_action_pressed("move_down") and is_active):
		y_velocity += 4
		if (y_velocity < 0):
			y_velocity += 4
	elif (Input.is_action_pressed("move_up") and is_active):
		y_velocity -= 4
		if (y_velocity > 0):
			y_velocity -= 4
	else:
		y_velocity *= .98
		if (abs(y_velocity) < .1):
			y_velocity = 0
		
	if (Input.is_action_pressed("move_right") and is_active):
		x_velocity += 4
		if (x_velocity < 0):
			x_velocity += 4
	elif (Input.is_action_pressed("move_left")and is_active):
		x_velocity -= 4
		if (x_velocity > 0):
			x_velocity -= 4
	else:
		x_velocity *= .98
		if (abs(x_velocity) < .1):
			x_velocity = 0
	
	if (is_active): drone.position.x += x_velocity * delta
	
	if (to_global(drone.position).x > 1920): 
		drone.position = to_local(Vector2(1920, to_global(drone.position).y))
		x_velocity = 0
	if (to_global(drone.position).x < 0): 
		drone.position = to_local(Vector2(0, to_global(drone.position).y))
		x_velocity = 0
	drone.position.y+= y_velocity * delta
	if (to_global(drone.position).y > 1080): 
		
		drone.position = to_local(Vector2(to_global(drone.position).x, 1080))
		y_velocity = 0
	if (to_global(drone.position).y < 0): 
		drone.position = to_local(Vector2(to_global(drone.position).x, 0))
		y_velocity = 0
	
	#x_velocity = floor(x_velocity*.9)
	#y_velocity = floor(y_velocity*.9)
	
	
	
	if (isDirty):
		calculate_stats()
		isDirty = false
	
	get_node("Drone/Sprite").rotate(get_node("Drone/Sprite").get_angle_to(target.global_transform.origin))
	get_node("Drone/Muzzles").rotate(get_node("Drone/Muzzles").get_angle_to(target.global_transform.origin) + deg2rad(90))
	
	target.position = to_local(Vector2(get_global_mouse_position().x + .1, get_global_mouse_position().y))
	
	if (Input.is_action_pressed("PlaceTurret") and is_active): shoot()
		
		
var can_shoot_gun = true
onready var gun_muzzle_anime = get_node("Drone/Muzzles/Gun Muzzle/Sprite/AnimationPlayer")
var can_shoot_missile_1 = true
onready var missile_muzzle_1_anime = get_node("Drone/Muzzles/Missile Muzzle 1/Sprite/AnimationPlayer")
var can_shoot_missile_2 = false
onready var missile_muzzle_2_anime = get_node("Drone/Muzzles/Missile Muzzle 2/Sprite/AnimationPlayer")
onready var target = get_node("Target")

func shoot():
	if (can_shoot_gun):
		can_shoot_gun = false
		shoot_gun()
	if (can_shoot_missile_1):
		can_shoot_missile_1 = false
		shoot_missile_1()
	if (can_shoot_missile_2):
		can_shoot_missile_2 = false
		shoot_missile_2()
	
func shoot_gun():
	var x = gun_shot.instance()
	projectiles.add_child(x)
	x.set_target(target, Vector2.ZERO, get_node("Drone/Muzzles").rotation - deg2rad(90), projectile_speed, effective_attack_damage, heat_seeking, element_type, effective_element_level, hit_flyers, hit_stealth)
	
	gun_muzzle_anime.play("Shoot", -1, effective_attack_speed)
	yield (gun_muzzle_anime, "animation_finished")
	can_shoot_gun = true
	pass

func shoot_missile_1():
	var x = missile_shot.instance()
	projectiles.add_child(x)
	x.set_target(target, Vector2.ZERO, get_node("Drone/Muzzles").rotation - deg2rad(90), effective_attack_speed, effective_attack_damage * 10, heat_seeking, effective_attack_range, element_type, effective_element_level, hit_flyers, hit_stealth)
	
	missile_muzzle_1_anime.play("Shoot", -1, effective_attack_speed)
	yield (missile_muzzle_1_anime, "animation_finished")
	can_shoot_missile_2 = true
	pass

func shoot_missile_2():
	var x = missile_shot.instance()
	projectiles.add_child(x)
	x.set_target(target, Vector2.ZERO, get_node("Drone/Muzzles").rotation - deg2rad(90), effective_attack_speed, effective_attack_damage * 10, heat_seeking, effective_attack_range, element_type, effective_element_level, hit_flyers, hit_stealth)
	
	missile_muzzle_2_anime.play("Shoot", -1, effective_attack_speed)
	yield (missile_muzzle_2_anime, "animation_finished")
	can_shoot_missile_1 = true
	pass
