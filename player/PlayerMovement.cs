using Godot;
using System;

public class PlayerMovement : KinematicBody2D
{
	const float gravity = 600.0f;
	const int walkSpeed = 200;
	const int jumpForce = -300;

	Vector2 velocity;

	public override void _PhysicsProcess(float delta)
	{
		if (IsOnFloor()) 
		{
			velocity.y = 0;
		} 
		else {
			velocity.y += delta * gravity;
		}
		
		
		if (Input.IsActionPressed("ui_left"))
		{
			velocity.x = -walkSpeed;
		}
		else if (Input.IsActionPressed("ui_right"))
		{
			velocity.x = walkSpeed;
		}
		else
		{
			velocity.x = 0;
		}
		
		if (Input.IsActionJustPressed("ui_up") && IsOnFloor()) 
		{
			velocity.y = jumpForce;
		}

		// We don't need to multiply velocity by delta because "MoveAndSlide" already takes delta time into account.

		// The second parameter of "MoveAndSlide" is the normal pointing up.
		// In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
		MoveAndSlide(velocity, new Vector2(0, -1));
	}
}
