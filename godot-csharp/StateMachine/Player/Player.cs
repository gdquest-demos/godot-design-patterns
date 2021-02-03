using Godot;
using System;

public class Player : KinematicBody2D
{
    public int Speed = 500;
    public int JumpImpulse = 1200;
    public int Gravity = 3500;

    public Vector2 Velocity = new Vector2();

    public Label label;
    public StateMachine _stateMachine;

    public override void _Ready()
    {
        label = GetNode<Label>("Label");
        _stateMachine = GetNode<StateMachine>("StateMachine");
    }

    public override void _Process(float delta)
    {
        label.Text = _stateMachine.State.Name;
    }
}