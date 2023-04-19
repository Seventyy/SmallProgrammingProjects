shader_type spatial;

uniform sampler2D normal_texture : hint_normal_roughness_texture;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D screen_texture : hint_screen_texture;

const mat3 horizontal_edge_filter = mat3(vec3(0.5, 0.0,-0.5), vec3(1.0, 0.0,-1.0), vec3( 0.5, 0.0,-0.5));
const mat3 vertical_edge_filter =   mat3(vec3(0.5, 1.0, 0.5), vec3(0.0, 0.0, 0.0), vec3(-0.5,-1.0,-0.5));

void vertex() {
	POSITION = vec4(VERTEX, 1.);
}

//void fragment() {
//	vec2 pixel_size = 1.0 / vec2(textureSize(normal_texture, 0));
//	vec4 tex = texture(normal_texture, SCREEN_UV + vec2(0.,0.) * pixel_size);
//
//	vec3 vertical_running_avarage = vec3(0.);
//	vec3 horizontal_running_avarage = vec3(0.);
//
//	for (int i = -1; i <= 1; i++) for (int j = -1; j <= 1; j++) {
//		vertical_running_avarage += texture(normal_texture, SCREEN_UV + vec2(float(i), float(j)) * pixel_size).xyz * vertical_edge_filter[i+1][j+1];
//	}
//
//	for (int i = -1; i <= 1; i++) for (int j = -1; j <= 1; j++) {
//		horizontal_running_avarage += texture(normal_texture, SCREEN_UV + vec2(float(i), float(j)) * pixel_size).xyz * horizontal_edge_filter[i+1][j+1];
//	}
//
//	ALBEDO = 256. * vertical_running_avarage;
////	ALBEDO = 256. * horizontal_running_avarage;
////	ALBEDO = 256. * vec3(
////		max(vertical_running_avarage.x, horizontal_running_avarage.x) +
////		max(vertical_running_avarage.y, horizontal_running_avarage.y) +
////		max(vertical_running_avarage.z, horizontal_running_avarage.z));
//
////	ALBEDO = texture(normal_texture, SCREEN_UV).xyz;
//
//}

void fragment() {
	//ALBEDO = texture(normal_texture, SCREEN_UV).xyz;
	vec2 pixel_size = 1.0 / vec2(textureSize(normal_texture, 0));
	
//	for (int i = 0; i < 3; i++) for (int j = 0; j < 3; j++) {
//		vertical_running_avarage += texture(normal_texture, SCREEN_UV + vec2(float(i), float(j)) * pixel_size).xyz * vertical_edge_filter[i+1][j+1];
//	}
	
	vec4 view = INV_PROJECTION_MATRIX * vec4(vec3(SCREEN_UV * 2.0 - 1.0, texture(depth_texture, SCREEN_UV).x), 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	
	vec3 edge_color = vec3(0.);
	
	edge_color = 
		abs(
		texture(normal_texture, SCREEN_UV + vec2( 1., 0.) * pixel_size).xyz -
		texture(normal_texture, SCREEN_UV + vec2(-1., 0.) * pixel_size).xyz) +
		abs(
		texture(normal_texture, SCREEN_UV + vec2( 0., 1.) * pixel_size).xyz -
		texture(normal_texture, SCREEN_UV + vec2( 0.,-1.) * pixel_size).xyz);
	
	//ALBEDO = vec3(edge_color.x + edge_color.y + edge_color.z) * 256000.;
	ALBEDO = texture(screen_texture, SCREEN_UV).xyz - vec3(edge_color.x + edge_color.y + edge_color.z) * 256000.;
//	ALBEDO = vec3(linear_depth);
}