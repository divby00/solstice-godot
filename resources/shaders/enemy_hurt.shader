shader_type canvas_item;

uniform vec4 color : hint_color = vec4(0.75, 0.15, 0.2, 1.0);
uniform bool active = false;

void fragment() {
	if (active) {
		vec4 pixel = texture(TEXTURE, UV);
		if (pixel.a > 0.0) {
			COLOR = color;
		} else {
			COLOR = vec4(0.0, 0.0, 0.0, 0.0);
		}
	} else {
		COLOR = texture(TEXTURE, UV);
	}
}

