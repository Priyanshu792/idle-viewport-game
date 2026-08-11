
shader_type canvas_item;
render_mode blend_add;

// ----------------------------------------
// LASER LINE 2D
// ----------------------------------------

uniform vec4 color : source_color = vec4(0.15, 0.8, 1.0, 1.0);
uniform vec4 outline_color : source_color = vec4(0.0, 0.25, 1.0, 1.0);

uniform float speed = 3.0;
uniform float energy = 2.0;

uniform float thickness : hint_range(0.01, 1.0) = 0.25;
uniform float glow_size : hint_range(0.01, 1.0) = 0.6;

uniform float noise_strength : hint_range(0.0, 1.0) = 0.15;

uniform float start_fade : hint_range(0.0, 0.5) = 0.03;
uniform float end_fade : hint_range(0.0, 0.5) = 0.03;


// ----------------------------------------
// TEXTURE SCALING
// ----------------------------------------

// X = number of repeats along the Line2D
// Y = number of repeats across the Line2D

uniform vec2 texture_scale = vec2(4.0, 1.0);


// ----------------------------------------
// RANDOM
// ----------------------------------------

float random(vec2 p)
{
	return fract(
		sin(dot(p, vec2(12.9898, 78.233)))
		* 43758.5453
	);
}


// ----------------------------------------
// NOISE
// ----------------------------------------

float noise(vec2 p)
{
	vec2 i = floor(p);
	vec2 f = fract(p);

	float a = random(i);
	float b = random(i + vec2(1.0, 0.0));
	float c = random(i + vec2(0.0, 1.0));
	float d = random(i + vec2(1.0, 1.0));

	f = f * f * (3.0 - 2.0 * f);

	return mix(
		mix(a, b, f.x),
		mix(c, d, f.x),
		f.y
	);
}


// ----------------------------------------
// FRACTAL NOISE
// ----------------------------------------

float fbm(vec2 p)
{
	float value = 0.0;
	float amplitude = 0.5;

	for (int i = 0; i < 4; i++)
	{
		value += noise(p) * amplitude;

		p *= 2.0;
		amplitude *= 0.5;
	}

	return value;
}


// ----------------------------------------
// FRAGMENT
// ----------------------------------------

void fragment()
{
	vec2 uv = UV;


	// ------------------------------------
	// SCALED TEXTURE
	// ------------------------------------

	vec2 tex_uv = fract(uv * texture_scale);

	vec4 tex = texture(TEXTURE, tex_uv);


	// ------------------------------------
	// Distance from center of Line2D
	// ------------------------------------

	float center_distance =
		abs(uv.y - 0.5) * 2.0;


	// ------------------------------------
	// Animated energy
	// ------------------------------------

	float n = fbm(
		vec2(
			uv.x * 8.0,
			uv.y * 4.0 - TIME * speed
		)
	);

	float distortion =
		(n - 0.5) * noise_strength;

	float distorted_distance =
		abs(
			uv.y - 0.5 + distortion
		) * 2.0;


	// ------------------------------------
	// Main laser core
	// ------------------------------------

	float core = 1.0 - smoothstep(
		0.0,
		thickness,
		distorted_distance
	);


	// ------------------------------------
	// Outer glow
	// ------------------------------------

	float glow = 1.0 - smoothstep(
		thickness,
		glow_size,
		distorted_distance
	);


	// ------------------------------------
	// White-hot center
	// ------------------------------------

	float white_core = 1.0 - smoothstep(
		0.0,
		thickness * 0.35,
		distorted_distance
	);


	// ------------------------------------
	// Fade projectile ends
	// ------------------------------------

	float fade_start = smoothstep(
		0.0,
		start_fade,
		uv.x
	);

	float fade_end = smoothstep(
		0.0,
		end_fade,
		1.0 - uv.x
	);

	float end_fade_mask =
		fade_start * fade_end;


	// ------------------------------------
	// Energy flicker
	// ------------------------------------

	float flicker =
		0.85 +
		0.15 * sin(
			TIME * 20.0 +
			uv.x * 30.0
		);


	// ------------------------------------
	// Laser color
	// ------------------------------------

	vec3 final_color =
		outline_color.rgb * glow +
		color.rgb * core +
		vec3(1.0) * white_core;


	// ------------------------------------
	// Texture influence
	// ------------------------------------

	final_color *= tex.rgb;


	// ------------------------------------
	// Energy
	// ------------------------------------

	final_color *= flicker * energy;


	// ------------------------------------
	// Alpha
	// ------------------------------------

	float alpha =
		max(core, glow * 0.65);

	alpha *= end_fade_mask;

	alpha *= tex.a;


	COLOR = vec4(
		final_color,
		alpha
	);
}
