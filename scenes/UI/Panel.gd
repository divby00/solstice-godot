extends CanvasLayer

onready var lives_label = $LivesLabel
onready var info_area_label = $InfoAreaLabel
onready var item_texture = $ItemTexture
onready var animation_player = $AnimationPlayer
onready var tween = $Tween
onready var thrust_bar = $BlueNinePatchRect
onready var laser_bar = $GreenNinePatchRect
onready var time_bar = $RedNinePatchRect
onready var health_sprite = $HealthSprite
onready var texts = []

func _ready():
	lives_label.text = str(PlayerData.lives)
	item_texture.texture = null

func on_info_area_entered(info_area):
	append_text(info_area.text)
	if not tween.is_active():
		animation_player.play("animate")

func init_tween():
	info_area_label.rect_position.x = 256
	var text = pick_text()
	if text != null:
		var length = text.length()
		info_area_label.text = text
		var duration = clamp(0.10 * length, 2, 10)
		tween.interpolate_property(info_area_label, "rect_position", Vector2(256, 144), Vector2(length * -8, 144), duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	else:
		animation_player.play_backwards("animate_no_tween")

func pick_text():
	var text = null
	if not texts.empty():
		text = texts[0]
	return text
		
func append_text(text):
	if not texts.has(text):
		texts.append(text)

func _on_Tween_tween_completed(object, key):
	texts.remove(0)
	init_tween()

func on_lives_changed(lives):
	lives_label.text = str(lives)

func on_health_changed(health):
	var frame = lerp(9.0, 0.0, (float(health) / float(PlayerData.MAX_HEALTH)))
	health_sprite.frame = frame

func on_thrust_changed(thrust):
	thrust_bar.rect_size.x = thrust

func on_laser_changed(laser):
	laser_bar.rect_size.x = laser

func on_time_changed(seconds_to_explosion, time_left):
	if time_left > 0:
		time_bar.rect_size.x = lerp(1.0, PlayerData.MAX_TIME, (float(time_left) / float(seconds_to_explosion)))
