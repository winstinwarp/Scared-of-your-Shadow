extends StaticBody2D




func _on_player_call_platform(platformposition):
	$".".position=platformposition
	print(platformposition)
