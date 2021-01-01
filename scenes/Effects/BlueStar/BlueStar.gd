extends Node2D


onready var animation_player: AnimationPlayer = $AnimationPlayer
var animations = [
	"short", "medium", "long"
]

func _ready():
	animations.shuffle()
	animation_player.play(animations[0])

