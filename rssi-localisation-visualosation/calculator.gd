@tool 
extends Node2D

@onready var access_point_a:AccessPoint = $AccessPointA
@onready var access_point_b:AccessPoint = $AccessPointB
@onready var access_point_c:AccessPoint = $AccessPointC
@onready var resoult:Sprite2D = $Resoult

@export var strength_a:float:
	set(val):
		strength_a = val
		access_point_a.strength = strength_a
		queue_redraw()
@export var strength_b:float:
	set(val):
		strength_b = val
		access_point_b.strength = strength_b
		queue_redraw()
@export var strength_c:float:
	set(val):
		strength_c = val
		access_point_c.strength = strength_c
		queue_redraw()

@export var reset_positions:bool:
	set(val):
		access_point_a.position = Vector2(60, 40) 
		access_point_b.position = Vector2(60, 0)
		access_point_c.position = Vector2(0, 20)

@export var print_calculations:bool:
	set(val):
		print("\nall intersections:\n",
			calculate_all_intersections([access_point_a, access_point_b, access_point_c])
			)
		print("\nthree closest intersections:\n", 
			find_smallest_distance(
			calculate_all_intersections([access_point_a, access_point_b, access_point_c])
			))
		print("\navrage of three closest intersections:\n", 
			approximate_loaction(
			find_smallest_distance(
			calculate_all_intersections([access_point_a, access_point_b, access_point_c])
			)))
		queue_redraw()

func calculate_intersections(circle1:AccessPoint, circle2:AccessPoint) -> Array[Vector2]:
#  circle1.position.x, circle1.position.y, circle1.strength = circle1
#  circle2.position.x, circle2.position.y, circle2.strength = circle2
	var d:float = sqrt((circle2.position.x - circle1.position.x)**2 + (circle2.position.y - circle1.position.y)**2)

	if d > circle1.strength + circle2.strength or d < abs(circle1.strength - circle2.strength):
		return []

	var a:float = (circle1.strength**2 - circle2.strength**2 + d**2) / (2 * d)
	var h:float = sqrt(circle1.strength**2 - a**2)
	
	var x2:float = circle1.position.x + a * (circle2.position.x - circle1.position.x) / d
	var y2:float = circle1.position.y + a * (circle2.position.y - circle1.position.y) / d
	
	var x3:float = x2 + h * (circle2.position.y - circle1.position.y) / d
	var y3:float = y2 - h * (circle2.position.x - circle1.position.x) / d
	
	var x4:float = x2 - h * (circle2.position.y - circle1.position.y) / d
	var y4:float = y2 + h * (circle2.position.x - circle1.position.x) / d

	return [Vector2(x3, y3), Vector2(x4, y4)]

func calculate_all_intersections(circles: Array[AccessPoint]) -> Array[Vector2]:
	var intersections:Array[Vector2]
	for i in range(len(circles)):
		for j in range(i + 1, len(circles)):
			var intersection_pair:Array[Vector2] = calculate_intersections(circles[i], circles[j])
			if not intersection_pair.is_empty():
				if not intersections.has(intersection_pair[0]):
					intersections.append(intersection_pair[0])
				if not intersections.has(intersection_pair[1]):
					intersections.append(intersection_pair[1])
	return intersections

func calculate_distance(point1: Vector2, point2: Vector2) -> float:
	return point1.distance_to(point2)

func calculate_total_distance(point1: Vector2, point2: Vector2, point3: Vector2) -> float:
	return \
		calculate_distance(point1, point2) + \
		calculate_distance(point2, point3) + \
		calculate_distance(point3, point1)

func find_smallest_distance(points: Array[Vector2]) -> Array[Vector2]:
	var smallest_distance:float = INF
	var smallest_points:Array[Vector2] = []
	for i in range(len(points)):
		for j in range(i + 1, len(points)):
			for k in range(j + 1, points.size()):
				var total_distance:float = calculate_total_distance(points[i], points[j], points[k])
				if total_distance < smallest_distance:
					smallest_distance = total_distance
					smallest_points = [points[i], points[j], points[k]]
	return smallest_points

func approximate_loaction(points: Array[Vector2]) -> Vector2:
	return (points[0] + points[1] + points[2]) / 3

func _draw() -> void:	
	for i in \
	calculate_all_intersections([access_point_a, access_point_b, access_point_c]):
		draw_circle(i, 1, Color.SKY_BLUE)
	
	for i in \
	find_smallest_distance(
	calculate_all_intersections([access_point_a, access_point_b, access_point_c])):
		draw_circle(i, 1, Color.YELLOW)
	
	draw_circle(
		approximate_loaction(
		find_smallest_distance(
		calculate_all_intersections([access_point_a, access_point_b, access_point_c])
		)), 1, Color.GREEN)
