extends Path2D


onready var enemy = preload("res://Scenes/Enemies/BasicEnemy.tscn")
onready var basic_tower = preload("res://Scenes/Towers/SniperTower.tscn")

func _ready() -> void:
	pass # Replace with function body.

var timer = 1
var timerGO = false

func _process(_delta):
	
	if (Input.is_action_just_pressed("create_enemy")):
		timerGO = true
		var x = enemy.instance()
		add_child(x)
		x.set_Data()
		x.loop = true
		x.health = 10000
		x.maxHealth = 10000
	
	#if (timer%50 == 0):
		#var x = enemy.instance()
		#add_child(x)
		#x.set_Data()
	#	x.health = 50
		#x.speed = 300
		#x.maxHealth = 50
