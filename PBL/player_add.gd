extends Button

@export var player_edit:PackedScene
@onready var player_entries: VBoxContainer = %PlayerEntries

func _ready() -> void:
	button_up.connect(on_button_press)

func on_button_press():
	player_entries.add_child(player_edit.instantiate())
	player_entries.move_child(self, player_entries.get_child_count())
