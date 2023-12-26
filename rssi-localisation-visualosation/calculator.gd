@tool 
class_name Calculator extends Node2D

var displacements:Array[PackedVector2Array]
var laps:Array[Lap]
var approximate_path:Array[Vector2]

## references
@onready var access_point_a:AccessPoint = $AccessPointA
@onready var access_point_b:AccessPoint = $AccessPointB
@onready var access_point_c:AccessPoint = $AccessPointC

## rrsi to distance variables
@export_category("RRSI to Distance Variables")
@export var intercept:float = -64:
	set(val):
		intercept = val
		calculate_approximate_path()
		queue_redraw()
@export var path_loss_exponent:float = 3:
	set(val):
		path_loss_exponent = val
		calculate_approximate_path()
		queue_redraw()

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
@export var show_centroid:bool:
	set(val):
		show_centroid = val
		queue_redraw()
@export var show_displasements:bool:
	set(val):
		show_displasements = val
		queue_redraw()
@export var show_approximate_path:bool:
	set(val):
		show_approximate_path = val
		queue_redraw()

@export_category("Resets")
@export var reset_positions:bool:
	set(val):
		access_point_a.position = Vector2(6000,4000)
		access_point_b.position = Vector2(6000,0)
		access_point_c.position = Vector2(0,2000)
@export var reset_radii:bool:
	set(val):
		access_point_a.radius = 1500
		access_point_b.radius = 1500
		access_point_c.radius = 1500
		
		access_point_a.handle.position = Vector2.RIGHT * access_point_a.radius
		access_point_b.handle.position = Vector2.RIGHT * access_point_b.radius
		access_point_c.handle.position = Vector2.RIGHT * access_point_c.radius
@export var redraw:bool:
	set(val):
		queue_redraw()

@export_category("Path approximation")
@export var path_gradient:Gradient

@export var calculate_approximate_path_button:bool:
	set(val):
		calculate_approximate_path()
		queue_redraw()
@export var optimise:bool:
	set(val):
		optimise_path()

## data
class Lap:
	var ap_a_readings:Array[int]
	var ap_b_readings:Array[int]
	var ap_c_readings:Array[int]

func set_laps_data() -> void:
	laps.clear()
	
	var lap_1:Lap = Lap.new()
	var lap_2:Lap = Lap.new()
	var lap_3:Lap = Lap.new()
	var lap_4:Lap = Lap.new()
	
	lap_1.ap_a_readings = [-45, -47, -48, -56, -58, -58, -57, -64, -55, -61, -57, -63, -50, -52, -51, -44, -54, -36]
	lap_2.ap_a_readings = [-39, -48, -51, -55, -54, -45, -53, -63, -58, -61, -56, -62, -47, -48, -52, -41, -50, -36]
	lap_3.ap_a_readings = [-48, -45, -52, -54, -58, -56, -57, -64, -50, -53, -59, -55, -54, -51, -39, -44, -44, -41]
	lap_4.ap_a_readings = [-44, -48, -54, -50, -55, -59, -54, -58, -58, -57, -54, -52, -50, -49, -46, -40, -45, -43]
	
	lap_1.ap_b_readings = [-57, -47, -46, -50, -42, -58, -47, -52, -55, -49, -48, -51, -52, -58, -58, -54, -58, -58]
	lap_2.ap_b_readings = [-60, -53, -51, -43, -54, -54, -39, -52, -51, -53, -51, -49, -53, -53, -51, -54, -56, -51]
	lap_3.ap_b_readings = [-50, -46, -41, -49, -44, -46, -49, -48, -44, -49, -39, -55, -54, -56, -61, -55, -59, -50]
	lap_4.ap_b_readings = [-48, -55, -48, -45, -42, -47, -41, -40, -36, -49, -53, -56, -53, -58, -56, -53, -58, -50]
	
	lap_1.ap_c_readings = [-56, -60, -59, -53, -54, -48, -50, -63, -57, -53, -48, -56, -41, -45, -37, -48, -42, -52]
	lap_2.ap_c_readings = [-59, -54, -50, -49, -52, -49, -55, -56, -58, -53, -56, -58, -47, -40, -34, -48, -51, -52]
	lap_3.ap_c_readings = [-54, -56, -56, -49, -52, -56, -50, -55, -52, -56, -54, -51, -47, -40, -50, -46, -45, -46]
	lap_4.ap_c_readings = [-58, -56, -50, -50, -52, -58, -61, -60, -58, -50, -56, -42, -49, -40, -42, -48, -50, -46]
	
	laps.append(lap_1)
	laps.append(lap_2)
	laps.append(lap_3)
	laps.append(lap_4)

