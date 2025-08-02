extends Control



@onready var milestone_label = $MilestoneLabel
@onready var descriptionAndCosts = $DescriptionAndCosts
@onready var unlock_button = $UnlockButton
@onready var animation_player = $AnimationPlayer





#
# Signal that's emitted upon clicking the unlock button.
#
signal try_unlock_milestone(milestone: MilestoneResource)



#
# Sets GUI elements with initial values
#
func _ready():
	var milestone = %MilestoneManager.get_active_milestone()
	update_gui(milestone)



#
# Updates the GUI
#
func update_gui(milestone: MilestoneResource) -> void:
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
	var milestone = %MilestoneManager.get_active_milestone()
	if milestone != null:
		try_unlock_milestone.emit(milestone)
		var newMilestone = %MilestoneManager.get_active_milestone()
		if milestone == newMilestone:
			animation_player.play("not_enough_resources")
			await animation_player.animation_finished
		else:
			animation_player.play("on_button_click")
			await animation_player.animation_finished
	else:
		print("no milestone to unlock")





func set_active_milestone() -> void:
	var milestone = %MilestoneManager.get_active_milestone()
	update_gui(milestone)


