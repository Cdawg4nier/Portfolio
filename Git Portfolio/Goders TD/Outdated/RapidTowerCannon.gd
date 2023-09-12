extends KinematicBody2D

onready var enemy_nodes
onready var target
var target_position
var heat_seeking = false

var shot = preload("res://Scenes/Towers/Projectiles/BasicProjectile.tscn")
onready var Projectiles = get_node("Projectiles")
onready var anime = get_node("Sprite/AnimationPlayer")

var custom_speed = 1.0
var damage = 5
var can_shoot = true
var can_acquire_target = true
var thebullet
onready var muzzle = get_node("Position2D")

func _ready() -> void:
	anime.play("Idle")

func _process(_delta):
	can_acquire_target = true
	enemy_nodes = get_tree().get_nodes_in_group("Enemies")
	if enemy_nodes.empty() : 
		enemy_nodes.push_front(get_node("Position2D"))
		can_acquire_target = false
		if (!anime.is_playing()): anime.play("Idle")
	else :
		pass
	
	acquire_target()
	
	if (Input.is_action_pressed("increase_speed")) : custom_speed += .05
	if (Input.is_action_pressed("decrease_speed")) : custom_speed -= .05
	if (custom_speed < 0.06) : custom_speed = 0.06
	
	if (enemy_nodes[0] != null and can_shoot and can_acquire_target) :
		 shoot()
	

func shoot():
	can_shoot = false
	var x = shot.instance()
	thebullet = x
	Projectiles.add_child(x)
	muzzle = get_node("Position2D").global_position
	x.set_target(target, muzzle, rotation, custom_speed, damage, heat_seeking)
	anime.play("Shoot", -1, custom_speed)
	yield (anime, "animation_finished")
	can_shoot = true
	
func acquire_target():
	if !enemy_nodes.empty():
		target = enemy_nodes[0]
	else:
		target = get_node("Position2D")
	target_position = target.global_transform.origin
	rotate(get_angle_to(target_position))

