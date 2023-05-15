extends Button

func _ready() -> void:
	button_up.connect(on_button_press)

func on_button_press():
	owner.queue_free()
