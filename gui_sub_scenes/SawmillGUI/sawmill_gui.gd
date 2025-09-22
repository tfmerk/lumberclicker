extends Control


signal resources_update()


@export var wood_input: int = 10
@export var planks_output: int = 1


@onready var sawmills = $Sawmills



func _ready():
	applay_save()


func applay_save() -> void:
	unlock_sawmills_in_gui()


func unlock_sawmills_in_gui() -> void:
	var sawmill_nodes = sawmills.get_children()
	var sawmills_counter = 0
	
	var sawmills_to_unlock = SaveManager.save_data.unlocked_economy["sawmills"]
	print("sawmills to unlock: " + str(sawmills_to_unlock))
	
	for sawmill_node in sawmill_nodes:
		sawmill_node.visible = false
	
	for sawmill_node in sawmill_nodes:
		if not sawmill_node.pressed.is_connected(_on_recharge_button_button_pressed):
			sawmill_node.button_started.connect(_on_recharge_button_button_pressed)
			print("--- connected button 2")
		if not sawmill_node.button_recharged.is_connected(_on_recharge_button_button_recharged):
			sawmill_node.button_recharged.connect(_on_recharge_button_button_recharged)
			print("--- connected button 1")
		if sawmills_counter < sawmills_to_unlock:
			sawmill_node.visible = true
		sawmills_counter += 1
	print("Unlocked sawmills: " + str(sawmills_to_unlock))




func _on_visibility_changed():
	if self.visible:
		pass




func _on_recharge_button_button_recharged():
	print("recharged button")
	resources_update.emit()


func _on_recharge_button_button_pressed():
	print("pressed button!")
	resources_update.emit()



func _on_game_container_unlock_sawmills(amount):
	unlock_sawmills_in_gui()
