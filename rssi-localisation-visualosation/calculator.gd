@tool 
extends Node2D

## references
@onready var access_point_a:AccessPoint = $AccessPointA
@onready var access_point_b:AccessPoint = $AccessPointB
@onready var access_point_c:AccessPoint = $AccessPointC

## rrsi to distance variables
@export_category("RRSI to Distance Variables")
@export var intercept:float = -64
@export var path_loss_exponent:float = 3

@export_category("Visibility Toggles")
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

@export_category("Resets")
@export var reset_positions:bool:
	set(val):
		access_point_a.position = Vector2(6000,4000)
		access_point_b.position = Vector2(6000,0)
		access_point_c.position = Vector2(0,2000)
@export var reset_strength:bool:
	set(val):
		access_point_a.strength = 1500
		access_point_b.strength = 1500
		access_point_c.strength = 1500
		reset_handles()
@export var redraw:bool:
	set(val):
		queue_redraw()

func reset_handles() -> void:
	access_point_a.handle.position = Vector2.UP * access_point_a.strength
	access_point_b.handle.position = Vector2.UP * access_point_b.strength
	access_point_c.handle.position = Vector2.UP * access_point_c.strength

@onready var reference_path:PackedVector2Array = PackedVector2Array([
	Vector2(4000, 4000),
	Vector2(3000, 4000),
	Vector2(2293, 3708),
	Vector2(2000, 3000),
	Vector2(2000, 2000),
	Vector2(1708, 1293),
	Vector2(1000, 1000),
	Vector2(0, 1000),
	Vector2(0, 0),
	Vector2(1000, 0),
	Vector2(2000, 0),
	Vector2(3000, 0),
	Vector2(4000, 0),
	Vector2(5000, 134),
	Vector2(5866, 1000),
	Vector2(6000, 2000),
	Vector2(5866, 3000),
	Vector2(5000, 3866),
])

func rssi_to_distance(strength:float) -> float:
	return pow(10,((strength-intercept)/(-10*path_loss_exponent)))

func calculate_intersections(circle1:AccessPoint, circle2:AccessPoint) -> Array[Vector2]:
	#circle1.position.x, circle1.position.y, circle1.strength = circle1
	#circle2.position.x, circle2.position.y, circle2.strength = circle2
	
	var d:float = sqrt((circle2.position.x - circle1.position.x)**2 + (circle2.position.y - circle1.position.y)**2)
	
	## proporional outside, this same (broken) proportional inside
	#if d > circle1.strength + circle2.strength or d < abs(circle1.strength - circle2.strength):
		#return [
			#circle1.position + circle1.position.direction_to(circle2.position) * \
			#circle1.strength / (circle1.strength + circle2.strength) * \
			#circle1.position.distance_to(circle2.position)
		#]
	
	## proporional outside, closest two inside
	#if d > circle1.strength + circle2.strength:
		#return [
			#circle1.position + circle1.position.direction_to(circle2.position) * \
			#circle1.strength / (circle1.strength + circle2.strength) * \
			#circle1.position.distance_to(circle2.position)
		#]
	#elif d < abs(circle1.strength - circle2.strength):
		#var size_sign:int = 1 if circle1.strength < circle2.strength else -1
		#return [
			#circle1.position + \
			#circle1.position.direction_to(circle2.position) * -size_sign * circle1.strength,
			#circle2.position + \
			#circle2.position.direction_to(circle1.position) * size_sign * circle2.strength
		#] 
	
	## newest, proportional both inside and outside
	var is_inside:bool = d < abs(circle1.strength - circle2.strength)
	var is_outside:bool = d > circle1.strength + circle2.strength
	
	if is_inside or is_outside:
		if is_inside:
			var size_sign:int = 1 if circle1.strength < circle2.strength else -1
			if is_inside == false:
				size_sign = 1
			var circle1_near:Vector2 = \
				circle1.position + circle1.position.direction_to(circle2.position) * -size_sign * circle1.strength
			var circle2_near:Vector2 = \
				circle2.position + circle2.position.direction_to(circle1.position) * size_sign * circle2.strength
			
			return [
				circle1_near + circle1_near.direction_to(circle2_near) * \
				circle1.strength / (circle1.strength + circle2.strength) * \
				circle1_near.distance_to(circle2_near)
			]
			## proportional other way
			#return [
				#circle2_near + circle2_near.direction_to(circle1_near) * \
				#circle1.strength / (circle1.strength + circle2.strength) * \
				#circle1_near.distance_to(circle2_near)
			#]
			
		elif is_outside:
			return [
				circle1.position + circle1.position.direction_to(circle2.position) * \
				circle1.strength / (circle1.strength + circle2.strength) * \
				circle1.position.distance_to(circle2.position)
			]
	
	## intersecting circles 
	var a:float = (circle1.strength**2 - circle2.strength**2 + d**2) / (2 * d)
	var h:float = sqrt(circle1.strength**2 - a**2)
	
	var x2:float = circle1.position.x + a * (circle2.position.x - circle1.position.x) / d
	var y2:float = circle1.position.y + a * (circle2.position.y - circle1.position.y) / d
	
	var x3:float = x2 + h * (circle2.position.y - circle1.position.y) / d
	var y3:float = y2 - h * (circle2.position.x - circle1.position.x) / d
	
	var x4:float = x2 - h * (circle2.position.y - circle1.position.y) / d
	var y4:float = y2 + h * (circle2.position.x - circle1.position.x) / d
	
	return [Vector2(x3, y3), Vector2(x4, y4)]

