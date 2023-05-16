class_name CluesLabel extends Label


var player_levels:Dictionary

func _ready() -> void:
	GlobalSignals.player_level_updated.connect(on_player_level_updated)
	GlobalSignals.player_deleted.connect(on_player_deleted)

func on_player_deleted(instance_id:int) -> void:
	player_levels.erase(instance_id)
	update_label()

func on_player_level_updated(instance_id:int, new_level:int) -> void:
	player_levels[instance_id] = new_level
	update_label()

func update_label() -> void:
	text = "Clues: " + str(calculate_clues())

func calculate_clues() -> int:
	var running_sum:int
	
	for i in player_levels.values():
		running_sum += i
	
	return running_sum
	
