shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec4 color : source_color = vec4(vec3(0.0), 1.0);
uniform float width : hint_range(0, 25000) = 10.0; // adjust canvas group fit margin
uniform int pattern : hint_range(0, 2) = 1; // diamond, circle, square
uniform int border_mode : hint_range(0, 2) = 0; // 0 = outside, 1 = inside, 2 = both

bool isTransparent(vec2 xy, sampler2D tex) {
    return (xy != clamp(xy, vec2(0.0), vec2(1.0)) || texture(tex, xy).a < 0.1);
}

bool hasContraryNeighbour(vec2 uv, vec2 texture_pixel_size, sampler2D tex, float adjusted_width) {
	for (float i = -ceil(adjusted_width); i <= ceil(adjusted_width); i++) {
		float x = abs(i) > adjusted_width ? adjusted_width * sign(i) : i;
		float offset;
		
		if (pattern == 0) {
			offset = adjusted_width - abs(x);
		} else if (pattern == 1) {
			offset = floor(sqrt(pow(adjusted_width + 0.5, 2) - x * x));
		} else if (pattern == 2) {
			offset = adjusted_width;
		}
		
		bool current_is_transparent = isTransparent(uv, tex);
		
		for (float j = -ceil(offset); j <= ceil(offset); j++) {
			float y = abs(j) > offset ? offset * sign(j) : j;
			vec2 xy = uv + texture_pixel_size * vec2(x, y);
			
			bool neighbor_is_transparent = isTransparent(xy, tex);
			
			if (
			(border_mode == 0 && current_is_transparent && !neighbor_is_transparent) ||
			(border_mode == 1 && !current_is_transparent && neighbor_is_transparent) ||
			(border_mode == 2 && current_is_transparent != neighbor_is_transparent)) {
			    return true;
			}
		}
	}
	
	return false;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 base_color = textureLod(screen_texture, uv, 0.0);
	
	float adjusted_width = width;
	if (adjusted_width > 25.0) {
		base_color = vec4(1., 1., 0., 1.);
	}
	else if (hasContraryNeighbour(VERTEX, SCREEN_PIXEL_SIZE, screen_texture, 10)) {
		base_color.rgb = mix(base_color.rgb, color.rgb, color.a);
		base_color.a += (1.0 - base_color.a) * color.a;
	}
	
	COLOR = base_color;
}
