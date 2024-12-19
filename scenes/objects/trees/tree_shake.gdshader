shader_type canvas_item;

uniform float shake_intensity = 1.0;
uniform float shake_speed = 10.0;
uniform float hit_effect_intensity = 0.0;

void vertex() {
	vec2 shake = vec2(0.0);
	
	if(VERTEX.y < 0.0) {
		shake.x = sin(TIME * shake_speed + VERTEX.y) * shake_intensity;
	}
	
	VERTEX.xy += shake;
}
void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
    
    // Blend base color with white based on hit_effect_intensity
    COLOR = mix(base_color, vec4(1.0, 1.0, 1.0, base_color.a), hit_effect_intensity);
}
