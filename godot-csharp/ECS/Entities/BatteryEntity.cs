using Godot;
using System;
using System.Threading.Tasks;

public class BatteryEntity : Node2D
{
    /// <summary>
    /// Total amount of power the battery is able to hold
    /// </summary>
    [Export]
    public float MaxStorage = 1000.0f;

    /// <summary>
    /// Actual amount of power currently in the battery
    /// </summary>
    private float _storedPower = 0.0f;
    public float StoredPower
    {
        get { return _storedPower; }
        set { SetStoredPower(value); }
    }

    private PowerReceiver receiver;
    private PowerSource source;
    private Sprite indicator;

    public override void _Ready()
    {
        // onready equivalent doesn't exist in C#
        receiver = GetNode<PowerReceiver>("PowerReceiver");
        source = GetNode<PowerSource>("PowerSource");
        indicator = GetNode<Sprite>("Indicator");
    }

    private void SetStoredPower(float value)
    {
        _storedPower = value;

        // Make sure all nodes are ready
        if (!this.IsInsideTree())
        {
            Task.Run(async () => await ToSignal(this, "ready"));
        }

        // Set receiver efficiency to 0 if already full, otherwise set it to a percentage
        // of power that it can still receive from its input capacity.
        receiver.Efficiency = _storedPower >= MaxStorage ?
                              0.0f :
                              Math.Min((MaxStorage - _storedPower) / receiver.PowerRequired, 1.0f);

        source.Efficiency = _storedPower <= 0 ?
                            0.0f :
                            Math.Min(_storedPower / source.PowerAmount, 1.0f);

        // Update shader with power amount so the indicator is up to date with amount
        var shader = (ShaderMaterial)indicator.Material;
        shader.SetShaderParam("amount", _storedPower / MaxStorage);
        indicator.Material = shader;
    }

    /// <summary>
    /// Reduce the amount of power in the battery by the power value per second
    /// </summary>
    /// <param name="power"></param>
    /// <param name="delta"></param>        
    private void OnPowerSourcePowerDrawn(float power, float delta)
    {
        StoredPower = Math.Max(0, _storedPower - Math.Min(power, source.PowerAmount * source.Efficiency) * delta);
    }

    /// <summary>
    /// Increase the amount of power in the battery by the power value per second
    /// </summary>
    /// <param name="power"></param>
    /// <param name="delta"></param>
    private void OnPowerReceiverPowerReceived(float power, float delta)
    {
        StoredPower = Math.Min(MaxStorage, _storedPower + power * delta);
    }
}
