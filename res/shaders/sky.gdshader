shader_type sky;

uniform vec3 sky_color : source_color;
uniform vec3 horizon_color : source_color;
uniform float sky_horizon_blend : hint_range(0.0, 1.0, 0.1) = 0.2;

void sky() {
	float col = clamp(EYEDIR.y / sky_horizon_blend, 0.0, 1.0);
	COLOR = mix(horizon_color, sky_color, col);
}
