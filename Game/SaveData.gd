@icon("res://icon.svg")

extends Resource
class_name SaveData

# --------------------------------------------------------------------------------------------------
#
# Settings
#
# --------------------------------------------------------------------------------------------------

@export var volume_master: float = 1.0
@export var volume_sfx: float = 1.0


# --------------------------------------------------------------------------------------------------
#
# Materials, resources, in-game stuff a player has
#
# --------------------------------------------------------------------------------------------------

@export var resources: Dictionary = {
	# -- Basic
	"wood": 1000,
	# -- Mine
	"stone": 0,
	"coal": 0,
	"iron_ore": 0,
	"copper_ore": 0,
	"silver_ore": 0,
	"gold_ore": 0,
	"gems": 0,
	# -- Sawmill
	"plank": 0,
	"beam": 0,
	"timber_frame": 0,
	# -- Forge
	"brick": 0,
	"iron_ingot": 0,
	"copper_ingot": 0,
	"silver_ingot": 0,
	"gold_ingot": 0,
}

@export var unlocked_economy: Dictionary = {
	"trees": 3 # amount of trees unlocked
}

@export var buildings: Dictionary = {
	"sawmill": {
		"unlocked": false
	}
}

@export var wood_per_time_cycle: int = 0
@export var wood_per_click: int = 1

@export var unlocked_milestone_ids: Array = []
@export var last_time_played: int = 0





