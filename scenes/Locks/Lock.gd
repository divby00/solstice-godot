extends Node2D

signal lock_opened(lock)

const BigExplosionParticles = preload("res://scenes/Effects/BigExplosionParticles.tscn")
const Explosion = preload("res://scenes/Effects/explosion.ogg")
const Opened = preload("res://scenes/Locks/opened.ogg")

export(int) var OPENING_EXPLOSIONS = 5
export(String) var opened_by = ""
export(bool) var explodes_on_opening = false

onready var sprite = $Sprite
onready var closed_area = $ClosedArea
onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var can_open = false

func _process(delta):
	if can_open and Input.is_action_just_pressed("secondary"):
		open()
		emit_signal("lock_opened", self)

func _on_OpenerArea_body_entered(body):
	if body.is_in_group("PlayerGroup"):
		if PlayerData.selected_item == opened_by:
			can_open = true

func _on_OpenerArea_body_exited(body):
	can_open = false

func open():
	if explodes_on_opening:
		audio_player.stream = Explosion
		audio_player.play()
		var sprite_size = sprite.texture.get_size()
		for i in OPENING_EXPLOSIONS:
			var position = Vector2(
					global_position.x + rand_range(0, sprite_size.x / sprite.hframes), 
					global_position.y + rand_range((sprite_size.y / sprite.vframes) * -1, 0)
			)
			var explosion = BigExplosionParticles.instance()
			explosion.emitting = true
			explosion.remove_when_finish = true
			explosion.global_position = position
			get_tree().current_scene.add_child(explosion)
			yield(get_tree().create_timer(rand_range(0.0, 0.1)), "timeout")
	else:
		audio_player.stream = Opened
		audio_player.play()
	queue_free()
