extends CharacterBody2D

class_name HumanEnemy

@export var can_move: bool
@export var can_change_direction: bool
@export var random_direction: bool

const speed = 115
var is_human_chase: bool = false
var is_roaming: bool = true
var is_searching: bool = false

var dead: bool = false

var startingPosition: Vector2

signal kill(killPlayer)

var gravity = 1000
var direction: int = 1
var pastdirection: int = 1

@export var directionTimeAvg: float												#around 5-6 seconds depending on area covering

var flickerstate: bool = false

signal animate(animationName)
signal flicker(flickerstate)
signal death(enemyposition, playerposition)

func _ready():
	add_to_group("Enemies")

	$DirectionTimer.start()
	$CollisionShape2D.disabled=false
	
	startingPosition=$".".global_position

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
	move(delta)
	handle_animation()
	move_and_slide()
	
	if flickerstate==true:
		$LightFlickerTimer.start()
		flickerstate=false
	
func move(delta):
	if !dead and can_move:
		if !is_human_chase:
			velocity.x = move_toward(velocity.x, direction * speed, 50)
		is_roaming = true
	elif dead:
		velocity.x=0
	
		



func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = choose([directionTimeAvg-.5, directionTimeAvg, directionTimeAvg+.5])
	if !is_human_chase and is_searching and can_change_direction and random_direction:
		velocity.x = 0
		direction = choose([1,-1])													#choose right or left direction based on choose function
		is_searching=false
	elif !is_human_chase and is_searching and can_change_direction and !random_direction:
		velocity.x = 0
		direction=-pastdirection
		is_searching=false
	elif !is_human_chase and !is_searching and can_change_direction:
		$DirectionTimer.wait_time = choose([directionTimeAvg-2, directionTimeAvg-1, directionTimeAvg])
		velocity.x = 0
		pastdirection=direction
		direction=0
		is_searching=true
		
		
func _on_light_flicker_timer_timeout():
	if dead==false:
		$LightArea/CollisionShape2D.disabled=false
		flickerstate=false
		flicker.emit(flickerstate)


func handle_animation():
	if !dead:
		if direction==-1:														#if moving left
			$HumanAnimation.scale.x=-1
			$LightArea.position.x=-485
		if direction==1:														#if moving right
			$HumanAnimation.scale.x=1
			$LightArea.position.x=485
		if !velocity.x==0:
			animate.emit("Walking")
		elif velocity.x==0:
			animate.emit("Idle")
	elif dead:
		animate.emit("Death")
		gravity=0
		$CollisionShape2D.disabled=true
	
func choose(array):
	array.shuffle()
	return array.front()

func _on_player_particles(playerposition, dashposition):
	$LightArea/CollisionShape2D.disabled=true
	flickerstate=true
	flicker.emit(flickerstate)
	if playerposition.x>$".".global_position.x and $".".global_position.x>dashposition.x and playerposition.y>$".".global_position.y-200 and !dead: 		#if enemy is in between dash position and player
		dead=true
		death.emit($".".global_position, playerposition)
	elif playerposition.x<$".".global_position.x and $".".global_position.x<dashposition.x and playerposition.y>$".".global_position.y-200 and !dead:
		dead=true
		death.emit($".".global_position, playerposition)


func _on_light_area_body_entered(body):
	if body.name == "Player":
		kill.emit()
		#$".".global_position=startingPosition
