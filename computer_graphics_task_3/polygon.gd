@tool
extends Polygon2D

@export var progress:float:
	set(val):
		progress = val
		polygon = create_circle(20)
		
		var new_polygon = polygon
		new_polygon.set(5, polygon[5] + Vector2(0, val * .4))
		new_polygon.set(6, polygon[6] + Vector2(0, val))
		new_polygon.set(7, polygon[7] + Vector2(0, val * .4))
		polygon = new_polygon

func create_circle(radius:float) -> PackedVector2Array:
	var circle:PackedVector2Array
	for i in 12:
		circle.append((Vector2.UP).rotated(i*TAU/12) * radius)
	return circle
