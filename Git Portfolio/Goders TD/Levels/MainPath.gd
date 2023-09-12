extends Path2D

var enemy = preload("res://Scenes/Enemies/BasicEnemy.tscn")

# Called when the node enters the scene tree for the first time.
#func _ready():
	

#(aspeed := 150.0, alevel := 1, ahealth := 100, 
#astealthed := false, aflying := false, aiselemental := false, aattunedelement := "Basic", aattunedtype := "Slashing"):
var EnemyLevels = {
	Basic_Level_1 = [150.0, 1, 100, false, false, false, "Basic", "Slashing"],
	Basic_Level_2 = [160.0, 2, 150, false, false, false, "Basic", "Slashing"],
	Basic_Level_3 = [170.0, 3, 200, false, false, false, "Basic", "Slashing"],
	Basic_Level_4 = [180.0, 4, 250, false, false, false, "Basic", "Slashing"],
	Basic_Level_5 = [190.0, 5, 300, false, false, false, "Basic", "Slashing"],
	Tank_Level_1 = [50.0, 1, 500, false, false, false, "Basic", "Slashing"],
	Tank_Level_2 = [55.0, 2, 750, false, false, false, "Basic", "Slashing"],
	Tank_Level_3 = [60.0, 3, 1000, false, false, false, "Basic", "Slashing"],
	Tank_Level_4 = [65.0, 4, 1250, false, false, false, "Basic", "Slashing"],
	Tank_Level_5 = [70.0, 5, 1500, false, false, false, "Basic", "Slashing"],
	Speed_Level_1 = [300.0, 1, 20, false, false, false, "Basic", "Slashing"],
	Speed_Level_2 = [320.0, 2, 30, false, false, false, "Basic", "Slashing"],
	Speed_Level_3 = [340.0, 3, 40, false, false, false, "Basic", "Slashing"],
	Speed_Level_4 = [360.0, 4, 50, false, false, false, "Basic", "Slashing"],
	Speed_Level_5 = [380.0, 5, 60, false, false, false, "Basic", "Slashing"],
	Swarm_Level_1 = [100.0, 1, 10, false, false, false, "Basic", "Slashing" ],
	Swarm_Level_2 = [105.0, 2, 15, false, false, false, "Basic", "Slashing"],
	Swarm_Level_3 = [110.0, 3, 20, false, false, false, "Basic", "Slashing"],
	Swarm_Level_4 = [115.0, 4, 25, false, false, false, "Basic", "Slashing"],
	Swarm_Level_5 = [120.0, 5, 30,false, false, false, "Basic", "Slashing"]
}	
var timer = 0

func _process(delta):
	if (timer%100 == 0):
		create_Enemy("Basic_Level_4")
	timer += 1
	if (timer%150 == 0):
		create_Enemy("Speed_Level_3")
	
	

func create_Enemy(narnia):
	var newEnemy = enemy.instance()
	add_child(newEnemy)
	var searchedValues = EnemyLevels[narnia]
	newEnemy.set_Data(searchedValues)
