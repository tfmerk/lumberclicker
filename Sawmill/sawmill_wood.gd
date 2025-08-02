extends RigidBody2D
class_name SawmillWood

signal wood_was_clicked


var is_hit: bool = false

@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D
@onready var sprite_2d = $CollisionShape2D/Sprite2D



func _on_texture_button_button_down():
	destroy()



func destroy() -> void:
	if !is_hit:
		is_hit = true
		wood_was_clicked.emit()
		play_destruction()


func play_destruction() -> void:
	animation_player.play("remove")
	await animation_player.animation_finished
	self.queue_free()



func _on_self_destruction_timer_timeout():
	self.queue_free()


