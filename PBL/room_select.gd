extends OptionButton

@onready var room_saver:RoomSaver = %RoomSaver

func _ready() -> void:
	item_selected.connect(on_item_selected)
	
	for room in room_saver.rooms:
		add_item(room.name, 0)

func on_item_selected(index:int) -> void:
	GlobalSignals.room_difficulty_updated.emit(
		get_item_id(index))
