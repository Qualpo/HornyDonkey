shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_lambert,specular_toon;
uniform sampler2D Texture : source_color, filter_nearest;
uniform float xScale = 1.0;

void vertex(){
	UV = vec2(UV.x*xScale,UV.y);
}
void fragment() {
	vec4 Tex = texture(Texture,UV);
	ALBEDO = Tex.rgb;
}
