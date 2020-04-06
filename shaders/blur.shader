shader_type canvas_item;
render_mode unshaded;

uniform float amount: hint_range(0.0, 5.0);

void fragment() {
	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, amount*texture(TEXTURE, UV)[3]).rgb;
}
