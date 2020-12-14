extends StaticBody2D


var type = 0


func _ready():
    $Sprite.set_frame(type)
