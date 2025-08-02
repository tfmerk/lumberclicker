extends Control


signal resources_update(resource_id: String)


@onready var get_wood_button = $GetWoodButton


@onready var wood_spawns = $WoodSpawns
@onready var wood_items = $WoodItems
@onready var wood_amount_slider = $WoodAmountSlider
@onready var wood_amount_label = $WoodAmountSlider/WoodAmountLabel


const SLIDER_MAX_VALUE = 20

var spawns: Array[Node]
var wood_item = preload("res://Sawmill/sawmill_wood.tscn")



func _ready():
	pass





func _on_get_wood_button_button_down():
	var spawns = wood_spawns.get_children()
	var wood_to_add = wood_amount_slider.value
	%SaveManager.save_data.resources["wood"] -= wood_to_add
	resources_update.emit("wood")
	
	for n in wood_to_add:
		var w = wood_item.instantiate()
		w.global_position = spawns.pick_random().global_position
		if not w.wood_was_clicked.is_connected(_on_wood_was_clicked):
			w.wood_was_clicked.connect(_on_wood_was_clicked)
		wood_items.add_child(w)
	print("wood_items size: " + str(wood_items.get_children().size()))



func _on_visibility_changed():
	if self.visible:
		var wood_count = %SaveManager.save_data.resources["wood"]
		if wood_count < SLIDER_MAX_VALUE:
			wood_amount_slider.max_value = wood_count
		else:
			wood_amount_slider.max_value = SLIDER_MAX_VALUE
		wood_amount_slider.value = 0
		wood_amount_label.text = str(wood_amount_slider.value) + " / " + str(wood_amount_slider.max_value)



func _on_wood_amount_slider_value_changed(value):
	wood_amount_label.text = str(wood_amount_slider.value) + " / " + str(wood_amount_slider.max_value)



func _on_wood_was_clicked():
	%SaveManager.save_data.resources["plank"] += 1
	resources_update.emit("plank")




