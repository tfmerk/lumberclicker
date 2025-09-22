extends Control

signal unlocked_slot
signal resources_update()

@onready var trees = $Trees




func _ready():
	unlock_trees_in_gui()





func unlock_trees_in_gui() -> void:
	var tree_nodes = trees.get_children()
	var tree_counter = 0
	var trees_to_unlock = SaveManager.save_data.unlocked_economy["trees"]
	print("trees to unlock: " + str(trees_to_unlock))
	
	for tree_node in tree_nodes:
		tree_node.visible = false
	
	for tree_node in tree_nodes:
		if not tree_node.tree_cut_down.is_connected(_on_tree_tree_cut_down):
			tree_node.tree_cut_down.connect(_on_tree_tree_cut_down)
		if tree_counter < trees_to_unlock: 
			tree_node.visible = true
		tree_counter += 1
	print("Unlocked trees: " + str(trees_to_unlock))







func _on_tree_tree_cut_down(wood_amount):
	SaveManager.save_data.resources["wood"] += wood_amount
	resources_update.emit()



func _on_game_container_unlock_trees(amount):
	unlock_trees_in_gui()
