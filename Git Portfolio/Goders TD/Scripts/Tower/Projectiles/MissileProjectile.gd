extends KinematicBody2D

var vector = Vector2.ZERO
var speed = 20
var target_node
var speed_mult
var heat_seeking = false
var enemy_nodes = []
var contact_area_nodes = []
var blastZone

var attack_damage = 20
export var element_type = "Fire"
export var element_level = 4
var blastRadius = 100
var hit_stealth = false
var hit_flyers = false

func _ready() -> void:
	$"ProjectileArea/CollisionShape2D".set_shape(CircleShape2D.new())
	blastZone = $"ProjectileArea/CollisionShape2D".get_shape()
	blastZone.radius = 50
	
	$"Contact Area/CollisionShape2D".set_shape(CircleShape2D.new())
	$"Contact Area/CollisionShape2D".get_shape().radius = 8.5

func set_target(target, start_pos, rot, speed_multiplier, dmg, seeking, AoE, ele_type, ele_level, hitFly, hitStealth):
	target_node = target
	position = start_pos
	speed_mult = speed_multiplier
	vector = Vector2(speed * speed_mult, 0).rotated(rot)
	attack_damage = dmg
	heat_seeking = seeking
	element_type = ele_type
	element_level = ele_level
	hit_flyers = hitFly
	hit_stealth = hitStealth
	
	blastRadius = AoE
	blastZone.radius = blastRadius
	
	
	
func seek_target(_target, speed_multiplier):
	var rot = get_angle_to(target_node.position)
	vector = Vector2(speed * speed_multiplier, 0).rotated(rot)

func _process(_delta):
	if (heat_seeking): seek_target(target_node, speed_mult) 
	if (contact_area_nodes.empty()):
		position += vector
	else:
		for a in enemy_nodes :
			if (a.has_method("update_healthbar")) : a.update_healthbar(attack_damage * -1)
			if (element_level >0): a.apply_element(element_type, element_level, attack_damage)
			get_node("Missile Projectile").visible = false
			queue_free()
		queue_free()
	
	


func _on_ProjectileArea_area_entered(area: Area2D) -> void:
	if (area.get_parent().has_meta("flying")):
		if (area.get_parent().flying && !hit_flyers): return
	if (area.get_parent().has_meta("stealthed")):
		if (area.get_parent().stealthed && !hit_stealth): return
	if (area.get_groups().has("EnemyHitbox")): enemy_nodes.append(area.get_parent())


func _on_ProjectileArea_area_exited(area: Area2D) -> void:
	enemy_nodes.erase(area.get_parent())


func _on_Contact_Area_area_entered(area):
	if (area.get_parent().has_meta("flying")):
		if (area.get_parent().flying && !hit_flyers): return
	if (area.get_parent().has_meta("stealthed")):
		if (area.get_parent().stealthed && !hit_stealth): return
	if (area.get_groups().has("EnemyHitbox")): contact_area_nodes.append(area.get_parent())


func _on_Contact_Area_area_exited(area):
	contact_area_nodes.erase(area.get_parent())
