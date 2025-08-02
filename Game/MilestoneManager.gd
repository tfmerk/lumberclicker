extends Node

#
# List of all available milestones.
# The list can be edited in the editor.
#
@export var milestones: Array[MilestoneResource] = []





#
# Returns the next milestone from the list that's not unlocked.
# Can return NULL if no locked milestone is found.
#
func get_active_milestone() -> MilestoneResource:
	for milestone in milestones:
		if milestone.id not in %SaveManager.save_data.unlocked_milestone_ids:
			print("new active milestone: " + str(milestone.id))
			return milestone
	print("no active milestone found. looks like all are completed.")
	return null


#
# The passed milestone is added to the save file.
#
func add_completed_milestone(milestone: MilestoneResource) -> void:
	%SaveManager.save_data.unlocked_milestone_ids.append(milestone.id)
	print("added milestone " + str(milestone.id) + " to the completed milestones.")



