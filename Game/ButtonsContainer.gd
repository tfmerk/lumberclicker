extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var buttonNodes = self.get_children()
	
	for buttonNode in buttonNodes:
		if not buttonNode.pressed_close_open_button.is_connected(_on_pressed_close_open_button):
			buttonNode.pressed_close_open_button.connect(_on_pressed_close_open_button)
			print("connected button")
	
	reset_button_state(buttonNodes)
	
	# initial set for active button by checkbox as identifier
	for buttonNode in buttonNodes:
		if buttonNode.start_active:
			print("active button: " + buttonNode.button_id)
			buttonNode.active_sprite.visible = true
			buttonNode.sprite.visible = false
			buttonNode.disabled = true
			if buttonNode.gui != null:
				buttonNode.gui.visible = false


func _on_pressed_close_open_button(button_id: String):
	var buttonNodes = self.get_children()
	
	reset_button_state(buttonNodes)
	
	# set for active button by button_id
	for buttonNode in buttonNodes:
		if buttonNode.button_id == button_id:
			print("active button: " + buttonNode.button_id)
			buttonNode.active_sprite.visible = true
			buttonNode.sprite.visible = false
			buttonNode.disabled = true
			buttonNode.audio_stream_player.play()
			if buttonNode.gui != null:
				buttonNode.gui.visible = true
			else:
				hide_current_gui(buttonNodes)



func hide_current_gui(buttonNodes: Array[Node]) -> void:
	for buttonNode in buttonNodes:
		if buttonNode.gui != null:
			buttonNode.gui.visible = false



func reset_button_state(buttonNodes: Array[Node]) -> void:
	for buttonNode in buttonNodes:
		print("set state for button: " + buttonNode.button_id)
		buttonNode.active_sprite.visible = false
		buttonNode.sprite.visible = true
		buttonNode.disabled = false
		if buttonNode.gui != null:
			buttonNode.gui.visible = false







