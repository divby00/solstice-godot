extends Area2D

signal player_got_powerup(powerup)

onready var active_timer = $ActiveTimer
onready var animation_player = $AnimationPlayer

var angle = 0

func _ready():
	angle = randi() % 360 * sign(rand_range(-1, 1))
	Utils.connect_signal(self, "player_got_powerup", ResourceLoader.player, "on_player_got_powerup")

func _process(delta):
	angle += delta * 10
	global_position.x += sin(angle) / 3
	global_position.y += cos(angle) / 3

func _on_PlasmaPowerup_body_entered(body):
	if body.is_in_group("PlayerGroup"):
		emit_signal("player_got_powerup", self)
		SoundFx.play("powerup")
		queue_free()

func _on_ActiveTimer_timeout():
	animation_player.play("dissapear")
