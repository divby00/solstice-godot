extends Position2D

const Spawners = {
	"red": preload("res://scenes/Enemies/Spawner/red_enemy_spawner.png"),
	"green": preload("res://scenes/Enemies/Spawner/green_enemy_spawner.png"),
	"blue": preload("res://scenes/Enemies/Spawner/blue_enemy_spawner.png"),
}

const SpawnerTypes = [
	"red", "green", "blue"
]

onready var timer: Timer = $Timer
onready var sprite: Sprite = $Sprite
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var ready = false

func _ready():
	timer.wait_time = rand_range(4, 10)
	timer.start()

func starts():
	audio_player.play()
	SpawnerTypes.shuffle()
	sprite.texture = Spawners[SpawnerTypes[0]]
	animation_player.play("spawn")
	timer.wait_time = rand_range(4, 10)
	timer.start()
	ready = false

func _on_Timer_timeout():
	ready = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spawn":
		animation_player.play("rotate")
