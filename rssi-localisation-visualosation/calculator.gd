@tool 
extends Node2D

@onready var access_point_a:AccessPoint = $AccessPointA
@onready var access_point_b:AccessPoint = $AccessPointB
@onready var access_point_c:AccessPoint = $AccessPointC
@onready var resoult:Sprite2D = $Resoult

#@export var strength_a:float:
	#set(val):
		#strength_a = val
		#access_point_a.strength = strength_a
		#queue_redraw()
#@export var strength_b:float:
	#set(val):
		#strength_b = val
		#access_point_b.strength = strength_b
		#queue_redraw()
#@export var strength_c:float:
	#set(val):
		#strength_c = val
		#access_point_c.strength = strength_c
		#queue_redraw()

@export var intercept:float = -64
@export var path_loss_exponent:float = 3

@export var show_reference_path:bool:
	set(val):
		show_reference_path = val
		queue_redraw()
@export var show_intersection_pairs:bool:
	set(val):
		show_intersection_pairs = val
		queue_redraw()
@export var show_triplet_triangle:bool:
	set(val):
		show_triplet_triangle = val
		queue_redraw()
@export var show_secondary_intersections:bool:
	set(val):
		show_secondary_intersections = val
		queue_redraw()
@export var show_primary_intersections:bool:
	set(val):
		show_primary_intersections = val
		queue_redraw()

@export var reset_positions:bool:
	set(val):
		access_point_a.position = Vector2(6000, 4000) 
		access_point_b.position = Vector2(6000, 0)
		access_point_c.position = Vector2(0, 2000)
		#reset_handles()
@export var reset_strength:bool:
	set(val):
		access_point_a.strength = 2000
		access_point_b.strength = 2500
		access_point_c.strength = 4500
		reset_handles()

func reset_handles() -> void:
	access_point_a.handle.position = Vector2.UP * access_point_a.strength
	access_point_b.handle.position = Vector2.UP * access_point_b.strength
	access_point_c.handle.position = Vector2.UP * access_point_c.strength

@onready var reference_path:PackedVector2Array = PackedVector2Array([
	Vector2(2000, 0),
	Vector2(3000, 0),
	Vector2(3707, 292),
	Vector2(4000, 1000),
	Vector2(4000, 2000),
	Vector2(4292, 2707),
	Vector2(5000, 3000),
	Vector2(6000, 3000),
	Vector2(6000, 4000),
	Vector2(5000, 4000),
	Vector2(4000, 4000),
	Vector2(3000, 4000),
	Vector2(2000, 4000),
	Vector2(1000, 3866),
	Vector2(134, 3000),
	Vector2(0, 2000),
	Vector2(134, 1000),
	Vector2(1000, 134),
])

#region rssi classes
#class RssiData:
	#var data:Array[LapData]
	#
	#
#
#class LapData:
	#var access_point_a:Array[int]
	#var access_point_b:Array[int] 
	#var access_point_c:Array[int] 
#endregion
#region console_print
@export var print_calculations:bool:
	set(val):
		print("\nall intersections:\n",
			calculate_all_intersections([access_point_a, access_point_b, access_point_c])
			)
		print("\nthree closest intersections:\n", 
			calculate_smallest_perimeter_triplet(
			calculate_all_intersections([access_point_a, access_point_b, access_point_c])
			))
		print("\navrage of three closest intersections:\n", 
			calculate_centroid(
			calculate_smallest_perimeter_triplet(
			calculate_all_intersections([access_point_a, access_point_b, access_point_c])
			)))
		queue_redraw()
#endregion
#region old_code
#func calculate_all_intersections(circles: Array[AccessPoint]) -> Array[Vector2]:
	#var intersections:Array[Vector2]
	#for i in range(len(circles)):
		#for j in range(i + 1, len(circles)):
			#var intersection_pair:Array[Vector2] = calculate_intersections(circles[i], circles[j])
			#if not intersection_pair.is_empty():
				#if not intersections.has(intersection_pair[0]):
					#intersections.append(intersection_pair[0])
				#if not intersections.has(intersection_pair[1]):
					#intersections.append(intersection_pair[1])
	#return intersections
