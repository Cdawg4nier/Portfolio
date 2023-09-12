extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var temp
func _ready():
	temp = get_node("Region 1").get_used_cells()
	for a in temp:
		print (a)
		
	print (temp.size())
	



func _process(delta):
	if (Input.is_action_just_pressed("PlaceTurret")):
		get_node("Region 1").set_cellv(get_global_mouse_position(), -1)
		get_node("Region 1").update_dirty_quadrants()
		print ("I am getting your signal")
#	pass
