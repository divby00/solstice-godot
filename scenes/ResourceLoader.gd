extends Node

const Intro = preload("res://scenes/Intro/Intro.tscn")
const Ending = preload("res://scenes/Ending/Ending.tscn")
const WorldScene = preload("res://scenes/World/World.tscn")
const GameOver = preload("res://scenes/GameOver/GameOver.tscn")
const TimeOver = preload("res://scenes/GameOver/TimeGameOver.tscn")
var item_defs = preload("res://scenes/Items/ItemDefinitions.tres")
var player = null
