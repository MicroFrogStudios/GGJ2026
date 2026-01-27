shader_type canvas_item;

uniform sampler2D pattern: filter_linear, repeat_enable;
uniform float size = 6.;
uniform vec2 direction = vec2(-1.);
uniform float speed = 1.;

void fragment() {
  COLOR = texture(pattern, 
    vec2(SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, 1.) * SCREEN_UV * size + 
    direction * TIME * speed);
}