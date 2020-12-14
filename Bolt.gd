extends Area2D


var direction = 1
var velocity = Vector2.ZERO
var SPEED = 400

func _ready():
    if direction < 0:
        $Sprite.play("left")
    else:
        $Sprite.play("right")
        
    velocity.x = direction * SPEED

func _physics_process(delta):
    position = position + velocity * delta
