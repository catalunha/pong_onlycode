extends Node2D

# Constant for ball speed (in pixels/second)
const BALL_SPEED = 80
# Constant for pads speed
const PLAYER_SPEED = 150
# Speed of the ball (also in pixels/second)
var ball_speed = BALL_SPEED

var screen_size
var player_size
var direction = Vector2(1.0,0.0)

func _ready():
	screen_size = get_viewport_rect().size
	player_size = $PlayerLeftSprite.get_texture().get_size()


func _process(delta):
	print(direction)
	var ball_pos = $BallSprite.position
	var left_rect = Rect2($PlayerLeftSprite.position-player_size*0.5,player_size)
	var right_rect = Rect2($PlayerRightSprite.position-player_size*0.5,player_size)
	ball_pos += direction * ball_speed * delta
	# Flip when touching roof or floor
	if((ball_pos.y<0 and direction.y<0) or (ball_pos.y>screen_size.y and direction.y>0)):
		direction.y = -direction.y
	# Flip, change direction and increase speed when touching pads
	if((left_rect.has_point(ball_pos) and direction.x<0) or (right_rect.has_point(ball_pos) and direction.x>0)):
		direction.x = -direction.x
		direction.y = randf() * 2.0 - 1
		direction = direction.normalized()
		ball_speed *= 1.1
		
	# Check gameover
	if(ball_pos.x < 0 or ball_pos.x > screen_size.x):
		ball_pos = screen_size * 0.5
		ball_speed = BALL_SPEED
		direction = Vector2(-1,0)
		
	$BallSprite.position = ball_pos
	
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
	
	
		
	
