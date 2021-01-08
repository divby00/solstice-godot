extends Node2D

export(int) var camera_limit_top = 0
export(int) var camera_limit_bottom = 0
export(int) var camera_limit_left = 0
export(int) var camera_limit_right = 0

onready var audio_player = $AudioStreamPlayer
