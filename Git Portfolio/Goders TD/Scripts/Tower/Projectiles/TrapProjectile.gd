extends Node2D

var enemy_nodes = []
var contact_area_nodes = []
var trap_zone
onready var anime = get_node("Sprite/AnimationPlayer")

var attack_damage = 20
export var element_type = "Fire"
export var element_level = 4
var trap_radius = 150
var attack_timer = 1.0
var hit_stealth = false
var hit_flyers = false

var locationLocked = false

onready var timer = get_node("Timer")

func _ready() -> void:
	
	$"Attack Area/CollisionShape2D".set_shape(CircleShape2D.new())
	trap_zone = $"Attack Area/CollisionShape2D".get_shape()
	trap_zone.radius = trap_radius
	
	$"Trap Base Area/CollisionShape2D".set_shape(CircleShape2D.new())
	$"Trap Base Area/CollisionShape2D".get_shape().radius = 35
	
	timer.one_shot = true

func update_data(attackDamage, eleType, eleLevel, trapRadius, attackTimer, hitStealth, hitFly):
	attack_damage = attackDamage
	element_type = eleType
	element_level = eleLevel
	trap_radius = trapRadius
	trap_zone.radius = trap_radius
	attack_timer = attackTimer
	hit_stealth = hitStealth
	hit_flyers = hitFly

var can_draw = false

func _draw():
	if (can_draw):
		draw_circle(Vector2.ZERO, trap_radius, Color(0,0,0,.3))

func _process(delta):
	
	update()
	
	if (!locationLocked) : position = get_global_mouse_position()
	if (Input.is_action_just_pressed("PlaceTurret")) : locationLocked = true
	if (Input.is_action_just_pressed("UpliftTurret")) : locationLocked = false
	if (timer.is_stopped()): 
		timer.start(attack_timer)


func _on_Area2D_area_entered(area: Area2D) -> void:
	if (area.get_parent().has_meta("flying")):
		if (area.get_parent().flying && !hit_flyers): return
	if (area.get_parent().has_meta("stealthed")):
		if (area.get_parent().stealthed && !hit_stealth): return
	if (area.get_groups().has("EnemyHitbox")): enemy_nodes.append(area.get_parent())


func _on_Area2D_area_exited(area: Area2D) -> void:
	enemy_nodes.erase(area.get_parent())


func _on_Timer_timeout() -> void:
	anime.stop()
	anime.play("Activate", -1, 2.1 - attack_timer)
	for a in enemy_nodes :
			if (a.has_method("update_healthbar")) : a.update_healthbar(attack_damage * -1)
			if (element_level >0): a.apply_element(element_type, element_level, attack_damage)
