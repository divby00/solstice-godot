extends StaticBody2D

signal enemy_attacked(damage)

onready var timer = $Timer
onready var animation_player = $AnimationPlayer

export(float) var crush_frequency = 1

func _ready():
	timer.wait_time = crush_frequency
	Utils.connect_signal(self, "enemy_attacked", ResourceLoader.player, "on_enemy_attacked")

func _on_Hitbox_body_entered(body):
	if body.is_in_group("PlayerGroup"):
		if ResourceLoader.player.status != PlayerData.Status.INVINCIBLE:
			emit_signal("enemy_attacked", 10)

func _on_Timer_timeout():
	animation_player.play("animate")
