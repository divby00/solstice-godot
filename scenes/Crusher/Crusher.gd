extends StaticBody2D

export(float) var crush_frequency = 1
onready var timer = $Timer
onready var animation_player = $AnimationPlayer

func _ready():
	timer.wait_time = crush_frequency

func _on_Hitbox_body_entered(_body):
	if PlayerData.status != PlayerData.Status.INVINCIBLE:
		PlayerData.health = 0

func _on_Timer_timeout():
	animation_player.play("animate")
