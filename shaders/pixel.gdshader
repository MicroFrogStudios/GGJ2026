shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float pixellation_size = 0.001;

void fragment() {

	vec2 scaled_uv = SCREEN_UV / pixellation_size;
	vec2 floored_uv = floor(scaled_uv);
	vec2 pixelated_uv = floored_uv * pixellation_size;

	vec4 new_color = texture(SCREEN_TEXTURE, pixelated_uv);
	COLOR = new_color;
}
