shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_lambert,specular_toon;
uniform sampler2D Texture : source_color, filter_nearest;
uniform float xScale = 1.0;
uniform float offset = 10.0;
uniform float offsety = 0.0;
uniform float submount = 0.0;

void vertex(){
	
	UV = vec2(UV.x*xScale,UV.y);
	
}
void fragment() {
	vec4 tex = texture(Texture,UV);
	vec4 tex2 = texture(Texture,UV + vec2(offset,offsety));
	tex2.rgb = tex2.rgb - vec3(submount,submount,submount);
	
	vec4 Tex = mix(tex,tex2,1.0 - tex.a);
	if (Tex.a == 1.0){
	ALBEDO = Tex.rgb;}
	else{
		ALBEDO = vec3(0.0,0.0,0.0);
	}
}
