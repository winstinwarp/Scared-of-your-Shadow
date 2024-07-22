extends Node2D



func _on_player_animate(animationName):
	$AnimationPlayer.play(animationName, .5)
	$CharacterContainer/Body/Hips/Torso/Cloak.play(animationName)

