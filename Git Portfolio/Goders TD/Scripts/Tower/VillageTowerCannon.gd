extends Node2D

#VILLAGE TOWER

var enemy_nodes = []
var ally_nodes = []

onready var anime = get_node("Sprite/AnimationPlayer")
var buffed_towers_area
onready var weakened_enemies_area = get_node("Weakened Enemies Area/CollisionShape2D").get_shape()

var attack_speed_level = 0
var attack_damage_level = 0
var attack_range  = 150
var attack_range_level = 0
var element_type = "Default"
var element_level = 0
var weakening_level = 0
var hit_stealth = false
var hit_flyers = false

func _ready() -> void:
	
	$"Buffed Towers Area/CollisionShape2D".set_shape(CircleShape2D.new())
	buffed_towers_area = $"Buffed Towers Area/CollisionShape2D".get_shape()
	buffed_towers_area.radius = attack_range
	
	$"Tower Base Area/CollisionShape2D".set_shape(CircleShape2D.new())
	$"Tower Base Area/CollisionShape2D".get_shape().radius = 65
	
	$"Weakened Enemies Area/CollisionShape2D".set_shape(CircleShape2D.new())
	weakened_enemies_area = $"Weakened Enemies Area/CollisionShape2D".get_shape()
	weakened_enemies_area.radius = attack_range
	
	add_to_group("Turret")
	
func upgrade_attack_speed():
	if (attack_speed_level < 5):
		attack_speed_level += 1
		for a in ally_nodes:
			if (a.has_method("calculate_buffed_multipliers")):
				a.calculate_buffed_multipliers()
func upgrade_attack_damage():
	if (attack_damage_level < 5):
		attack_damage_level += 1
		for a in ally_nodes:
			if (a.has_method("calculate_buffed_multipliers")):
				a.calculate_buffed_multipliers()
func upgrade_attack_range():
	if (attack_range_level < 5):
		attack_range += 50
		buffed_towers_area.radius = attack_range
		weakened_enemies_area.radius = attack_range
		attack_range_level += 1
		for a in ally_nodes:
			if (a.has_method("calculate_buffed_multipliers")):
				a.calculate_buffed_multipliers()
func upgrade_element(inco):
	if (element_level < 5):
		element_type = inco
		element_level += 1
		for a in ally_nodes:
			if (a.has_method("calculate_buffed_multipliers")):
				a.calculate_buffed_multipliers()
func upgrade_special_effects():
	weakening_level += 1
func upgrade_stealth_sight():
	hit_stealth = true
	for a in ally_nodes:
		if (a.has_method("upgrade_stealth_sight")):
			a.upgrade_stealth_sight()
func upgrade_hit_flyers():
	hit_flyers = true
	for a in ally_nodes:
		if (a.has_method("upgrade_hit_flyers")):
			a.upgrade_hit_flyers()

var timer = 0
var is_active = false
var location_locked = false
var is_selected_tower = false
var is_not_active = true

func _draw():
	if (is_selected_tower or is_not_active):
		draw_circle(Vector2.ZERO, attack_range, Color(0,0,0,.3))

func _process(_delta):
	
	update()
	
	if (!location_locked) : position = get_global_mouse_position()
	if (Input.is_action_just_pressed("PlaceTurret") and !is_active) : 
		location_locked = true
		is_active = true
		is_not_active = false
		anime.play("Idle")
		
		
		
	
func _on_Buffed_Towers_Area_area_entered(area):
	if (area.get_parent() == self): return
	if (area.get_parent().get_groups().has("Turret")):
		if (area.get_parent().has_method("add_me_to_tower")):
			ally_nodes.append(area.get_parent())
			area.get_parent().add_me_to_tower(self)
			area.get_parent().calculate_buffed_multipliers()


func _on_Buffed_Towers_Area_area_exited(area):
	if(area.get_parent().get_groups().has("Turret")):
		if (area.get_parent().has_method("remove_me_from_tower")): 
			ally_nodes.erase(area.get_parent())
			area.get_parent().remove_me_from_tower(self)
			area.get_parent().calculate_buffed_multipliers()


func _on_Weakened_Enemies_Area_area_entered(area):
	if (area.get_parent().has_meta("flying")):
		if (area.get_parent().flying && !hit_flyers): return
	if (area.get_parent().has_meta("stealthed")):
		if (area.get_parent().stealthed && !hit_stealth): return
	if (area.get_groups().has("EnemyHitbox") and area.get_parent().has_meta("villageDamageMultiplier")):
		area.get_parent().villageDamageMultiplier = 1.0 + (weakening_level * .1)


func _on_Weakened_Enemies_Area_area_exited(area):
	if (area.get_groups().has("EnemyHitbox") and area.get_parent().has_meta("villageDamageMultiplier")):
		area.get_parent().villageDamageMultiplier = 1.0 
