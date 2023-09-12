extends Node2D

@export var initial_cell = false

var colliding_cells = []
# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func is_able_to_be_placed():
	pass

func _on_other_cell_detection_area_entered(area):
	if (!colliding_cells.has(area.get_parent())): colliding_cells.append(area.get_parent())


func _on_other_cell_detection_area_exited(area):
	if (colliding_cells.has(area.get_parent())): colliding_cells.erase(area.get_parent())
