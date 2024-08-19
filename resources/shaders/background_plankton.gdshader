shader_type canvas_item;
uniform float proximity; // 1 = Same Level as Rune | 0 = nearly black
uniform float plankton_contamination;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.rgb = mix(vec3(COLOR.r + COLOR.g + COLOR.b) / 3., COLOR.rgb, plankton_contamination);
	COLOR.rgb  *= proximity;

	COLOR.a = min(COLOR.a, abs(proximity - 2.) < 0.01 ? 0.3 : 1.);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
