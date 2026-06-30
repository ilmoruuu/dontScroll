shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float gray_intensity : hint_range(0.0,1.0) = 1.0;
uniform float glitch_intensity : hint_range(0.0,1.0) = 0.0;
uniform float glitch_spike : hint_range(0.0,1.0) = 0.0;

uniform float scan_line_amount : hint_range(0.0,1.0) = 0.25;
uniform float vignette_intensity : hint_range(0.0,1.0) = 0.4;
uniform float noise_amount : hint_range(0.0,1.0) = 0.03;
uniform float time_scale = 2.0;

float random(vec2 st){
	return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment(){

	float time = TIME * time_scale;

	vec2 uv = SCREEN_UV;

	float band = floor(uv.y * 90.0);

	float band_random = random(vec2(band, floor(time * 8.0)));

	float offset = 0.0;

	if(band_random > 0.92){

		offset =
		(band_random - 0.92)
		* 0.12
		* (glitch_intensity + glitch_spike)
		* sin(time * 25.0 + band);
	}

	uv.x += offset;

	vec4 color = texture(SCREEN_TEXTURE, uv);

	float chroma =
		(glitch_intensity + glitch_spike)
		* 0.003;

	color.r = texture(
		SCREEN_TEXTURE,
		uv + vec2(chroma,0.0)
	).r;

	color.b = texture(
		SCREEN_TEXTURE,
		uv - vec2(chroma,0.0)
	).b;


	float scan =
		sin(SCREEN_UV.y * 900.0) * 0.5 + 0.5;

	color.rgb -=
		scan *
		scan_line_amount *
		0.12;

	float noise =
	random(
		SCREEN_UV * vec2(1200.0)
		+ time
	);

	color.rgb +=
		(noise - 0.5)
		* noise_amount
		* (0.5 + glitch_intensity);

	vec2 center = SCREEN_UV - 0.5;

	float vignette =
		1.0 -
		dot(center,center)
		* vignette_intensity
		* 3.0;

	color.rgb *= vignette;

	float gray =
		dot(color.rgb,
		vec3(0.299,0.587,0.114));

	color.rgb =
		mix(
			color.rgb,
			vec3(gray),
			gray_intensity
		);

	COLOR = color;
}