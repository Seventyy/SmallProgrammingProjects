@tool
class_name AccessPoint extends Node2D

@onready var handle: Node2D = $Handle
@onready var stength_label: Label = $StengthLabel

@export var calculator:Visualisation

@export var radius:float:
	set(val):
		radius = val
		queue_redraw()
		calculator.queue_redraw()

@export var strength:int:
	set(val):
		strength = val
		stength_label.text = str(strength)
		radius = calculator.rssi_to_distance(strength)

func _draw() -> void:
	draw_arc(Vector2.ZERO, radius, 0, TAU, 96, Color.WHITE)

func _ready() -> void:
	set_notify_transform(true)
	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		calculator.queue_redraw()
