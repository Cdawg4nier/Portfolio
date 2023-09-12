extends Node2D

var current_game_time_accum = 0
@export var action_threshold = 5000

@export var enemy_1 : PackedScene
@export var spawn_amount_1 = 4

@onready var virus_node = $Viruses

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_1.instantiate()
	add_to_group("looking_for_time")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func update_game_timer(current_game_time):
	current_game_time_accum += current_game_time
	check_action_threshold(current_game_time_accum)
	
func check_action_threshold(total_time):
	if (total_time >= action_threshold):
		activate()
		current_game_time_accum -= action_threshold
	
func activate():
	for i in spawn_amount_1:
		var new_enemy = enemy_1.duplicate().instantiate()
		virus_node.add_child(new_enemy)
		
