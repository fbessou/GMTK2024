// NOTE: Shader automatically converted from Godot Engine 4.3.stable's CanvasItemMaterial.

shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D paper_texture;
uniform float corruption : hint_range(0.0, 1.0) = 1.0;
uniform vec4 filter_color: source_color;
uniform float color_multiplier: hint_range(0.0, 1.0) = 1.0;

//varying vec2 uv_scaled;
void vertex() {
	//uv_scaled = UV * length(MODEL_MATRIX[0].xy) * 0.5;
}

vec3 greyscale(vec3 color, float str) {
    float g = dot(color, vec3(0.299, 0.587, 0.114));
    return mix(color, vec3(g), str);
}
void fragment() {
	// Apply paper texture
	COLOR.rgb *= mix(vec3(0), vec3(1), (texture(paper_texture, UV * 0.5f).r - 0.3) / (1.0 - 0.3));

	// Apply "corruption" filter
	COLOR.rgb = mix(filter_color.rgb, greyscale(COLOR.rgb, 1.0f - corruption), color_multiplier);

}
