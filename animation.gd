extends Node2D


var i: bool =false

func _on_player_animate(animationName):
	if i==true:
		if animationName=="InitiateRunning":
			animationName="Running"
		else:
			i=false
		$CharacterContainer/Body/Hips/Torso/Cloak.play(animationName)
		$AnimationPlayer.play(animationName, .5)
	elif i==false:
		$CharacterContainer/Body/Hips/Torso/Cloak.play(animationName)
		if animationName=="InitiateRunning":
			animationName="Running"
		$AnimationPlayer.play(animationName, .5)



func _on_human_enemy_animate(animationName):
	$AnimationPlayer.play(animationName, .5)
	if animationName=="Death":
		$CharacterContainer/Body/Hips/Torso/BicepR/ForearmR/HandR/Lantern/Light.visible=false
	else:
		$CharacterContainer/Body/Hips/Torso/BicepR/ForearmR/HandR/Lantern/Light.visible=true
		

func _on_human_enemy_flicker(flickerstate):
	if flickerstate==true:
		$CharacterContainer/Body/Hips/Torso/BicepR/ForearmR/HandR/Lantern/Light.visible=false
	else:
		$CharacterContainer/Body/Hips/Torso/BicepR/ForearmR/HandR/Lantern/Light.visible=true


func _on_cloak_animation_finished():
	if $CharacterContainer/Body/Hips/Torso/Cloak.get_animation()=="InitiateRunning":
		i=true
