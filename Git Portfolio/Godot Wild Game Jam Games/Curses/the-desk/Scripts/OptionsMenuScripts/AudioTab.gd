extends Control


var standard_slider_size = Vector2(300, 50)
	
func setup_audio_tab():
	var audio_main_vbox_container = VBoxContainer.new()
	audio_main_vbox_container.name = "Audio"
	audio_main_vbox_container.add_child(setup_master_audio_hbox_container())
	audio_main_vbox_container.add_child(setup_sound_audio_hbox_container())
	audio_main_vbox_container.add_child(setup_music_audio_hbox_container())
	return audio_main_vbox_container

func setup_master_audio_hbox_container():
	var master_audio_hbox_container = HBoxContainer.new()
	var master_audio_label = Label.new()
	var master_audio_slider = HSlider.new()
	master_audio_hbox_container.add_child(master_audio_label)
	master_audio_hbox_container.add_child(master_audio_slider)
	
	master_audio_label.text = "Master"
	
	master_audio_slider.value = 100.00
	master_audio_slider.tick_count = 10
	master_audio_slider.ticks_on_borders = true
	master_audio_slider.set_custom_minimum_size(standard_slider_size)
	
	
	return master_audio_hbox_container
	
func setup_sound_audio_hbox_container():
	var sound_audio_hbox_container = HBoxContainer.new()
	var sound_audio_label = Label.new()
	var sound_audio_slider = HSlider.new()
	sound_audio_hbox_container.add_child(sound_audio_label)
	sound_audio_hbox_container.add_child(sound_audio_slider)
	
	sound_audio_label.text = "Audio"
	
	sound_audio_slider.value = 100.00
	sound_audio_slider.tick_count = 10
	sound_audio_slider.ticks_on_borders = true
	sound_audio_slider.set_custom_minimum_size(standard_slider_size)
	
	return sound_audio_hbox_container
	
func setup_music_audio_hbox_container():
	var music_audio_hbox_container = HBoxContainer.new()
	var music_audio_label = Label.new()
	var music_audio_slider = HSlider.new()
	music_audio_hbox_container.add_child(music_audio_label)
	music_audio_hbox_container.add_child(music_audio_slider)
	
	music_audio_label.text = "Music"
	
	music_audio_slider.value = 100.00
	music_audio_slider.tick_count = 10
	music_audio_slider.ticks_on_borders = true
	music_audio_slider.set_custom_minimum_size(standard_slider_size)
	
	return music_audio_hbox_container
	

