extends Node2D

# Constant for ball speed (in pixels/second)
const BALL_SPEED = 80
# Constant for pads speed
const PLAYER_SPEED = 150
# Speed of the ball (also in pixels/second)
var ball_speed = BALL_SPEED

var screen_size
var player_size
var ball_direction = Vector2(1.0,0.0)
var ball_position

func _ready():
	screen_size = get_viewport_rect().size
	player_size = $PlayerLeftSprite.get_texture().get_size()
	ball_position = $BallSprite.position


func _process(delta):

	ball_position += ball_direction * ball_speed * delta
	
	# Move left pad
	var player_left_position = $PlayerLeftSprite.position
	if(player_left_position.y>0 and Input.is_action_pressed("left_move_up")):
		player_left_position.y += -PLAYER_SPEED * delta
	if(player_left_position.y < screen_size.y and Input.is_action_pressed("left_move_down")):
		player_left_position.y += PLAYER_SPEED * delta
	$PlayerLeftSprite.position = player_left_position
	
	# Move right pad
	var player_right_position = $PlayerRightSprite.position
	if(player_right_position.y>0 and Input.is_action_pressed("right_move_up")):
		player_right_position.y += -PLAYER_SPEED * delta
	if(player_right_position.y < screen_size.y and Input.is_action_pressed("right_move_down")):
		player_right_position.y += PLAYER_SPEED * delta
	$PlayerRightSprite.position = player_right_position

	# Flip when touching roof or floor
#	if((ball_position.y<0 and ball_direction.y<0) or (ball_position.y>screen_size.y and ball_direction.y>0)):
	if((ball_position.y<0) or (ball_position.y>screen_size.y)):
		ball_direction.y = -ball_direction.y

	# Flip, change ball_direction and increase speed when touching pads
	var player_left_rect2 = Rect2($PlayerLeftSprite.position-player_size*0.5,player_size)
	var player_right_rect2 = Rect2($PlayerRightSprite.position-player_size*0.5,player_size)
	if((player_left_rect2.has_point(ball_position) and ball_direction.x<0) or (player_right_rect2.has_point(ball_position) and ball_direction.x>0)):
		ball_direction.x = -ball_direction.x
		ball_direction.y = randf() * 2.0 - 1
		ball_direction = ball_direction.normalized()
		ball_speed *= 1.1
		
	# Check gameover
	if(ball_position.x < 0 or ball_position.x > screen_size.x):
		ball_position = screen_size * 0.5
		ball_speed = BALL_SPEED
		ball_direction = Vector2(-1,0)
		
	$BallSprite.position = ball_position
	
	
	
		
	
