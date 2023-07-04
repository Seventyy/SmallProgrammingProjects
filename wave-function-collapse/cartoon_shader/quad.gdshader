shader_type spatial;
render_mode diffuse_toon;

uniform sampler2D normal_texture : hint_normal_roughness_texture;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D screen_texture : hint_screen_texture;

uniform float edge_width = 1.;
uniform float depth_far = 1.;

void vertex() {
	POSITION = vec4(VERTEX, 1.);
}

float give_pixel_depth(vec2 relative, mat4 ipm, vec2 s_uv, vec2 px_size) {
	vec4 view = ipm * vec4(
		vec3(s_uv * 2.0 - 1.0,
		texture(depth_texture, s_uv + 
		relative * px_size).x),
		1.0
		);
	view.xyz /= view.w;
	return -view.z * depth_far;
}

void fragment() {
	//ALBEDO = texture(normal_texture, SCREEN_UV).xyz;
	vec2 pixel_size = 1.0 / vec2(textureSize(normal_texture, 0));

	
	
	
	vec3 edge_color = vec3(0.);
	
//	edge_color = 
//		abs(
//		texture(normal_texture, SCREEN_UV + vec2( edge_width, 0.) * pixel_size).xyz -
//		texture(normal_texture, SCREEN_UV + vec2(-edge_width, 0.) * pixel_size).xyz) +
//		abs(
//		texture(normal_texture, SCREEN_UV + vec2( 0., edge_width) * pixel_size).xyz -
//		texture(normal_texture, SCREEN_UV + vec2( 0.,-edge_width) * pixel_size).xyz
//		);
	
	edge_color = vec3(
		abs(
		give_pixel_depth(vec2( edge_width, 0.), INV_PROJECTION_MATRIX, SCREEN_UV, pixel_size) -
		give_pixel_depth(vec2(-edge_width, 0.), INV_PROJECTION_MATRIX, SCREEN_UV, pixel_size)) +
		abs(
		give_pixel_depth(vec2(0.,  edge_width), INV_PROJECTION_MATRIX, SCREEN_UV, pixel_size) -
		give_pixel_depth(vec2(0., -edge_width), INV_PROJECTION_MATRIX, SCREEN_UV, pixel_size)
		));
	
	ALBEDO = edge_color;
//	ALBEDO = vec3(edge_color.x + edge_color.y + edge_color.z) * 256000.;
//	ALBEDO = texture(screen_texture, SCREEN_UV).xyz - vec3(edge_color.x + edge_color.y + edge_color.z) * 256000.;
//	ALBEDO = texture(depth_texture, SCREEN_UV).xxx;
//	ALBEDO = vec3(give_pixel_depth(vec2(0.), INV_PROJECTION_MATRIX, SCREEN_UV, pixel_size));
//	ALBEDO = vec3(view.xyz);
}