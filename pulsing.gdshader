shader_type spatial;
uniform float scale_offset;
uniform float speed;
uniform sampler2D sprite_texture : source_color, filter_nearest;
uniform bool use_billboard;
void vertex() {
	if (use_billboard){
        MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	}
}
void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;
	uv -= 0.5;
	uv *= cos(TIME*speed)*scale_offset + 1.0;
	uv += 0.5;
	ALBEDO = texture(sprite_texture, uv).rgb;
	ALPHA = texture(sprite_texture, uv).a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
