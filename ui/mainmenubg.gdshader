shader_type canvas_item;


uniform vec2 scroll_speed = vec2(0.05, 0.0);

void fragment() {
	// Scroll
	float moved_x = UV.x + scroll_speed.x * TIME;
	float moved_y = UV.y + scroll_speed.y * TIME;
	float frac_x = fract(moved_x);
	float frac_y = fract(moved_y);
	COLOR = texture(TEXTURE, vec2(frac_x, frac_y));
}
