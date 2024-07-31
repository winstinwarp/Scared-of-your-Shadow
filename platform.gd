extends StaticBody2D




func _on_player_call_platform(platformposition):
	$PlatformCollision.disabled=false
	$".".visible=true
	$".".position=platformposition
	$PlatformTimer.start()
	print(platformposition)

func _on_platform_timer_timeout():
	$PlatformCollision.disabled=true
	$".".visible=false
