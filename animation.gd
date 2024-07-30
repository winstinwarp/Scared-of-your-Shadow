extends Node2D


var i: bool =false

func _on_player_animate(animationName):
	if i==true:																	#if already initiated running change animation to "Running"
		if animationName=="InitiateRunning":
			animationName="Running"
		else:
			i=false
			$WalkingSFX.stop()
		$CharacterContainer/Body/Hips/Torso/Cloak.play(animationName)
		$AnimationPlayer.play(animationName, .5)
	elif i==false:																#else if haven't initiated running animation, animate "InitiateRunning" on cloak sprite
		$CharacterContainer/Body/Hips/Torso/Cloak.play(animationName)
		if animationName=="InitiateRunning":
			animationName="Running"
			if($WalkingSFX.has_stream_playback()==false):							#if the walkingsfx are not currently playing, play a random portion
				$WalkingSFX.play(choose([0, .5, 1, 1.5, 2, 2.5, 3]))
			else:
				pass
		else:
			$WalkingSFX.stop()
		$AnimationPlayer.play(animationName, .5)



func _on_human_enemy_animate(animationName):
	$AnimationPlayer.play(animationName, .5)
	if animationName=="Death":
		$CharacterContainer/Body/Hips/Torso/BicepR/ForearmR/HandR/Lantern/Light.visible=false
		$EnemyWalkingSFX.stop()
	elif animationName=="Walking":
		$CharacterContainer/Body/Hips/Torso/BicepR/ForearmR/HandR/Lantern/Light.visible=true
		if($EnemyWalkingSFX.has_stream_playback()==false):
			$EnemyWalkingSFX.play(choose([0, .5, 1, 1.5, 2, 2.5, 3]))
	else:
		$CharacterContainer/Body/Hips/Torso/BicepR/ForearmR/HandR/Lantern/Light.visible=true
		$EnemyWalkingSFX.stop()
		

func _on_human_enemy_flicker(flickerstate):
	if flickerstate==true:
		$CharacterContainer/Body/Hips/Torso/BicepR/ForearmR/HandR/Lantern/Light.visible=false
	else:
		$CharacterContainer/Body/Hips/Torso/BicepR/ForearmR/HandR/Lantern/Light.visible=true


func _on_cloak_animation_finished():
	if $CharacterContainer/Body/Hips/Torso/Cloak.get_animation()=="InitiateRunning":
		i=true

func choose(array):
	array.shuffle()
	return array.front()
