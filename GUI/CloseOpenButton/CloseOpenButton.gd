extends TextureButton
class_name CloseOpenButton


signal pressed_close_open_button(button_id: String)


@export var button_id: String = ""
@export var start_active: bool = false
@export var is_unlocked_from_start: bool = false
@export var label_text: String = ""
@export var active_sprite_texture: Texture
@export var sprite_texture: Texture
@export var gui: Node


@onready var active_sprite = $ActiveSprite
@onready var sprite = $Sprite
@onready var audio_stream_player = $AudioStreamPlayer
@onready var label = $Label



func _ready():
	if active_sprite_texture != null:
		active_sprite.texture = active_sprite_texture
	if sprite_texture != null:
		sprite.texture = sprite_texture
	label.text = label_text



func _on_button_down():
	pressed_close_open_button.emit(button_id)
