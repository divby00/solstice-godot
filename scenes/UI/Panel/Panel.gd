extends CanvasLayer

const RedPatch = preload("res://scenes/UI/Panel/red_patch.png")
const BluePatch = preload("res://scenes/UI/Panel/blue_patch.png")
const GreenPatch = preload("res://scenes/UI/Panel/green_patch.png")

onready var lives_label = $LivesLabel
onready var item_texture = $ItemTexture
onready var health_sprite = $HealthSprite
onready var plasma_sprite = $PlasmaSprite
onready var time_bar = $TimeNinePatchRect
onready var laser_bar = $LaserNinePatchRect
onready var info_area_label = $InfoAreaLabel
onready var thrust_bar = $ThrustNinePatchRect
onready var animation_player: AnimationPlayer = $AnimationPlayer

enum Bar {
	THRUST, LASER, TIME
}

func init_panel():
	on_plasma_changed(0)
	on_laser_changed(PlayerData.MAX_LASER)
	on_health_changed(PlayerData.MAX_HEALTH)
	on_thrust_changed(PlayerData.MAX_THRUST)
	on_time_changed(PlayerData.MAX_TIME, PlayerData.MAX_TIME)

func _ready():
	lives_label.text = str(PlayerData.lives)
	item_texture.texture = null

func on_info_area_entered(info_area):
	info_area_label.visible = false
	info_area_label.text = info_area.text
	animation_player.play("animate")

func on_info_area_exited(_info_area):
	info_area_label.text = ""
	animation_player.play_backwards("animate")

func on_item_picked(texture):
	item_texture.texture = texture

func on_item_used():
	item_texture.texture = null

func on_lives_changed(lives):
	lives_label.text = str(lives)

func on_health_changed(health):
	var frame = lerp(9.0, 0.0, (float(health) / float(PlayerData.MAX_HEALTH)))
	health_sprite.frame = frame

func on_plasma_changed(plasma):
	var frame = lerp(0.0, 17.0, (float(plasma) / float(PlayerData.MAX_PLASMA)))
	plasma_sprite.frame = clamp(frame, 0, 16)

func on_thrust_changed(thrust):
	change_color_bar(thrust, thrust_bar)
	var length = lerp(1.0, 80.0, (float(thrust) / float(PlayerData.MAX_THRUST)))
	thrust_bar.rect_size.x = length

func on_laser_changed(laser):
	change_color_bar(laser, laser_bar)
	var length = lerp(1.0, 80.0, (float(laser) / float(PlayerData.MAX_LASER)))
	laser_bar.rect_size.x = length

func on_time_changed(seconds_to_explosion, time_left):
	if time_left > 0:
		var length = lerp(1.0, 80.0, (float(time_left) / float(seconds_to_explosion)))
		change_color_bar(length, time_bar)
		time_bar.rect_size.x = length

func change_color_bar(value, bar):
	if value > 54:
		bar.texture = BluePatch
	elif value > 27 and value <=54:
		bar.texture = GreenPatch
	else:
		bar.texture = RedPatch

func _on_AnimationPlayer_animation_finished(_anim_name):
	info_area_label.visible = true
