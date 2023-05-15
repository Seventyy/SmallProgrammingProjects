class_name CluesLabel extends Label

@onready var player_entries: VBoxContainer = %PlayerEntries

func update_label() -> void:
	text = "Clues: " + str(calculate_clues())

func calculate_clues() -> int:
	var running_sum:int
	
	for i in player_entries.get_children():
		if i is HSplitContainer:
			running_sum += i.get_child(1).selected
	
	return running_sum
	
