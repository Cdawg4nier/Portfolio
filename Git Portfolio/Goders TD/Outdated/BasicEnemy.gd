extends KinematicBody2D

var move_speed = 750
var direction
onready var hp = get_node("HealthBar")
var max_health = 10000
onready var projectile = preload("res://Scenes/Towers/Projectiles/BasicProjectile.tscn")
onready var timer = get_node("Timer")
var isRunning = false
var dotType = []
var dotValue = []
var typeIndex
var numIterations = 0

func _ready() -> void:
	$Sprite/AnimationPlayer.play("Idle")
	add_to_group("Enemies")
	hp.max_value = max_health
	hp.value = max_health

func _process(delta):
	if (Input.is_action_pressed("move_down")):
		move_and_slide(Vector2(0,move_speed))
	if (Input.is_action_pressed("move_up")):
		move_and_slide(Vector2(0,-1*move_speed))
	if (Input.is_action_pressed("move_right")):
		move_and_slide(Vector2(move_speed,0))
	if (Input.is_action_pressed("move_left")):
		move_and_slide(Vector2(-1 * move_speed,0))
	
	if (isRunning) :
		update_tick()

func update_healthbar(value):
	hp.value += value
	if (hp.value < 1) : queue_free()

func add_dot(type):
	if (isRunning) : 
		numIterations = 0
		typeIndex = dotType.find(type)
		if (typeIndex >= 0) : #if the "type" of elemental status is already afflicted
			dotValue[typeIndex] += 5
		else:
			dotType.push_front(type)
			dotValue.push_front(5)
	else :
		dotType.push_front(type)
		dotValue.push_front(5)
		isRunning = true

func update_tick() :
	if (numIterations == 5) :
		isRunning = false
		dotType.clear()
		dotValue.clear()
	if (timer.is_stopped()) :
		timer.start(.75)

func _on_Timer_timeout() -> void:
	numIterations += 1
	for a in dotValue:
		update_healthbar(a * -1)
