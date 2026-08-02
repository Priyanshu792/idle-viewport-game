shader_type canvas_item;

uniform sampler2D screen_tex : source_color;
uniform float radius = 3.0;
uniform float strength = 1.5;

void fragment() {
    vec2 texel = TEXTURE_PIXEL_SIZE;

    vec4 original = texture(screen_tex, UV);
    vec4 blur = vec4(0.0);

    blur += texture(screen_tex, UV + vec2(-radius, 0.0) * texel);
    blur += texture(screen_tex, UV + vec2(radius, 0.0) * texel);
    blur += texture(screen_tex, UV + vec2(0.0, -radius) * texel);
    blur += texture(screen_tex, UV + vec2(0.0, radius) * texel);
    blur += texture(screen_tex, UV + vec2(radius, radius) * texel);
    blur += texture(screen_tex, UV + vec2(-radius, radius) * texel);
    blur += texture(screen_tex, UV + vec2(radius, -radius) * texel);
    blur += texture(screen_tex, UV + vec2(-radius, -radius) * texel);

    blur /= 8.0;

    COLOR = original + blur * strength;
}