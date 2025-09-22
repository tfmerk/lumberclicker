extends Control

signal unlock_trees(amount: int)
signal unlock_sawmills(amount: int)
signal unlock_recipe()


@onready var buttons_container = $SideMenueBar/ButtonsContainer
@onready var music = $Music


var current_audio_stream_player: AudioStreamPlayer



func _ready():
	applay_save()


func applay_save() -> void:
	print(str(SaveManager.save_data))
	unlock_building_buttons()
	update_resource_gui()


func unlock_building_buttons() -> void:
	var buttons = buttons_container.get_children()
	for button in buttons:
		if button is CloseOpenButton:
			if button.is_unlocked_from_start:
				button.visible = true
			elif button.button_id == "sawmill":
				button.visible = SaveManager.save_data.unlocked_economy["sawmills"] > 0
			else:
				print("unknown building button: " + str(button.button_id))


func update_resource_gui():
	print("update resources")
	var resource_overview_children = %ResourceOverview.get_children()
	for control in resource_overview_children:
		var path = control.get_path()
		var label = control.get_node("TextureRect/Label")
		var resource_id = path.get_name(path.get_name_count() - 1)
		if label:
			var value = SaveManager.save_data.resources[resource_id]
			label.text = str(value)
			control.visible = value > 0
		else:
			print("No label found in: " + control.name)


func _on_resources_update():
	update_resource_gui()



func _on_auto_save_timer_timeout():
	update_save()



func update_save() -> void:
	SaveManager.save_data.last_time_played = Time.get_unix_time_from_system()
	SaveManager.save_game()


func _on_milestone_gui_try_unlock_milestone(milestone: MilestoneResource):
	if has_enough_resources(milestone.cost):
		pay_costs(milestone.cost)
		apply_milestone_effect(milestone)
		update_resource_gui()
		%MilestoneManager.add_completed_milestone(milestone)
		update_save()
	else:
		print("Not enough resources!")



func has_enough_resources(costs: Dictionary) -> bool:
	var data = SaveManager.save_data
	for key in costs:
		if data.resources[key] < costs[key]:
			return false
	return true



func pay_costs(costs: Dictionary) -> bool:
	var data = SaveManager.save_data
	for key in costs:
		data.resources[key] -= costs[key]

	return true



func apply_milestone_effect(milestone: MilestoneResource) -> void:
	match milestone.effect_id:
		"add_slots_tree":
			SaveManager.save_data.unlocked_economy["trees"] += milestone.effect_power
			print("Added " + str(milestone.effect_power) + " tree plots")
			unlock_trees.emit(milestone.effect_power)
		"add_sawmill":
			SaveManager.save_data.unlocked_economy["sawmills"] += milestone.effect_power
			print("Added " + str(milestone.effect_power) + " sawmills")
			unlock_sawmills.emit(milestone.effect_power)
		"unlock_building_sawmill":
			SaveManager.save_data.unlocked_economy["sawmills"] += 1
			unlock_building_buttons()
			print("Unlocked sawmill-tab and one sawmill")
			unlock_sawmills.emit(1)
		_:
			if milestone.effect_id.begins_with("unlock_recipe_"):
				# remove prefix
				var recipe_info = milestone.effect_id.trim_prefix("unlock_recipe_")
				# find the first "_" character to parse the type and name from this
				var first_underscore_index = recipe_info.find("_")
				if first_underscore_index != -1:
					var recipe_type = recipe_info.substr(0, first_underscore_index)
					var recipe_name = recipe_info.substr(first_underscore_index + 1)
					SaveManager.save_data.unlocked_recipes[recipe_type].append(recipe_name)
					unlock_recipe.emit()
				else:
					print("Could not parse milestone.effect_id: \"" + milestone.effect_id + "\"")
			else:
				print("Unknown effect_id \"" + milestone.effect_id + "\" for milestone id \"" + milestone.id + "\"")


func _on_milestone_manager_unlocked_milestone(milesone):
	apply_milestone_effect(milesone)
	update_resource_gui()
