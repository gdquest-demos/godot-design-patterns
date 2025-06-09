shader_type canvas_item;

uniform float bend = 0.0;

vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
						vec2(cos(angle), sin(angle)));
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}


void fragment() {
	vec2 uv = UV;
	float x_start = 0.535;
	uv = rotate(uv, vec2(0.5, 1.0), PI / 2.0 + bend * (1.0 - UV.y));
	float mapped_x = smoothstep(x_start, 1.0, uv.x);
	float mask = step(uv.y, 0.6) * step(x_start, uv.x);
	float wave = sin(TIME * 3.0 - mapped_x * 4.0);
	uv.y += wave * 0.08 * mask * mapped_x;
	vec4 t = texture(TEXTURE, uv);
	COLOR = t;
}

