shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec2 center = vec2(0.5, 0.5);
uniform float force = 0.025;
uniform float radius = 0.3;
uniform float atenuation_factor = 5.0;

void fragment() {
	// Normalize & scale UVs to be a square space
	const float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	vec2 scaled_uv = (SCREEN_UV - vec2(0.5, 0.0)) * vec2(aspect_ratio, 1.0) + vec2(0.5, 0.0);
	vec2 scaled_center = (center - vec2(0.5, 0.0)) * vec2(aspect_ratio, 1.0) + vec2(0.5, 0.0);

  // Displacement
	vec2 dist_to_center = scaled_uv - scaled_center;
	float atenuation = exp(-length(dist_to_center) * atenuation_factor); // Falloff with distance
	vec2 disp = normalize(scaled_uv - scaled_center) * force * atenuation;

	// Inner & outer rings, we want 1 between them
	float outer_mask = 1.0 - smoothstep(radius, radius + 0.025, length(dist_to_center));
	float inner_mask = smoothstep(radius - 0.025, radius, length(dist_to_center));
	float mask = outer_mask * inner_mask;
	
	vec4 new_color = texture(SCREEN_TEXTURE, SCREEN_UV - disp * mask);
	COLOR = new_color;
}
