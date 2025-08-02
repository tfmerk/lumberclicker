extends TextureButton
class_name TreeButton


@export var wood: int = 1



@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@onready var audio_stream_player = $AudioStreamPlayer




var is_grown = true



signal tree_cut_down(wood_amount: int)





func _on_button_down():
	if is_grown == false:
		return
	is_grown = false
	tree_cut_down.emit(wood)
	animation_player.play("cut_down")
	await animation_player.animation_finished
	timer.start()



func _on_timer_timeout():
	animation_player.play("grow")
	await animation_player.animation_finished
	animation_player.play("wiggle")
	is_grown = true
