extends Node2D

export(int) var camera_limit_top = 0
export(int) var camera_limit_bottom = 0
export(int) var camera_limit_left = 0
export(int) var camera_limit_right = 0


func _ready():
	set_process(false)

func _process(delta):
	print('Is processed')
