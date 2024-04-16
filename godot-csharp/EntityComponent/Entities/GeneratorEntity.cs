using Godot;
using System;

public class GeneratorEntity : Node2D
{
    private AnimationPlayer _animationPlayer;
    private PowerSource _powerSource;

    public override void _Ready()
    {
        _animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
        _animationPlayer.Play("Work");

        _powerSource = GetNode<PowerSource>("PowerSource");
        _powerSource.Efficiency = 1.0f;
    }

    private void OnPowerSourcePowerDrawn(float power, float delta)
    {
        var proportion = power / _powerSource.PowerAmount;
        _animationPlayer.PlaybackSpeed = proportion;
    }
}