#
#func find_smallest_distance(points: Array[Vector2]) -> Array[Vector2]:
	#var smallest_distance:float = INF
	#var smallest_points:Array[Vector2] = []
	#for i in range(len(points)):
		#for j in range(i + 1, len(points)):
			#for k in range(j + 1, points.size()):
				#var total_distance:float = calculate_total_distance(points[i], points[j], points[k])
				#if total_distance < smallest_distance:
					#smallest_distance = total_distance
					#smallest_points = [points[i], points[j], points[k]]
	#return smallest_points
#endregion

func rssi_to_distance(strength:float) -> float:
	return pow(10,((strength-intercept)/(-10*path_loss_exponent)))

func calculate_intersections(circle1:AccessPoint, circle2:AccessPoint) -> Array[Vector2]:
#  circle1.position.x, circle1.position.y, circle1.strength = circle1
#  circle2.position.x, circle2.position.y, circle2.strength = circle2
	var d:float = sqrt((circle2.position.x - circle1.position.x)**2 + (circle2.position.y - circle1.position.y)**2)
	
	if d > circle1.strength + circle2.strength or d < abs(circle1.strength - circle2.strength):
		return [
			circle1.position + circle1.position.direction_to(circle2.position) * circle1.strength,
			circle2.position + circle2.position.direction_to(circle1.position) * circle2.strength
			]

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
	
	intersections += calculate_intersections(circles[0], circles[1])
	intersections += calculate_intersections(circles[1], circles[2])
	intersections += calculate_intersections(circles[2], circles[0])
	
	return intersections

func calculate_distance(point1: Vector2, point2: Vector2) -> float:
	return point1.distance_to(point2)

func calculate_perimeter(points:Array[Vector2]) -> float:
	return \
		calculate_distance(points[0], points[1]) + \
		calculate_distance(points[1], points[2]) + \
		calculate_distance(points[2], points[0])

func calculate_smallest_perimeter_triplet(points: Array[Vector2]) -> Array[Vector2]:
	var valid_triplets:Array[Vector2] = [
		points[0], points[2], points[4],
		points[0], points[2], points[5],
		points[0], points[3], points[4],
		points[0], points[3], points[5],
		points[1], points[2], points[4],
		points[1], points[2], points[5],
		points[1], points[3], points[4],
		points[1], points[3], points[5],
	]
	
	var running_minimum:float = INF
	var running_triplet:Array[Vector2]
	for i in range(0,24,3):
		var triplet:Array[Vector2] = [
			valid_triplets[i],
			valid_triplets[i+1],
			valid_triplets[i+2],
		]
		var perimeter:float = calculate_perimeter(triplet)
		if perimeter < running_minimum:
			running_minimum = perimeter
			running_triplet = triplet
	
	return running_triplet

func calculate_centroid(points: Array[Vector2]) -> Vector2:
	return (points[0] + points[1] + points[2]) / 3

func _draw() -> void:
	var reference_path_closed:PackedVector2Array = Array(reference_path) + [reference_path[0]]
	
	if show_reference_path:
		draw_polyline(reference_path_closed, Color.GREEN)
	
	var all_intersections:Array[Vector2] = \
		calculate_all_intersections([access_point_a, access_point_b, access_point_c])
	
	var smallest_perimeter_triplet:Array[Vector2] = \
		calculate_smallest_perimeter_triplet(
		all_intersections
	)
	
	var centroid:Vector2 = calculate_centroid( 
		smallest_perimeter_triplet
	)
	
	if show_secondary_intersections:
		for i in all_intersections:
			draw_circle(i, 100, Color.DIM_GRAY)
	
	if show_intersection_pairs:
		for i in range(0,6,2):
			draw_dashed_line(all_intersections[i], all_intersections[i+1], Color.AQUA, -1, 100)
	
	if show_triplet_triangle:
		draw_polygon(PackedVector2Array(smallest_perimeter_triplet), PackedColorArray([Color.LIGHT_CORAL]))
	
	if show_primary_intersections:
		for i in smallest_perimeter_triplet:
			draw_circle(i, 100, Color.YELLOW)
	
	draw_circle(centroid, 100, Color.GREEN)

