extends Node

var fullscreen = true setget set_fullscreen
var sfx_volume = 0.5 setget set_sfx_volume
var music_volume = 0.5 setget set_music_volume

func set_fullscreen(value):
	if OS.get_name() != "HTML5":
		fullscreen = value
		if !fullscreen:
			OS.set_window_size(Vector2(1024, 768))
		OS.window_fullscreen = fullscreen
		save()

func set_sfx_volume(value):
	sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(sfx_volume))
	save()

func set_music_volume(value):
	music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(music_volume))
	save()

func save():
	var config = ConfigFile.new()
	config.set_value("display", "fullscreen", self.fullscreen)
	config.set_value("sound", "sfx_volume", self.sfx_volume)
	config.set_value("sound", "music_volume", self.music_volume)
	config.save("user://solstice.cfg")

func load_and_save_config():
	var config = ConfigFile.new()
	var err = config.load("user://solstice.cfg")
	if err == OK:
		
		if not config.has_section_key("display", "fullscreen"):
			config.set_value("display", "fullscreen", self.fullscreen)
		else:
			self.fullscreen = config.get_value("display", "fullscreen", true)

		if not config.has_section_key("sound", "sfx_volume"):
			config.set_value("sound", "sfx_volume", self.sfx_volume)
		else:
			self.sfx_volume = config.get_value("sound", "sfx_volume", 0.5)

		if not config.has_section_key("sound", "music_volume"):
			config.set_value("sound", "music_volume", self.music_volume)
		else:
			self.music_volume = config.get_value("sound", "music_volume", 0.5)

	config.save("user://solstice.cfg")

