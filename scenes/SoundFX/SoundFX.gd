extends Node

onready var sound_players = get_children()

var sounds = {
	"accept": preload("res://resources/sfx/accept.ogg"),
	"blip": preload("res://resources/sfx/blip.ogg"),
	"bulletsup": preload("res://resources/sfx/bulletsup.ogg"),
	"cancel": preload("res://resources/sfx/cancel.ogg"),
	"ding": preload("res://resources/sfx/ding.ogg"),
	"enemy_hurt": preload("res://resources/sfx/enemy_hurt.ogg"),
	"enemy_spawn": preload("res://resources/sfx/enemy_spawn.ogg"),
	"explosion": preload("res://resources/sfx/explosion.ogg"),
	"hit": preload("res://resources/sfx/hit.ogg"),
	"hurt": preload("res://resources/sfx/hurt.ogg"),
	"laser": preload("res://resources/sfx/laser.ogg"),
	"laserup": preload("res://resources/sfx/laserup.ogg"),
	"love4retro": preload("res://resources/sfx/love4retro.ogg"),
	"opened": preload("res://resources/sfx/opened.ogg"),
	"pickup": preload("res://resources/sfx/pickup.ogg"),
	"player_hit": preload("res://resources/sfx/player_hit.ogg"),
	"powerup": preload("res://resources/sfx/powerup.ogg"),
	"teleport": preload("res://resources/sfx/teleport.ogg"),
	"teleporter_loaded": preload("res://resources/sfx/teleporter_loaded.ogg"),
	"thrustup": preload("res://resources/sfx/thrustup.ogg"),
	"area_is_secured": preload("res://resources/sfx//area_is_secured.ogg"),
	"enter_area_01": preload("res://resources/sfx/entering_area_1.ogg"),
	"enter_area_02": preload("res://resources/sfx/entering_area_2.ogg"),
	"enter_area_03": preload("res://resources/sfx/entering_area_3.ogg"),
	"enter_area_04": preload("res://resources/sfx/entering_area_4.ogg"),
	"enter_area_05": preload("res://resources/sfx/entering_area_5.ogg"),
	"enter_area_06": preload("res://resources/sfx/entering_area_6.ogg"),
	"enter_area_07": preload("res://resources/sfx/entering_area_7.ogg"),
	"enter_area_08": preload("res://resources/sfx/entering_area_8.ogg"),
	"congrats": preload("res://resources/sfx/congrats.ogg"),
	"game_over": preload("res://resources/sfx/game_over.ogg"),
	"nuclear_explosion": preload("res://resources/sfx/nuclear_explosion.ogg"),
}

func play(sound_stream, pitch_scale = 1):
	for sound_player in sound_players:
		if not sound_player.playing:
			sound_player.pitch_scale = pitch_scale
			sound_player.stream = sounds[sound_stream]
			sound_player.play()
			return

func clear():
	for sound_player in sound_players:
		sound_player.stop()
