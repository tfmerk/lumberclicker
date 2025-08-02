extends Control


@onready var trees = $Trees
@onready var milestone_gui = $Milestone/MilestoneGUI
@onready var sawmill_gui = $Sawmill/SawmillGUI
@onready var buttons_container = $MenuButtonsLayer/ButtonsContainer
@onready var music = $Music



var current_audio_stream_player: AudioStreamPlayer






func _ready():
	milestone_gui.visible = false
	sawmill_gui.visible = false
	applay_save()
	current_audio_stream_player = music.get_children().pick_random()
	current_audio_stream_player.volume_db = -30
	current_audio_stream_player.play()



func applay_save() -> void:
	get_offline_income()
	unlock_trees_in_gui()
	unlock_building_buttons()
	update_resource_gui()



func get_offline_income() -> void:
	var now = Time.get_unix_time_from_system()
	var last_saved_time = %SaveManager.save_data.last_time_played
	var seconds_elapsed = now - last_saved_time
	var minutes_elapsed = floor(seconds_elapsed / 60)
	
	if minutes_elapsed > 0:
		var offline_wood = floor(minutes_elapsed * %SaveManager.save_data.wood_per_time_cycle)
		%SaveManager.save_data.resources["wood"] += offline_wood
		print("You were gone for %d minutes and earned %d wood!" % [minutes_elapsed, offline_wood])
	else:
		print("No offline income!")



func unlock_trees_in_gui() -> void:
	var treeNodes = trees.get_children()
	var treeCounter = 0
	var trees_to_unlock = %SaveManager.save_data.unlocked_economy["trees"]
	print("trees to unlock: " + str(trees_to_unlock))
	
	for treeNode in treeNodes:
		treeNode.visible = false
	
	for treeNode in treeNodes:
		if not treeNode.tree_cut_down.is_connected(_on_tree_tree_cut_down):
			treeNode.tree_cut_down.connect(_on_tree_tree_cut_down)
		if treeCounter < trees_to_unlock: 
			treeNode.visible = true
		treeCounter += 1
	print("Unlocked trees: " + str(trees_to_unlock))




func unlock_building_buttons() -> void:
	var buttons = buttons_container.get_children()
	
	# unlock all buttons
	for button in buttons:
		if button is CloseOpenButton:
			if button.is_unlocked_from_start:
				button.visible = true
			else:
				button.visible = %SaveManager.save_data.buildings[button.button_id]["unlocked"]



func update_save() -> void:
	%SaveManager.save_data.last_time_played = Time.get_unix_time_from_system()
	%SaveManager.save_game()



func _on_tree_tree_cut_down(wood_amount):
	%SaveManager.save_data.resources["wood"] += wood_amount * %SaveManager.save_data.wood_per_click
	update_resource_gui()



func update_resource_gui():
	var resource_overview_children = %ResourceOverview.get_children()
	for control in resource_overview_children:
		var path = control.get_path()
		var label = control.get_node("TextureRect/Label")
		var resource_id = path.get_name(path.get_name_count() - 1)
		if label:
			var value = %SaveManager.save_data.resources[resource_id]
			label.text = str(value)
			control.visible = value > 0
		else:
			print("No label found in: " + control.name)


func _on_auto_save_timer_timeout():
	print("Auto save...")
	update_save()



func _on_milestone_gui_try_unlock_milestone(milestone: MilestoneResource):
	print("tried to unlock the milestone")
	
	if has_enough_resources(milestone.cost):
		pay_costs(milestone.costs)
		print("successfully payed!")
		apply_milestone_effect(milestone)
		update_resource_gui()
		%MilestoneManager.add_completed_milestone(milestone)
		milestone_gui.set_active_milestone()
		update_save()
	else:
		print("Not enough resources!")



func has_enough_resources(costs: Dictionary) -> bool:
	var data = %SaveManager.save_data
	for key in costs:
		if data.resources[key] < costs[key]:
			return false
	return true



func pay_costs(costs: Dictionary) -> bool:
	var data = %SaveManager.save_data
	for key in costs:
		data.resources[key] -= costs[key]

	return true



func apply_milestone_effect(milestone: MilestoneResource) -> void:
	match milestone.effect_id:
		"add_slots_tree":
			%SaveManager.save_data.unlocked_economy["trees"] += milestone.effect_power
			print("Added " + str(milestone.effect_power) + " tree plots")
			unlock_trees_in_gui()
		"add_click_power_tree":
			%SaveManager.save_data.wood_per_click += milestone.effect_power
			print("Increased wood click power by " + str(milestone.effect_power) + " to a total of " + str(%SaveManager.save_data.wood_per_click))
		"offline_income_tree":
			%SaveManager.save_data.wood_per_time_cycle += milestone.effect_power
			print("Increased click power by " + str(milestone.effect_power) + " to a total of " + str(%SaveManager.save_data.wood_per_time_cycle))
		"unlock_building_sawmill":
			%SaveManager.save_data.buildings["sawmill"]["unlocked"] = true
			unlock_building_buttons()
			print("Unlocked sawmill")
		_:
			print("Unknown effect_id \"" + milestone.effect_id + "\" for milestone id \"" + milestone.id + "\"")
	





func _on_sawmill_gui_resources_update(_resource_id):
	update_resource_gui()


func _on_audio_stream_player_finished():
	#var audio_stream_player = music.get_children().pick_random()
	#current_audio_stream_player.volume_db = -30
	#current_audio_stream_player.play()
	pass

