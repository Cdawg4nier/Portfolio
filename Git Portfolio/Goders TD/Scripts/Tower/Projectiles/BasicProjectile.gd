extends KinematicBody2D

var vector = Vector2.ZERO
var speed = 20
var target_node
var speed_mult
var enemy_that_was_hit
var heat_seeking = false
var canCollide = true
var attack_damage = 20
export var element_type = "Fire"
export var element_level = 4
var hit_stealth = false
var hit_flyers = false

func _ready() -> void:
	
	$"Contact/CollisionShape2D".set_shape(CircleShape2D.new())
	$"Contact/CollisionShape2D".get_shape().radius = 20

func set_target(target, start_pos, rot, speed_multiplier, dmg, seeking, ele_type, ele_level, hitFly, hitStealth):
	position = start_pos
	target_node = target
	speed_mult = speed_multiplier
	vector = Vector2(speed * speed_mult, 0).rotated(rot)
	attack_damage = dmg
	heat_seeking = seeking
	element_type = ele_type
	element_level = ele_level
	hit_stealth = hitStealth
	hit_flyers = hitFly
	
func seek_target(_target, speed_multiplier):
	var rot = get_angle_to(target_node.position)
	vector = Vector2(speed * speed_multiplier, 0).rotated(rot)

func _process(_delta):
	if (heat_seeking): seek_target(target_node, speed_mult) 
	position += vector

func _on_Contact_area_entered(area):
	if (area.get_parent().has_meta("flying")):
		if (area.get_parent().flying && !hit_flyers): return
	if (area.get_parent().has_meta("stealthed")):
		if (area.get_parent().stealthed && !hit_stealth): return
	if (area.get_groups().has("EnemyHitbox") && canCollide):
		area.get_parent().update_healthbar(attack_damage * -1)
		if (element_level > 0): area.get_parent().apply_element(element_type, element_level, attack_damage)
		canCollide = false
		get_node("Basic Projectile").visible = false
		queue_free()
