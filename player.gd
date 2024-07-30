extends CharacterBody2D

#Constant values for scene
const animationSize=.15

#Tweaking player jump height and distance
var jump_height: float = 130
var jump_time_to_peak: float = .5
var jump_time_to_descend: float = .3

#Variables 
var JUMP_VELOCITY: float = ((2.0* jump_height) / jump_time_to_peak) * -1.0
var JUMP_GRAVITY: float = ((-2.0 * jump_height) / (jump_time_to_peak*jump_time_to_peak)) *-1.0
var FALL_GRAVITY: float = ((-2.0*jump_height) / (jump_time_to_descend*jump_time_to_descend))*-1.0

var base_speed = 415

const Hacceleration = 35
const friction = 50

#const JUMP_VELOCITY = -900									#700

signal animate(animationName)

signal particles(playerposition, dashposition)

signal add_trauma(amount)

signal death()

#variables for dive or roll
var dash: bool = true
var dash_distance: float = base_speed*1

var dead: bool = false

var checkpointPosition = Vector2(650, 1080)

#func 

func _ready():
	$Camera2D.enabled=true
	$Camera2D.position_smoothing_enabled=false
	$".".visible=true
	
	
	#connect signals
	
	
	

func _physics_process(delta):
	#Add animations to running and crouching
	
	if dead==true:					#checks to ensure player is alive
		$DeathTimer.start()
		dead=false
		print("Start Timer")
	
	if is_on_floor():			#running and idle animations

		if (velocity.x>1 or velocity.x<-1):
			animate.emit("InitiateRunning")
		else:
			animate.emit("Idle")
			
	#Add the gravity.
	elif not is_on_floor():		#falling
		velocity.y += get_gravity() * delta
		#create_tween().tween_property($PlayerCollision, 'scale', Vector2(1,.75), .1)				#Move collision box and resize to fit jumping/falling animations
		#create_tween().tween_property($PlayerCollision, 'position', Vector2(0,-8), .1)
		
		if velocity.y>0:
			animate.emit("Falling")
		pass

	# Get the input direction and handle the movement/deceleration.
	#Movement left and right
	var direction = Input.get_axis("left", "right")
	if direction:			#movement
		if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
			velocity.x=0
		else:
			if Input.is_action_pressed("right"):
				$Animation.scale.x=animationSize
				$DashArea.position.x=dash_distance
				$DashAreaNear.position.x=dash_distance-50
				$DashAreaFar.position.x=dash_distance+50
				$DashAreaHigh.position=Vector2(dash_distance-50, -150)
			elif Input.is_action_pressed("left"):
				$Animation.scale.x=-animationSize
				$DashArea.position.x=-dash_distance
				$DashAreaNear.position.x=-dash_distance+50
				$DashAreaFar.position.x=-dash_distance-50
				$DashAreaHigh.position=Vector2(-dash_distance+50, -150)
			velocity.x = move_toward(velocity.x, direction * base_speed, Hacceleration)
	elif is_on_floor():		#Adds friction
		velocity.x = move_toward(velocity.x, 0, friction)
	
	# Movement jump
	if Input.is_action_just_pressed("jump") and is_on_floor():		#jumping
		velocity.y = JUMP_VELOCITY
		velocity.x = direction * base_speed*1.5
		animate.emit("InitiateJumping")
		
	# Movement dash
	if Input.is_action_just_pressed("dash") and dash==true and (velocity.x>0 or velocity.x<0):						#checks if player can dive
		if $DashArea.has_overlapping_bodies()==false or $DashAreaFar.has_overlapping_bodies()==false or $DashAreaNear.has_overlapping_bodies()==false or $DashAreaHigh.has_overlapping_bodies()==false:
			animate.emit("Falling")
			particles.emit($".".global_position, $DashAreaFar/DashFarCollision.global_position)
			add_trauma.emit(.225)
			freeze_frame(0.1, .5)
			await(.5)
			$Animation.visible=false
			if $DashAreaHigh.has_overlapping_bodies()==false and Input.is_action_pressed("jump"):
				position = $DashAreaHigh/DashHighCollision.global_position		#Vector2($DashAreaHigh/DashHighCollision.global_position.x, $DashAreaHigh/DashHighCollision.global_position.y)
			elif $DashArea.has_overlapping_bodies()==false:
				position.x = $DashArea/DashCollision.global_position.x
			elif $DashAreaNear.has_overlapping_bodies()==false:
				position.x = $DashAreaNear/DashNearCollision.global_position.x
			elif $DashAreaFar.has_overlapping_bodies()==false:
				position.x = $DashAreaFar/DashFarCollision.global_position.x
			elif $DashAreaHigh.has_overlapping_bodies()==false:
				position = $DashAreaHigh/DashHighCollision.global_position
			$InvisibilityTimer.start()
			$DashTimer.start()
			dash=false

	move_and_slide()

func get_gravity() -> float:
	return JUMP_GRAVITY if velocity.y<0.0 else FALL_GRAVITY

func _on_invisibility_timer_timeout():
	$Animation.visible=true

func _on_dash_timer_timeout():
	if !dash:
		dash=true

func _on_death_timer_timeout():
		$".".visible=true
		base_speed = 415
		jump_height = 130
		print("Respawning: ", checkpointPosition)
		$".".global_position=checkpointPosition

func freeze_frame(timeScale, duration):
	$Camera2D.position_smoothing_enabled=true
	$Camera2D.position_smoothing_speed=25
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1
	$Camera2D.position_smoothing_enabled=false

func _on_human_enemy_kill():
	dead_player()
	print("death by enemy")
	
func _on_kill_box_kill():
	dead_player()
	print("death by kill box")
	
func dead_player():
	$".".visible=false
	$DashArea.global_position.x=$".".global_position.x
	particles.emit($".".global_position, $DashArea.global_position)
	base_speed = 0
	jump_height = 0
	add_trauma.emit(.5)
	dead=true

func _on_checkpoint_pos(checkpos):
	checkpointPosition=checkpos



