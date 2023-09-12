extends Node2D

var simplex_sampler = OpenSimplexNoise.new()
var nervous_array = []
var skeletal_array = []
var muscular_array = []
var integumentary_array = []
var cardiovascular_array = []

func _ready():
	#save_noise_data("Nervous", 626)
	#save_noise_data("Skeletal", 420)
	#save_noise_data("Muscular", 115)
	#save_noise_data("Integumentary", 066)
	#save_noise_data("Cardiovascular", 111)
	convert_file_to_array(nervous_array, "user://Nervous.dat")
	convert_file_to_array(skeletal_array, "user://Skeletal.dat")
	convert_file_to_array(muscular_array, "user://Muscular.dat")
	convert_file_to_array(integumentary_array, "user://Integumentary.dat")
	convert_file_to_array(cardiovascular_array, "user://Cardiovascular.dat")

func save_noise_data(istring, iseed):
	var file = File.new()
	file.open("user://" + istring + ".dat", File.WRITE)
	var string = get_data_as_string(iseed)
	file.store_string(string)
	file.close()

func get_data_as_string(iseed):
	simplex_sampler.seed = iseed
	var string = ""
	for a in 192:
		for b in 200:
			var value = simplex_sampler.get_noise_2d(a*10, b*10)
			if ((value + 1.0) * 50) > 64: 
				string += (String(Vector2(a*10, b*10)) + "\n")
	return string
			

func convert_file_to_array(array, path):
	var temp_file = File.new()
	var file_path = path
	if (temp_file.open(file_path, File.READ)) != OK:
		print ("Error opening file")
	
	while !temp_file.eof_reached():
		var line = temp_file.get_line()
		if line != "":
			var values = line.split(", ")
			var x = values[0].substr(1).to_int()
			var y = values[1].substr(0, values[1].length()-1).to_int()
			var vector = Vector2(x, y)
			array.append(vector)
	temp_file.close()
	print ("File: " + path + " has successfully completed!")
