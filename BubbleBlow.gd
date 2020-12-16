extends StateMachine.State

const SPEED = 200

var initial_x


func _on_enter(_previous_state):
    target.velocity.x = target.direction * SPEED
    initial_x = target.position.x
    SoundEffectPlayer.play("blow")
    target.sprite.play("blow")

    
func _process(_delta):
    if target.sprite.frame >= target.sprite.frames.get_frame_count("blow")-1:
        target.sprite.play("float")

func _physics_process(delta):
    target.velocity.x +=  target.direction * SPEED * delta
    target.move(delta)
    if target.is_on_wall():
        state_machine.transition("float")
        
    if abs(initial_x-target.position.x) > 200:
        state_machine.transition("float")
        
    if target.trigger_enemies.size() > 0:
        state_machine.transition("captured")

            

