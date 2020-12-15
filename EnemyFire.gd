extends StateMachine.State


func _on_enter(_previous):
    set_animation()

func set_animation():
    if target.direction<0:
        target.sprite.play("fire_left")
    elif target.direction>0:
        target.sprite.play("fire_right")


func _process(_delta):
    if target.sprite.frame >= target.sprite.frames.get_frame_count(target.sprite.animation)-1:
        target.fire()
        state_machine.transition("run")
    
    
func _physics_process(delta):
    target.move(delta)
    target.handle_fall_in_hole()

