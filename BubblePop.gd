extends StateMachine.State


func _on_enter(_previous):
    target.velocity = Vector2.ZERO
    target.sprite.play("pop")    
    yield(target.sprite,"animation_finished")
    target.queue_free()
    

    
    