var reference_path:PackedVector2Array = PackedVector2Array([
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

func optimise_path() -> void:
	var running_smallest_error:float = INF
	var running_best_intercept:float
	var running_best_path_loss_exponent:float
	for i in range(-60, -40, 1):
		for p in range(10, 50, 1):
			var new_p:float = p / 10
			intercept = i
			path_loss_exponent = new_p
			var error:float = calculate_error()
			#print(error)
			if error < running_smallest_error:
				running_smallest_error = error
				running_best_intercept = i
				running_best_path_loss_exponent = new_p
		print(i)
	intercept = running_best_intercept
	path_loss_exponent = running_smallest_error
	print("smallest error:", running_smallest_error)

## optimisation
func calculate_error() -> float:
	var running_sum:float
	var denominator:int
	for i in reference_path.size():
		for j in laps.size():
			running_sum += reference_path[i].distance_to(displacements[i][j])
			denominator += 1
	return running_sum / denominator

## path approximation
func calculate_displasements() -> void:
	set_laps_data()
	displacements.clear()
	for i in reference_path.size():
		var resoults:Array[Vector2] 
		
		for j in laps.size():
			access_point_a.strength = laps[j].ap_a_readings[i]
			access_point_b.strength = laps[j].ap_b_readings[i]
			access_point_c.strength = laps[j].ap_c_readings[i]
			
			resoults.append(get_centroid())
		
		displacements.append(PackedVector2Array(resoults))

func calculate_approximate_path() -> void:
	calculate_displasements()
	approximate_path.clear()
	for d in displacements:
		var running_avarage:Vector2
		for v in d:
			running_avarage += v
		approximate_path.append(running_avarage/4)

func rssi_to_distance(strength:float) -> float:
	#return 400.5
	return pow(10,((strength-intercept)/(-10*path_loss_exponent))) * 1_000

## centroid calculations
func calculate_intersections(circle1:AccessPoint, circle2:AccessPoint) -> Array[Vector2]:
	#circle1.position.x, circle1.position.y, circle1.radius = circle1
	#circle2.position.x, circle2.position.y, circle2.radius = circle2
	
	var d:float = sqrt((circle2.position.x - circle1.position.x)**2 + (circle2.position.y - circle1.position.y)**2)
	
	## proporional outside, this same (broken) proportional inside
	#if d > circle1.radius + circle2.radius or d < abs(circle1.radius - circle2.radius):
		#return [
			#circle1.position + circle1.position.direction_to(circle2.position) * \
			#circle1.radius / (circle1.radius + circle2.radius) * \
			#circle1.position.distance_to(circle2.position)
		#]
	
	## proporional outside, closest two inside
	#if d > circle1.radius + circle2.radius:
		#return [
			#circle1.position + circle1.position.direction_to(circle2.position) * \
			#circle1.radius / (circle1.radius + circle2.radius) * \
			#circle1.position.distance_to(circle2.position)
		#]
	#elif d < abs(circle1.radius - circle2.radius):
		#var size_sign:int = 1 if circle1.radius < circle2.radius else -1
		#return [
			#circle1.position + \
			#circle1.position.direction_to(circle2.position) * -size_sign * circle1.radius,
			#circle2.position + \
			#circle2.position.direction_to(circle1.position) * size_sign * circle2.radius
		#] 
	
	## newest, proportional both inside and outside
	var is_inside:bool = d < abs(circle1.radius - circle2.radius)
	var is_outside:bool = d > circle1.radius + circle2.radius
	
	if is_inside or is_outside:
		if is_inside:
			var size_sign:int = 1 if circle1.radius < circle2.radius else -1
			if is_inside == false:
				size_sign = 1
			var circle1_near:Vector2 = \
				circle1.position + circle1.position.direction_to(circle2.position) * -size_sign * circle1.radius
			var circle2_near:Vector2 = \
				circle2.position + circle2.position.direction_to(circle1.position) * size_sign * circle2.radius
			
			return [
				circle1_near + circle1_near.direction_to(circle2_near) * \
				circle1.radius / (circle1.radius + circle2.radius) * \
				circle1_near.distance_to(circle2_near)
			]
			## proportional other way
			#return [
				#circle2_near + circle2_near.direction_to(circle1_near) * \
				#circle1.radius / (circle1.radius + circle2.radius) * \
				#circle1_near.distance_to(circle2_near)
			#]
			
		elif is_outside:
			return [
				circle1.position + circle1.position.direction_to(circle2.position) * \
				circle1.radius / (circle1.radius + circle2.radius) * \
				circle1.position.distance_to(circle2.position)
			]
	
	## intersecting circles 
	var a:float = (circle1.radius**2 - circle2.radius**2 + d**2) / (2 * d)
	var h:float = sqrt(circle1.radius**2 - a**2)
	
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

func get_centroid() -> Vector2:
	return calculate_centroid( 
		calculate_smallest_perimeter_triplet(
			calculate_intersections(access_point_a, access_point_b),
			calculate_intersections(access_point_b, access_point_c),
			calculate_intersections(access_point_c, access_point_a)
		)
	)

## drawing
func _draw() -> void:
	#var reference_path_closed:PackedVector2Array = Array(reference_path) + [reference_path[0]]
	
	if show_reference_path:
		draw_polyline(reference_path, Color.DEEP_PINK)
		draw_circle(reference_path[0], 10, Color.DEEP_PINK)
	
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
		for i in all_intersections.filter(func(point):
			return not point in smallest_perimeter_triplet):
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
	
	if show_centroid:
		draw_circle(centroid, 100, Color.GREEN)
		
	#for i in 1:
	if show_displasements:
		for i in reference_path.size():
			for j in laps.size():
				var color:Color = path_gradient.sample(1.0*i/reference_path.size()).darkened(0.2*j)
				draw_line(reference_path[i], displacements[i][j], color)
				draw_circle(displacements[i][j], 35, color)
	
	if show_approximate_path:
		draw_polyline(approximate_path, Color.YELLOW, 50)
