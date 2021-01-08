extends Node

# warning-ignore:unused_signal
signal enemy_hurt
# warning-ignore:unused_signal
signal enemy_died
signal enemy_attacked(damage)

onready var hitbox = $Hitbox

func _ready():
	Utils.connect_signal(hitbox, "player_collided", self, "on_player_collided")

func on_player_collided(damage):
	emit_signal("enemy_attacked", damage)