func calculate_distance(point1: Vector2, point2: Vector2) -> float:
	return point1.distance_to(point2)

func calculate_perimeter(points:Array[Vector2]) -> float:
	return \
		calculate_distance(points[0], points[1]) + \
		calculate_distance(points[1], points[2]) + \
		calculate_distance(points[2], points[0])

func calculate_smallest_perimeter_triplet(
		intersections_ab: Array[Vector2],
		intersections_bc: Array[Vector2],
		intersections_ca: Array[Vector2]
	) -> Array[Vector2]:
	
	var running_minimum:float = INF
	var running_triplet:Array[Vector2]
	for ab in intersections_ab:
		for bc in intersections_bc:
			for ca in intersections_ca:
				var triplet:Array[Vector2] = [ab, bc, ca]
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
	
	var intersections_ab: Array[Vector2] = calculate_intersections(access_point_a, access_point_b)
	var intersections_bc: Array[Vector2] = calculate_intersections(access_point_b, access_point_c)
	var intersections_ca: Array[Vector2] = calculate_intersections(access_point_c, access_point_a)
	
	var all_intersections:Array[Vector2] = \
		intersections_ab + intersections_bc + intersections_ca
	
	var smallest_perimeter_triplet:Array[Vector2] = \
		calculate_smallest_perimeter_triplet(
		intersections_ab, intersections_bc, intersections_ca
	)
	
	var centroid:Vector2 = calculate_centroid( 
		smallest_perimeter_triplet
	)
	
	if show_secondary_intersections:
		for i in all_intersections:
			draw_circle(i, 100, Color.DIM_GRAY)
	
	if show_intersection_pairs:
		if intersections_ab.size() == 2:
			draw_dashed_line(intersections_ab[0], intersections_ab[1], Color.CADET_BLUE, -1, 100)
		if intersections_bc.size() == 2:
			draw_dashed_line(intersections_bc[0], intersections_bc[1], Color.CADET_BLUE, -1, 100)
		if intersections_ca.size() == 2:
			draw_dashed_line(intersections_ca[0], intersections_ca[1], Color.CADET_BLUE, -1, 100)
	
	if show_triplet_triangle:
		draw_polygon(PackedVector2Array(smallest_perimeter_triplet), PackedColorArray([Color.LIGHT_CORAL]))
	
	if show_primary_intersections:
		for i in smallest_perimeter_triplet:
			draw_circle(i, 100, Color.YELLOW)
	
	draw_circle(centroid, 100, Color.GREEN)

