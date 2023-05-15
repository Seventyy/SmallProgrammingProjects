class_name CluesLabel extends Label

@onready var player_entries: VBoxContainer = %PlayerEntries

var player_levels:Dictionary

func _process(delta: float) -> void:
	print(player_levels)

func _ready() -> void:
	GlobalSignals.player_level_updated.connect(on_player_level_updated)
	GlobalSignals.player_deleted.connect(on_player_deleted)

func on_player_deleted(node:Node) -> void:
	player_levels.erase(node)

func on_player_level_updated(node:Node, new_level:int) -> void:
	if not player_levels.has(node):
		player_levels[node] = new_level


func update_label() -> void:
	text = "Clues: " + str(calculate_clues())

func calculate_clues() -> int:
	var running_sum:int
	
	for i in player_entries.get_children():
		if i is HSplitContainer:
			running_sum += i.get_child(1).selected
	
	return running_sum
	
