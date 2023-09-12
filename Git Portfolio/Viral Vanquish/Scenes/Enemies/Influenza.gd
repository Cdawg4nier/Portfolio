extends Node2D

# This Scene Will:
# - Keep track of its own Hitpoints, Movement Speed, Attack Speed, Attack Effects, and Attack Damage
# - Keep track of how much XP it is Worth
# - When this node is destroyed, it tells Runtime how much XP it was worth before it dies
# - Talks to runtime to get a list of available Cells to attack
# - Picks a Cell to target based on distance to the target
# - Move itself towards the cell it is targeting
# - Determine when it is close enough to be colliding with a cell
# - Begin attack a cell it can collide with

# Called when the node enters the scene tree for the first time.

var current_game_time_accum = 0
var action_threshold = 365

func _ready():
	add_to_group("looking_for_time")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_game_timer(current_game_time):
	current_game_time_accum += current_game_time
	check_action_threshold(current_game_time_accum)

func check_action_threshold(total_time):
	if (total_time >= action_threshold):
		current_game_time_accum -= action_threshold
		activate()

func activate():
	pass
