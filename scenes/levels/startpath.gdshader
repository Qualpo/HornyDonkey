shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_lambert,specular_toon;
uniform sampler2D Grass : filter_nearest;
uniform sampler2D Dirt : filter_nearest;
uniform sampler2D Mask : filter_nearest;

void fragment() {
	vec3 grasstex =  texture(Grass,UV * 5.0).rgb;
	vec3 dirttex = texture(Dirt,UV * 5.0).rgb;
	vec3 masktex = texture(Mask,UV).rgb;
	vec3 combdmask = dirttex * masktex;
	ALBEDO = mix(grasstex,combdmask,masktex);
}
