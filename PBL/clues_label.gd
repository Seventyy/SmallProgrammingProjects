class_name CluesLabel extends Label

var room_difficulty:float
var player_data:Dictionary

func _ready() -> void:
	GlobalSignals.room_difficulty_updated.connect(on_room_difficulty_updated)
	
	GlobalSignals.player_skill_updated.connect(on_player_skill_updated)
	GlobalSignals.player_age_updated.connect(on_player_age_updated)
	
	GlobalSignals.player_deleted.connect(on_player_deleted)
	update_label()
	
func on_room_difficulty_updated(new_difficulty:int) -> void:
	room_difficulty = new_difficulty / 1000.0
	update_label()

func on_player_skill_updated(instance_id:int, new_skill:int) -> void:
	if not player_data.has(instance_id):
		player_data[instance_id] = {"skill": -1, "age": -1}
	player_data[instance_id]["skill"] = new_skill
	update_label()

func on_player_age_updated(instance_id:int, new_age:int) -> void:
	if not player_data.has(instance_id):
		player_data[instance_id] = {"skill": -1, "age": -1}
	player_data[instance_id]["age"] = new_age
	update_label()

func on_player_deleted(instance_id:int) -> void:
	player_data.erase(instance_id)
	update_label()


func update_label() -> void:
	var prompts:int = calculate_clues()
	if prompts == -1:
		text = "Clues: ?"
	else:
		text = "Clues: " + str(prompts)

func calculate_clues() -> int:
	if player_data.size() == 0 or room_difficulty == 0:
		return -1
	
	var skill_age_sum:int
	for player in player_data.values():
		if player["skill"] == -1 or player["age"] == -1:
			return -1
		skill_age_sum += player["skill"] * player["age"]
	
	return round(room_difficulty * skill_age_sum / pow(player_data.size(), 2.3))

