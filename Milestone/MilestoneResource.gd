extends Resource
class_name MilestoneResource


@export var id: String
@export var name: String
@export var description: String
@export var effect_description: String
@export var effect_id: String
@export var effect_power: int
@export var cost: Dictionary


func can_unlock(available_resources: Dictionary) -> bool:
	for resource in cost.keys():
		# If the resource doesn't exist or not enough is available -> fail
		if !available_resources.has(resource) or available_resources[resource] < cost[resource]:
			return false
	return true
