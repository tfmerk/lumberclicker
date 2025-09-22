extends Control



@onready var milestone_label = $MilestoneLabel
@onready var descriptionAndCosts = $DescriptionAndCosts
@onready var unlock_button = $UnlockButton
@onready var animation_player = $AnimationPlayer




#
# Sets GUI elements with initial values
#
func _ready():
	update_gui()



#
# Updates the GUI
#
func update_gui() -> void:
	var milestone = %MilestoneManager.get_active_milestone() as MilestoneResource
	if milestone != null:
		milestone_label.text = milestone.name
		descriptionAndCosts.text = milestone.description + "\n\n\n"
		descriptionAndCosts.text += "Rewards: " + milestone.effect_description + "\n\n"
		descriptionAndCosts.text += "Costs: "
		
		var costsList: Array[String] = []
		for key in milestone.cost:
			var val: int = milestone.cost[key]
			costsList.append(str(val) + "x " + key)
		costsList.reverse()
		descriptionAndCosts.text += ", ".join(costsList)
	else:
		print("no milestone")



#
# Called upon clicking the unlock button.
# Emmits a signal.
#
func _on_unlock_button_button_down():
	print("pressed unlock button")
	var milestone = %MilestoneManager.get_active_milestone() as MilestoneResource
	if milestone != null:
		if milestone.can_unlock(SaveManager.save_data["resources"]):
			%MilestoneManager.unlock_milestone(milestone)
			animation_player.play("on_button_click")
			await animation_player.animation_finished
			update_gui()
		else:
			animation_player.play("not_enough_resources")
			await animation_player.animation_finished
	else:
		print("no milestone to unlock")

