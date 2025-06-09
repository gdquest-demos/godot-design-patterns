shader_type canvas_item;

uniform sampler2D wave_sampler : filter_linear, repeat_enable;

void fragment() {
	float wave = texture(wave_sampler, vec2(UV.y * 3.0 - TIME * 0.8, 0.0)).x;
	
	COLOR.a *= wave;
	COLOR.rgb += wave * 0.05;
}