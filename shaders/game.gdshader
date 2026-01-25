shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float wave_strength : hint_range(0.0, 0.1, 0.01) = 0.01;

void fragment() {
	// Apply a wave effect
	float wave_frequency = 1.0;
	float wave_speed = 2.0;
	float wave = sin((UV.y + TIME * wave_speed) * wave_frequency) * wave_strength;
	vec2 uv = UV;
	uv.x += wave;
	float wavey = cos((UV.x + TIME * wave_speed) * wave_frequency) * wave_strength;
	uv.y += wavey;

	// Slightly bluer color
	vec4 new_color = texture(SCREEN_TEXTURE, uv);
	new_color.b += 0.2;

	COLOR = new_color;
}
