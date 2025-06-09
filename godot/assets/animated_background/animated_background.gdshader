shader_type canvas_item;

uniform sampler2D curves_sampler : filter_linear_mipmap, repeat_disable;
uniform vec3 base_color : source_color;
uniform vec3 mult_color : source_color;
uniform float camera_offset = 0.0;

// https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83?permalink_comment_id=2351862#generic-123-noise
float rand(float n){return fract(sin(n) * 43758.5453123);}

float noise(float p){
	float fl = floor(p);
	float fc = fract(p);
	return mix(rand(fl), rand(fl + 1.0), fc);
}

void fragment() {
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 base_uv = FRAGCOORD.xy / resolution.xy;
	int res = 8;
	float mask = 0.0;
	for (int i = 0; i < res; i++){
		float percent = float(i) / float(res);
		vec3 curves = texture(curves_sampler, vec2(percent, 0.0)).xyz;
		vec2 uv = base_uv;
		vec2 base_offset = (vec2(noise(percent * 10.0), noise(percent * 50.0)) - 0.5);
		base_offset.x += camera_offset / resolution.x * curves.x * 0.5;
		float time_offset = mod((100.0 + TIME) * curves.y * 0.05, 2.0);
		uv.y += time_offset - 1.0;
		uv.x += base_offset.x;
		uv -= 0.5;
		uv.x *= resolution.x / resolution.y; 
		uv *= 5.0 * curves.x;
		uv += 0.5;
		mask = max(mask, step(distance(uv, vec2(0.5)), 0.5) * curves.z);
	}
	COLOR.rgb = mix(base_color, base_color * mult_color, mask * (1.0 - UV.y) + UV.y * 0.5);
}