shader_type  canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment(){
	COLOR = texture(TEXTURE,UV);
	vec4 scolor = texture(SCREEN_TEXTURE,SCREEN_UV);
	
	
	COLOR = vec4(1.0 - scolor.rgb,COLOR.a);
}