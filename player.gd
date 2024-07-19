extends CharacterBody2D

#Constant values for scene
const animationSize=.22

#Tweaking player jump height and distance
var jump_height: float = 100
var jump_time_to_peak: float = .5
var jump_time_to_descend: float = .3

#Variables 
var JUMP_VELOCITY: float = ((2.0* jump_height) / jump_time_to_peak) * -1.0
var JUMP_GRAVITY: float = ((-2.0 * jump_height) / (jump_time_to_peak*jump_time_to_peak)) *-1.0
var FALL_GRAVITY: float = ((-2.0*jump_height) / (jump_time_to_descend*jump_time_to_descend))*-1.0

const base_speed = 375

const Hacceleration = 35
const friction = 50

#const JUMP_VELOCITY = -900									#700

signal animate(animationName)

signal death()

#variables for dive or roll
var dash: bool = true
var dash_distance: float = base_speed+100

func _physics_process(delta):
	#Add animations to running and crouching
	if is_on_floor():

		if (velocity.x>1 or velocity.x<-1):
			animate.emit("Walking")
		else:
			animate.emit("Idle")
			
	#Add the gravity.
	elif not is_on_floor():
		velocity.y += get_gravity() * delta
		#create_tween().tween_property($PlayerCollision, 'scale', Vector2(1,.75), .1)				#Move collision box and resize to fit jumping/falling animations
		#create_tween().tween_property($PlayerCollision, 'position', Vector2(0,-8), .1)
		
		#if velocity.y>0:
		#	animate.emit("Falling")
		

	# Get the input direction and handle the movement/deceleration.
	#Movement left and right
	var direction = Input.get_axis("left", "right")
	if direction:
		if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
			velocity.x=0
		else:
			if Input.is_action_pressed("right"):
				$Animation.scale.x=animationSize
				$DashArea.position.x=dash_distance
			elif Input.is_action_pressed("left"):
				$Animation.scale.x=-animationSize
				$DashArea.position.x=-dash_distance
				
			velocity.x = move_toward(velocity.x, direction * base_speed, Hacceleration)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction)
	
	# Movement jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		velocity.x = direction * base_speed*1.5
		animate.emit("InitiateJumpingRight")
		
	# Movement dash
	if Input.is_action_pressed("dash"):
		if Input.is_action_just_pressed("dash") and dash==true and (velocity.x>0 or velocity.x<0):						#checks if player can dive
			if $DashArea.has_overlapping_bodies()==false:
				animate.emit("Dash")
				freeze_frame(0.1, .75)
				$Animation.visible=false
				position.x = $DashArea/DashCollision.global_position.x
				#velocity.x = direction * dash_distance * 2
				$DashTimer.start()
				dash=false


	move_and_slide()

func get_gravity() -> float:
	return JUMP_GRAVITY if velocity.y<0.0 else FALL_GRAVITY


func _on_dash_timer_timeout():
	$Animation.visible=true
	dash=true

func freeze_frame(timeScale, duration):
	$Camera2D.position_smoothing_enabled=true
	$Camera2D.position_smoothing_speed=25
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1
	$Camera2D.position_smoothing_enabled=false
