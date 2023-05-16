extends OptionButton

func _ready() -> void:
	item_selected.connect(on_item_selected)

func on_item_selected(index:int) -> void:
	GlobalSignals.room_difficulty_updated.emit(
		get_item_id(index))
