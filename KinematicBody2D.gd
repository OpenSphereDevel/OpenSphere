extends KinematicBody2D

#TUTORIAL USED FOR THIS: https://www.youtube.com/watch?v=wETY5_9kFtA&list=PL9FzW-m48fn2jlBu_0DRh7PvAt-GULEmd

#declares what the UP direction is for functions later on related to touching the floor
#this pretty much just declares that our game is a platformer and not a top-down game
const UP = Vector2(0, -1)

#constants for things like movement speed, gravity, jump height, etc.
const SPEED = 400
const GRAVITY = 20
const JUMP_HEIGHT = -700

#variable to determine if player released jump button already to stop jumping
#turns to true so you can't do it more than once mid-air and cheat the game
#resets to false when you touch the ground again
var releasedJumpAlready = false

#variable to store motion of ball sprite, does X and Y together
#access with motion.x and motion.y
var motion = Vector2()

func get_input():
	#close game if escape key pressed
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	#sets motion based on actions defined in Project>Project Settings>Input Map
	#this allows you to easily map it to other things like gamepads or touchscreens
	if Input.is_action_pressed("ball_move_right"):
		motion.x = SPEED
	elif Input.is_action_pressed("ball_move_left"):
		motion.x = -SPEED
	#default case that makes motion 0 if we aren't pressing anything
	else:
		motion.x = 0
		
	#if the player releases the jump button, it sets y motion to 0 and player falls
	#this is done so player can make short jumps, but not cheat and float or double jump or any shit
	if Input.is_action_just_released("ball_jump"):
		if motion.y < 0 && releasedJumpAlready == false:
			motion.y = 0
			releasedJumpAlready = true
			
	#inherited from KinBody2D that actually processes the motion we're setting with the keys above
	move_and_slide(motion, UP)
			
func calc_gravity():
	#sets "gravity" of player as constant downward motion
	#only happens when not colliding with the floor
	if !(is_on_floor()):
		motion.y += GRAVITY
		
	#if the player is actually on the floor and presses the jump button it will make them jump
	if is_on_floor():
		releasedJumpAlready = false
		if Input.is_action_just_pressed("ball_jump"):
			motion.y = JUMP_HEIGHT
			
	#if player hits a ceiling, make player fall back down
	#note you can't set this to 0 or it will stick to the ceiling
	if is_on_ceiling():
		motion.y = 1

#function for movement of ball sprite that is updated every frame (delta)
func _physics_process(delta):
	get_input()
	calc_gravity()
	pass


