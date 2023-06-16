extends Level

var BossMusic = preload("res://audio/music/boss_theme.ogg")




func _on_enemy_see(P):
	Music.PlaySong(BossMusic)
