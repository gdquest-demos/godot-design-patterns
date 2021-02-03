using Godot;
using System;
using System.Collections.Generic;

// The GD tutorial has this class named "Jump.gd". However, in C#, 
// the name of a class is also its type, and should always be the node's 
// name to avoid problems down the line.
public class Air : PlayerState
{
    /// <summary>
    /// If we get a message asking us to jump, we jump.
    /// </summary>
    /// <param name="message"></param>
    public override void Enter(Dictionary<string, bool> message = null)
    {
        if (message != null &&
            message.ContainsKey("doJump") &&
            message["doJump"] == true)
        {
            _player.Velocity.y = -_player.JumpImpulse;
        }
    }

    public override void PhysicsUpdate(float delta)
    {
        // Horizontal movement
        var inputDirectionX = Input.GetActionStrength("move_right") - Input.GetActionStrength("move_left");

        // Vertical Movement
        _player.Velocity.x = _player.Speed * inputDirectionX;
        _player.Velocity.y += _player.Gravity * delta;
        _player.Velocity = _player.MoveAndSlide(_player.Velocity, Vector2.Up);

        // Landing
        if (_player.IsOnFloor())
        {
            if (Godot.Mathf.IsEqualApprox(_player.Velocity.x, 0.0f))
            {
                _stateMachine.TransitionTo("Idle");
            }
            else
            {
                _stateMachine.TransitionTo("Run");
            }
        }
    }
}
