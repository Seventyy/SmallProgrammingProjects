shader_type spatial;

uniform sampler2D normal_texture : hint_normal_roughness_texture;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D screen_texture : hint_screen_texture;

uniform float edge_width = 1;

void vertex() {
	POSITION = vec4(VERTEX, 1.);
}

void fragment() {
	//ALBEDO = texture(normal_texture, SCREEN_UV).xyz;
	vec2 pixel_size = 1.0 / vec2(textureSize(normal_texture, 0));
	
//	vec4 view = INV_PROJECTION_MATRIX * vec4(vec3(SCREEN_UV * 2.0 - 1.0, texture(depth_texture, SCREEN_UV + vec2( edge_width, 0.) * pixel_size).x), 1.0);
//	view.xyz /= view.w;
//	float linear_depth = -view.z * .25;

	vec4 view = INV_PROJECTION_MATRIX * vec4(vec3(SCREEN_UV * 2.0 - 1.0, texture(depth_texture, SCREEN_UV + vec2( edge_width, 0.) * pixel_size).x), 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z * .25;
	
	vec3 edge_color = vec3(0.);
	
	edge_color = 
		abs(
		texture(normal_texture, SCREEN_UV + vec2( edge_width, 0.) * pixel_size).xyz -
		texture(normal_texture, SCREEN_UV + vec2(-edge_width, 0.) * pixel_size).xyz) +
		abs(
		texture(normal_texture, SCREEN_UV + vec2( 0., edge_width) * pixel_size).xyz -
		texture(normal_texture, SCREEN_UV + vec2( 0.,-edge_width) * pixel_size).xyz);
	
	//ALBEDO = vec3(edge_color.x + edge_color.y + edge_color.z) * 256000.;
	ALBEDO = texture(screen_texture, SCREEN_UV).xyz - vec3(edge_color.x + edge_color.y + edge_color.z) * 256000.;
//	ALBEDO = texture(depth_texture, SCREEN_UV).xxx;
	ALBEDO = vec3(view.xyz);
}