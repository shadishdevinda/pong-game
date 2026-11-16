shader_type canvas_item;

// පිටිපස්සේ තියෙන screen එක කියවන්න
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

// Blur එක කොච්චර ද (0 = blur නැහැ, 5 = ගොඩක් blur)
uniform float blur_amount : hint_range(0.0, 5.0) = 2.5;

// අඳුරු කරන පාට. අන්තිම අගය (alpha) එකෙන් කොච්චර අඳුරුද කියලා තීරණය වෙනවා
uniform vec4 tint : source_color = vec4(0.0, 0.0, 0.0, 0.5);

void fragment() {
	vec3 blurred = textureLod(screen_texture, SCREEN_UV, blur_amount).rgb;
	COLOR = vec4(mix(blurred, tint.rgb, tint.a), 1.0);
}