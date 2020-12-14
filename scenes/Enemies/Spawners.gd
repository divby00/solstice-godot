extends Node2D

const BlueMedusoid = preload("res://scenes/Enemies/BlueMedusoid.tscn")

export(int) var MAX_ENEMIES = 50
onready var enemies: int = 0 setget set_enemies
onready var spawners = get_tree().get_nodes_in_group("SpawnerGroup")

func _process(delta):
	if enemies < MAX_ENEMIES:
		var ready_spawners = get_ready_spawners()
		if ready_spawners.size() > 0:
			ready_spawners.shuffle()
			spawn_enemy(ready_spawners[0])

func get_ready_spawners():
	var ready_spawners = []
	for spawner in spawners:
		if spawner.ready:
			ready_spawners.append(spawner)
	return ready_spawners

func spawn_enemy(spawner):
	spawner.starts()
	self.enemies += 1
	var enemy = BlueMedusoid.instance()
	enemy.global_position = spawner.global_position
	enemy.connect("enemy_attacked", ResourceLoader.player, "on_enemy_attacked")
	enemy.connect("enemy_attack_stopped", ResourceLoader.player, "on_enemy_attack_stopped")
	enemy.connect("enemy_died", self, "on_enemy_died")
	yield(get_tree().create_timer(.9), "timeout")
	get_tree().current_scene.add_child(enemy)

func on_enemy_died(enemy):
	self.enemies -= 1
	enemy.queue_free()

func set_enemies(value):
	enemies = clamp(value, 0, MAX_ENEMIES)
