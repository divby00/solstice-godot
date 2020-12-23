extends Node

onready var levels = {
	"00": preload("res://scenes/Levels/Level00.tscn"),
	"01": preload("res://scenes/Levels/Level01.tscn"),
	"02": preload("res://scenes/Levels/Level02.tscn"),
	"03": preload("res://scenes/Levels/Level03.tscn"),
	"04": preload("res://scenes/Levels/Level04.tscn"),
	"05": preload("res://scenes/Levels/Level05.tscn"),
	"06": preload("res://scenes/Levels/Level06.tscn"),
	"07": preload("res://scenes/Levels/Level07.tscn"),
	"08": preload("res://scenes/Levels/Level08.tscn"),
}

var current_level = null
var current_level_number = 0
