extends VBoxContainer


func _ready():
	var button_nodes = self.get_children() as Array[CloseOpenButton]
	
	for button_node in button_nodes:
		if not button_node.pressed_close_open_button.is_connected(_on_pressed_close_open_button):
			button_node.pressed_close_open_button.connect(_on_pressed_close_open_button)
			print("connected button")
	
	reset_button_state(button_nodes)
	
	# initial set for active button by checkbox as identifier
	for button_node in button_nodes:
		if button_node.start_active:
			print("active button: " + button_node.button_id)
			button_node.active_sprite.visible = true
			button_node.sprite.visible = false
			button_node.disabled = true
			if button_node.gui != null:
				button_node.gui.visible = true


func _on_pressed_close_open_button(button_id: String):
	var button_nodes = self.get_children()
	
	reset_button_state(button_nodes)
	
	# set for active button by button_id
	for button_node in button_nodes:
		if button_node.button_id == button_id:
			print("active button: " + button_node.button_id)
			button_node.active_sprite.visible = true
			button_node.sprite.visible = false
			button_node.disabled = true
			button_node.audio_stream_player.play()
			if button_node.gui != null:
				button_node.gui.visible = true
			else:
				hide_current_gui(button_nodes)



func hide_current_gui(button_nodes: Array[Node]) -> void:
	for button_node in button_nodes:
		if button_node.gui != null:
			button_node.gui.visible = false



func reset_button_state(button_nodes: Array[Node]) -> void:
	for button_node in button_nodes:
		print("set state for button: " + button_node.button_id)
		button_node.active_sprite.visible = false
		button_node.sprite.visible = true
		button_node.disabled = false
		if button_node.gui != null:
			button_node.gui.visible = false







