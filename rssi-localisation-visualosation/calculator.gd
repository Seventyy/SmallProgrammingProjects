@tool 
class_name Calculator extends Node2D

const a_position:Vector2 = Vector2(6000,4000)
const b_position:Vector2 = Vector2(0,2000)
const c_position:Vector2 = Vector2(6000,0)

## rrsi to distance variables
@export_category("RRSI to Distance Variables")
@export var intercept:float = -64
@export var path_loss_exponent:float = 3

@export_category("Visibility Toggles")
@export var show_reference_path:bool
@export var show_approximations:bool
@export var show_approximate_path:bool

@export_category("Resets")
@export var redraw:bool:
	set(val):
		queue_redraw()

@export_category("Path approximation")
@export var path_gradient:Gradient

@export var optimise:bool:
	set(val):
		optimise_path()

## data
class Lap:
	var ap_a_readings:Array[int]
	var ap_b_readings:Array[int]
	var ap_c_readings:Array[int]

func get_laps_data() -> Array[Lap]:
	var laps:Array[Lap]
	
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
	
	return laps

func get_reference_path() -> PackedVector2Array:
	return PackedVector2Array([
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
	var laps_data:Array[Lap] = get_laps_data()
	var approximations:Array[PackedVector2Array] = get_approximations(laps_data)
	
	var running_smallest_error_sum:float = INF
	var running_best_intercept:float
	var running_best_path_loss_exponent:float
	
	for i in range(-280, -30, 1):
		for p in range(10, 50, 1):
		#for p in range(10, 50, 1).map(func(n:float) -> float: return n / 10.0):
		#print([1, 2, 3].map(func(number): return -number)) 
			p = p / 10
			
			intercept = i
			path_loss_exponent = p
			
			var error_sum:float = calculate_error_sum(approximations)
			#print(error)
			if error_sum < running_smallest_error_sum:
				running_smallest_error_sum = error_sum
				running_best_intercept = i
				running_best_path_loss_exponent = p
		print(i)
	print("smallest error:", running_smallest_error_sum)
	print("running_best_intercept:", running_best_intercept)
	print("running_best_path_loss_exponent:", running_best_path_loss_exponent)
	
	intercept = running_best_intercept
	path_loss_exponent = running_best_path_loss_exponent

## optimisation
func calculate_error_sum(approximations:Array[PackedVector2Array]) -> float:
	var reference_path = get_reference_path()
	
	var running_sum:float
	for reference_point_index in reference_path.size():
		for lap_index in approximations[reference_point_index].size():
			running_sum += reference_path[reference_point_index].distance_to(approximations[reference_point_index][lap_index])
	return running_sum

## path approximation
func get_approximations(laps:Array[Lap]) -> Array[PackedVector2Array]:
	var reference_path = get_reference_path()
	var approximations:Array[PackedVector2Array]
	
	for reference_point_index in reference_path.size():
		var resoults:Array[Vector2] 
		
		for lap_index in laps.size():
			resoults.append(approximate_position(
				a_position, rssi_to_distance(laps[lap_index].ap_a_readings[reference_point_index]),
				b_position, rssi_to_distance(laps[lap_index].ap_b_readings[reference_point_index]),
				c_position, rssi_to_distance(laps[lap_index].ap_c_readings[reference_point_index])
			))
		
		approximations.append(PackedVector2Array(resoults))
	return approximations

func get_approximate_path(approximations:Array[PackedVector2Array]) -> Array[Vector2]:
	var approximate_path:Array[Vector2]
	
	for reference_point_approximations in approximations:
		var running_avarage:Vector2
		for approximation in reference_point_approximations:
			running_avarage += approximation
		approximate_path.append(running_avarage/reference_point_approximations.size())
	
	return approximate_path

func rssi_to_distance(strength:float) -> float:
	return pow(10,((strength-intercept)/(-10*path_loss_exponent))) * 1_000

## centroid calculations
func calculate_intersections(
		circle1_position:Vector2, circle1_radius:float,
		circle2_position:Vector2, circle2_radius:float
	) -> Array[Vector2]:
	var d:float = sqrt((circle2_position.x - circle1_position.x)**2 + (circle2_position.y - circle1_position.y)**2)
	
	var is_inside:bool = d < abs(circle1_radius - circle2_radius)
	var is_outside:bool = d > circle1_radius + circle2_radius
	
	if is_inside or is_outside:
		if is_inside:
			var size_sign:int = 1 if circle1_radius < circle2_radius else -1
			if is_inside == false:
				size_sign = 1
			var circle1_near:Vector2 = \
				circle1_position + circle1_position.direction_to(circle2_position) * -size_sign * circle1_radius
			var circle2_near:Vector2 = \
				circle2_position + circle2_position.direction_to(circle1_position) * size_sign * circle2_radius
			
			return [
				circle1_near + circle1_near.direction_to(circle2_near) * \
				circle1_radius / (circle1_radius + circle2_radius) * \
				circle1_near.distance_to(circle2_near)
			]
			
		elif is_outside:
			return [
				circle1_position + circle1_position.direction_to(circle2_position) * \
				circle1_radius / (circle1_radius + circle2_radius) * \
				circle1_position.distance_to(circle2_position)
			]
	
	## intersecting circles 
	var a:float = (circle1_radius**2 - circle2_radius**2 + d**2) / (2 * d)
	var h:float = sqrt(circle1_radius**2 - a**2)
	
	var x2:float = circle1_position.x + a * (circle2_position.x - circle1_position.x) / d
	var y2:float = circle1_position.y + a * (circle2_position.y - circle1_position.y) / d
	
	var x3:float = x2 + h * (circle2_position.y - circle1_position.y) / d
	var y3:float = y2 - h * (circle2_position.x - circle1_position.x) / d
	
	var x4:float = x2 - h * (circle2_position.y - circle1_position.y) / d
	var y4:float = y2 + h * (circle2_position.x - circle1_position.x) / d
	
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

func approximate_position(
		circle1_position:Vector2, circle1_radius:float,
		circle2_position:Vector2, circle2_radius:float,
		circle3_position:Vector2, circle3_radius:float
	) -> Vector2:
	return calculate_centroid( 
		calculate_smallest_perimeter_triplet(
			calculate_intersections(
				circle1_position, circle1_radius,
				circle2_position, circle2_radius),
			calculate_intersections(
				circle2_position, circle2_radius,
				circle3_position, circle3_radius),
			calculate_intersections(
				circle3_position, circle3_radius,
				circle1_position, circle1_radius),
		)
	)


## drawing
func _draw() -> void:
	var reference_path = get_reference_path()
	if show_reference_path:
		draw_polyline(reference_path, Color.WHITE)
		draw_circle(reference_path[0], 10, Color.WHITE)
		
	var laps:Array[Lap] = get_laps_data()
	var approximations:Array[PackedVector2Array] = get_approximations(laps)
	var approximate_path:Array[Vector2] = get_approximate_path(approximations)
	
	if show_approximations:
		for i in reference_path.size():
			for j in laps.size():
				var color:Color = path_gradient.sample(1.0*i/reference_path.size()).darkened(0.2*j)
				draw_line(reference_path[i], approximations[i][j], color)
				draw_circle(approximations[i][j], 35, color)
	
	if show_approximate_path:
		draw_polyline(approximate_path, Color.YELLOW, 50)
