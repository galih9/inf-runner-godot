extends CharacterBody3D

@onready var death_sensor = $DeathSensor

var positions = [-3,0,3]
var curPos = 1

var swipeLength = 100
var startSwipe: Vector2
var curSwipe: Vector2
var swiping = false

var threshold = 20
var swipeDir = 0

const JUMP_VEL = 7
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#bullet
var bullet = load("res://scenes/bullet.tscn")
var bulletInstance

# attack speed
var attack_speed = 1.0 # seconds

func _ready() -> void:
	pass;
	#var timer = Timer.new()
	#timer.wait_time = attack_speed
	#timer.autostart = true
	#timer.one_shot = false
	#timer.connect("timeout", self, "_on_Timer_timeout")
	#add_child(timer)

func _process(delta):
	#swipe()
	#if swipeDir == 1:
		#print('right?')
		#if curPos < 2:
			#curPos += 1
			#swipeDir = 0
	#elif swipeDir == -1:
		#print('left?')
		#if curPos > 0:
			#curPos -= 1
			#swipeDir = 0
			
	if Input.is_action_just_pressed("right"):
		if curPos < 2:
			curPos += 1
			swipeDir = 0

	if Input.is_action_just_pressed("left"):
		if curPos > 0:
			curPos -= 1
			swipeDir = 0
			
	if Input.is_action_just_pressed("up"):
		velocity.y = JUMP_VEL
			
	bulletInstance = bullet.instantiate()
	bulletInstance.position = position
	bulletInstance.transform.basis = self.global_transform.basis
	bulletInstance.rotation = self.global_rotation
	# bulletInstance.transform.basis = self.global_transform.basis
	get_parent().add_child(bulletInstance)
	position.z = lerpf(position.z, positions[curPos],delta*30)
	if death_sensor.is_colliding():
		death()
	
	velocity.y -= gravity*delta
	move_and_slide()
	
func swipe():
	if Input.is_action_just_pressed("press"):
		if !swiping:
			swiping = true
			startSwipe = get_viewport().get_mouse_position()
			
	if Input.is_action_pressed("press"):
		if swiping:
			curSwipe = get_viewport().get_mouse_position()
			if startSwipe.distance_to(curSwipe) >= swipeLength:
				
				if abs(startSwipe.y-curSwipe.y) < threshold:
					if startSwipe.x-curSwipe.x < 0:
						swipeDir = 1
					else:
						swipeDir = -1
				if abs(startSwipe.x-curSwipe.x) < threshold:
					if startSwipe.y-curSwipe.y > 0 and is_on_floor():
						velocity.y = JUMP_VEL
						
				swiping = false
	else:
		swiping = false

func death():
	get_tree().reload_current_scene()
