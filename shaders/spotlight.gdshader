shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec2 center = vec2(0.5, 0.5);
uniform float radius = 0.3;

void fragment() {
	// Normalize & scale UVs to be a square space
	const float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	vec2 aspect_fix = vec2(aspect_ratio, 1.0);
	vec2 scaled_uv = (SCREEN_UV - 0.5) * aspect_fix;
	vec2 dist = scaled_uv - (center - 0.5);
	float d = length(dist);

	// Inner & outer rings, we want 1 between them
	float outer_mask = 1.0 - smoothstep(radius, radius + 0.05,d);
	float mask = outer_mask;
	
	vec4 new_color = texture(SCREEN_TEXTURE, SCREEN_UV) * vec4(mask, mask, mask, 1.0);
	COLOR = new_color;
}
