extends Node

onready var sound_players = get_children()

var sounds = {
	"accept": preload("res://scenes/SoundFX/accept.ogg"),
	"blip": preload("res://scenes/SoundFX/blip.ogg"),
	"bulletsup": preload("res://scenes/SoundFX/bulletsup.ogg"),
	"cancel": preload("res://scenes/SoundFX/cancel.ogg"),
	"ding": preload("res://scenes/SoundFX/ding.ogg"),
	"enemy_hurt": preload("res://scenes/SoundFX/enemy_hurt.ogg"),
	"enemy_spawn": preload("res://scenes/SoundFX/enemy_spawn.ogg"),
	"explosion": preload("res://scenes/SoundFX/explosion.ogg"),
	"hit": preload("res://scenes/SoundFX/hit.ogg"),
	"hurt": preload("res://scenes/SoundFX/hurt.ogg"),
	"laser": preload("res://scenes/SoundFX/laser.ogg"),
	"laserup": preload("res://scenes/SoundFX/laserup.ogg"),
	"love4retro": preload("res://scenes/SoundFX/love4retro.ogg"),
	"opened": preload("res://scenes/SoundFX/opened.ogg"),
	"pickup": preload("res://scenes/SoundFX/pickup.ogg"),
	"player_hit": preload("res://scenes/SoundFX/player_hit.ogg"),
	"powerup": preload("res://scenes/SoundFX/powerup.ogg"),
	"secured": preload("res://scenes/SoundFX/secured.ogg"),
	"teleport": preload("res://scenes/SoundFX/teleport.ogg"),
	"teleporter_loaded": preload("res://scenes/SoundFX/teleporter_loaded.ogg"),
	"thrustup": preload("res://scenes/SoundFX/thrustup.ogg"),
}

func play(sound_stream, pitch_scale = 1, volume_db = 0):
	for sound_player in sound_players:
		if not sound_player.playing:
			sound_player.pitch_scale = pitch_scale
			sound_player.volume_db = volume_db
			sound_player.stream = sounds[sound_stream]
			sound_player.play()
			return
