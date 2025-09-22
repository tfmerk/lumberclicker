extends Node


var all_recipes := {
	# sawmill
	"plank_1": preload("res://recipes/sawmill/plank_1.tres"),
	"beam_1": preload("res://recipes/sawmill/beam_1.tres"),
}



func get_unlocked_sawmill_recipes() -> Array:
	return _get_resources_for_ids("sawmill")



func _get_resources_for_ids(key: String) -> Array:
	var unlocked_ids = SaveManager.save_data.unlocked_recipes.get(key, [])
	var resources = []
	for id in unlocked_ids:
		if all_recipes.has(id):
			var res: RecipeResource = all_recipes[id]
			resources.append(res)
	return resources
