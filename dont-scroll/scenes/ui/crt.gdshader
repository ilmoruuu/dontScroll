shader_type canvas_item;

uniform float glitch_intensity : hint_range(0.0, 1.0) = 0.3;
uniform float scan_line_amount : hint_range(0.0, 1.0) = 0.3;
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.6;
uniform float time_scale : hint_range(0.0, 10.0) = 2.0;
uniform float glitch_spike : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec2 uv = UV;
	
	float time = TIME * time_scale;
	
	// Glitch base
	float glitch_line = step(0.98, sin(uv.y * 50.0 + time * 3.0));
	float glitch_line2 = step(0.95, sin(uv.y * 20.0 + time * 7.0));
	uv.x += glitch_line * glitch_intensity * sin(time * 20.0) * 0.05;
	uv.x += glitch_line2 * glitch_intensity * 0.03;
	
	// Spike de glitch — desfoque/distorção forte ocasional
	float spike = glitch_spike;
	uv.x += spike * sin(uv.y * 100.0 + time * 50.0) * 0.08;
	uv.y += spike * sin(uv.x * 80.0 + time * 30.0) * 0.03;
	
	// Aberração cromática
	float r = COLOR.r + (glitch_line + spike) * glitch_intensity * 0.3;
	float b = COLOR.b + (glitch_line2 + spike) * glitch_intensity * 0.3;
	COLOR.rgb = vec3(r, COLOR.g, b);
	
	// Scan lines
	float scan = sin(UV.y * 800.0) * 0.5 + 0.5;
	COLOR.rgb -= scan * scan_line_amount * 0.15;
	
	// Vinheta
	vec2 vig_uv = UV - 0.5;
	float vignette = 1.0 - dot(vig_uv, vig_uv) * vignette_intensity * 4.0;
	COLOR.rgb *= vignette;
	
	// Ruído
	float noise = fract(sin(dot(UV + TIME, vec2(127.1, 311.7))) * 43758.5);
	COLOR.rgb += noise * 0.02 * (glitch_intensity + spike);
}