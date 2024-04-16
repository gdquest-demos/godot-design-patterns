using Godot;
using System;

public class PowerReceiver : Node
{
    [Signal]
    public delegate void PowerReceived(float power, float delta);

    [Export]
    public float PowerRequired = 50.0f;

    public float Efficiency = 0.0f;
}
