extends StateMachine.State

func _on_enter(previous):
    # Only jump if we did not return here from blow state
    if previous != "blow":
        target.velocity.y = target.JUMP_SPEED
    
func get_input():
    target.velocity.x = (Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')) * target.SPEED
    if target.velocity.x != 0:
        target.last_movement = Vector2(target.velocity.x, 0)
    set_animation()
    var blow = Input.is_action_just_pressed("ui_select")
    if blow:
        state_machine.transition("blow")  

func set_animation():
    if target.velocity.x<0:
        target.sprite.play("jump_left")
    elif target.velocity.x>0:
        target.sprite.play("jump_right")
    else:
        target.sprite.play("idle")

func _process(_delta):
    get_input()

func _physics_process(delta): 
    target.move(delta)
    target.handle_fall_in_hole()
    if target.is_on_floor():
        if target.velocity.x == 0:
            state_machine.transition("idle")
        else:
            state_machine.transition("run")
            
