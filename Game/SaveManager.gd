extends Node


const SAVE_PATH: String = "user://save_data.res"

var save_data: SaveData


func _ready():
	load_game()



#
# Saves the data to the save file.
#
func save_game():
	save_data.last_time_played = Time.get_unix_time_from_system()
	ResourceSaver.save(save_data, SAVE_PATH)
	print("Game saved as Resource.")



#
# Loads the data from the save file.
# If there's no save file a new one is created.
#
func load_game():
	if ResourceLoader.exists(SAVE_PATH):
		save_data = ResourceLoader.load(SAVE_PATH) as SaveData
		print("Game loaded from Resource.")
	else:
		save_data = SaveData.new()
		save_data.last_time_played = Time.get_unix_time_from_system()
		print("New SaveData created.")
