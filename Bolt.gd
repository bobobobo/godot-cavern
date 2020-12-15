extends Area2D


var direction = 1
var velocity = Vector2.ZERO
var SPEED = 400

func _ready():
    add_to_group("bolts")
    if direction < 0:
        $Sprite.play("left")
    else:
        $Sprite.play("right")
        
    velocity.x = direction * SPEED

func _physics_process(delta):
    position = position + velocity * delta

func _on_Bolt_body_entered(body):
    if body.get_collision_layer_bit(2) || body.get_collision_layer_bit(1):
        queue_free()