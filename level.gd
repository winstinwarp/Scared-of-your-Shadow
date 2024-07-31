extends Node2D

#Pushing updates to github with Command Terminal: Alt+D on GameJam15 Project folder and typing "cmd"
	#create a new branch: git branch new-feature
	#switch to new branch: git checkout new-feature
	#Check status: git status
	#Add updates: git add .
	#create update: git commit -m "change description"
	#push update: git push
	
#Pulling past versions from github with Command Terminal
	#switch to main branch: git checkout main
	#check status: git status
	#pull changes: git pull

func _ready():
	$HUD/TitleScreen.visible=false
	$HUD/TextEdit.visible=false
	$HUD/VideoStreamPlayer.visible=true

func _physics_process(delta):
	if Input.is_anything_pressed():
		$HUD/VideoStreamPlayer.visible=false
	
func _on_audio_stream_player_finished():
	$BackgroundMusic.play()


func _on_player_call_platform(platformposition):
	$HUD/Syringe2.play("Empty")
	$HUD/SyringeTimer.start()
	

func _on_syringe_timer_timeout():
	$HUD/Syringe2.play("Full")

func end_game():
	$HUD/TitleScreen.visible=true
	$HUD/TextEdit.visible=true
