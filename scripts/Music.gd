extends AudioStreamPlayer


func PlaySong(song:AudioStream):
	if stream != song:
		stream = song
		play()
