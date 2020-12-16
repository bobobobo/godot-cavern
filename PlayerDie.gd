extends StateMachine.State

func _on_enter(_previous):
    target.sprite.play("die")
    SoundEffectPlayer.play("die")
    target.velocity = Vector2(0, target.JUMP_SPEED)
    target.get_node("CollisionShape").disabled=true

    
func _physics_process(delta):
    if target.position.y > target.SCREEN_HEIGHT:
        target.get_node("CollisionShape").disabled=false
        target.trigger_death()
    else:
        target.move(delta)
