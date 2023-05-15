extends OptionButton

@onready var clues_label: CluesLabel = %CluesLabel

func _ready() -> void:
	ready.connect(clues_label.update_label())
