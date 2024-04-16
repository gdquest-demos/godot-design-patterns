using Godot;
using System;

public class PowerSource : Node
{
    [Signal]
    public delegate void PowerDrawn(float power, float delta);

    [Export]
    public float PowerAmount = 50.0f;

    public float Efficiency = 0.0f;
}
