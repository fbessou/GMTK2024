shader_type canvas_item;

uniform float power;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.rgb = mix(vec3(dot(vec3(1.0), COLOR.rgb) * 0.33333), COLOR.rgb, power);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
