extends Button

func _ready() -> void:
	button_up.connect(on_button_press)

func on_button_press() -> void:
	GlobalSignals.player_deleted.emit(self)
	owner.queue_free()
