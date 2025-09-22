extends TextureButton
class_name RechargeButton

signal button_recharged
signal button_started

@export var recharge_time: float = 3.0

@onready var sprite_2d = $Sprite2
@onready var recharge_timer = $RechargeTimer
@onready var animation_player = $AnimationPlayer
@onready var time_left_label = $TimeLeftLabel

@onready var title = $RecipeControl/Title
@onready var duration = $RecipeControl/Duration
@onready var input = $RecipeControl/HBoxContainer/Input
@onready var output = $RecipeControl/HBoxContainer/Output

@export var selected_recipe: RecipeResource

var is_recharging: bool = false
var time_passed: float = 0.0


@onready var recipe_control = $RecipeControl
@onready var tree = $RecipeControl/RecipeTree



# Called when the node enters the scene tree for the first time.
func _ready():
	recharge_timer.wait_time = recharge_time
	animation_player.play("RESET")
	time_left_label.text = ""
	recipe_control.visible = false
	animation_player.animation_set_next("fade_out", "RESET")
	
	add_items_to_tree()
	update_recipe_gui()



func _process(delta):
	time_passed += delta
	if time_passed >= 1.0:
		time_passed = 0.0
		if recharge_timer.is_stopped() == false:
			time_left_label.text = str(int(recharge_timer.time_left)) + "s"
		else:
			time_left_label.text = ""



func _on_timer_timeout():
	is_recharging = false
	for resource_output_id in selected_recipe.resources_output.keys():
		var amount = selected_recipe.resources_output[resource_output_id]
		SaveManager.save_data.resources[resource_output_id] += amount
	recharge_timer.stop()
	button_recharged.emit()
	animation_player.play("fade_out")


func _on_gui_input(event):
	if is_recharging:
		return
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				_on_left_click()
			MOUSE_BUTTON_RIGHT:
				_on_right_click()



func _on_left_click():
	print("pressed button: " + self.name)
	
	# check if player has enough resources
	var can_pay = true
	for resource_input_id in selected_recipe.resources_input.keys():
		var amount = selected_recipe.resources_input[resource_input_id]
		if SaveManager.save_data.resources[resource_input_id] < amount:
			can_pay = false
			break
	
	if can_pay:
		for resource_input_id in selected_recipe.resources_input.keys():
			var amount = selected_recipe.resources_input[resource_input_id]
			SaveManager.save_data.resources[resource_input_id] -= amount
		print("payed resources!")
	else:
		print("not enough resources!")
		return
	is_recharging = true
	animation_player.play("working")
	recharge_timer.start()
	button_started.emit()


func _on_right_click():
	recipe_control.visible = true
	recipe_control.move_to_front()
	recipe_control.z_index = 1000




func _on_recipe_close_button_pressed():
	recipe_control.visible = false


func _on_recipe_tree_item_selected():
	var item: TreeItem = tree.get_selected()
	if not item:
		return
	
	var recipe: RecipeResource = item.get_metadata(0)
	if recipe and recipe is RecipeResource:
		selected_recipe = recipe
		recharge_timer.wait_time = selected_recipe.duration
		update_recipe_gui()



func update_recipe_gui():
	title.text = selected_recipe.name
	duration.text = "Duration: %d s" % selected_recipe.duration
	
	input.text = "Input:\n"
	for resource_name in selected_recipe.resources_input.keys():
		var amount = selected_recipe.resources_input[resource_name]
		input.text += "%d %s\n" % [amount, resource_name]
	
	output.text = "Output:\n"
	for resource_name in selected_recipe.resources_output.keys():
		var amount = selected_recipe.resources_output[resource_name]
		output.text += "%d %s\n" % [amount, resource_name]



func add_items_to_tree() -> void:
	tree.clear()
	
	var recipes = CraftingRecipesManager.get_unlocked_sawmill_recipes()
	var folder_items: Dictionary = {}
	
	# root folder as fix for "subfolder" bug
	var root_folder_item = tree.create_item()
	root_folder_item.set_text(0, "Recipes")
	
	for recipe: RecipeResource in recipes:
		var folder: String = recipe.tree_folder
		var folder_item: TreeItem
		
		# create new or use existing "folder" items
		if not folder_items.has(folder):
			folder_item = tree.create_item(root_folder_item)
			folder_item.set_text(0, folder)
			folder_items[folder] = folder_item
		else:
			folder_item = folder_items[folder]
		
		# create recipe item beneath folder item
		var recipe_item = tree.create_item(folder_item)
		recipe_item.set_text(0, recipe.name)
		recipe_item.set_metadata(0, recipe)

