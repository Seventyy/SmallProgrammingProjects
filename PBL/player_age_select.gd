extends OptionButton

func _ready() -> void:
	item_selected.connect(on_item_selected)
	GlobalSignals.player_age_updated.emit(
		owner.get_instance_id(), -1)

func on_item_selected(index:int) -> void:
	GlobalSignals.player_age_updated.emit(
		owner.get_instance_id(), get_item_id(index))
