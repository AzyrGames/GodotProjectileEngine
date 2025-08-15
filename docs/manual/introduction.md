# What is Godot Projectile Engine

The Godot Projectile Engine (**GPE**) is a specialized 2D add-on for the Godot 4 Engine. It helps you create customizable projectiles using **ProjectileTemplate2D** or **ProjectileNode2D**, design bullet patterns with a **PatternComposer** and **TimingScheduler**, and spawn bullets using a **ProjectileSpawner2D**. It handles all projectile collisions using Godot's built-in **Area2D** with no extra complex steps and uses Godot's signals for defined **Trigger** events.

GPE uses a modular component and behavior system to make the creation process easier, helping you create bullet patterns that are faster, more flexible, and efficient.

## Showcases

*(Showcases will be showing here)*

## Tutorials

*(Tutorials will be showing here)*

## What GPE is not

### A Particle System

You can use it for particles, but we don't recommend it. GPE comes with a lot of overhead and isn't optimized for this purpose when compared to Godot's built-in **CPUParticles2D** or **GPUParticles2D**.

### An Engine for Mass-Spawning Bullets

GPE does not aim to show the most bullets on the screen. There are many ways to create hundreds of thousands or even millions of bullets, such as using low-level draw calls, multi-mesh, or Godot Server, and most importantly, making use of the GPU. These methods, however, come with trade-offs that GPE is not willing to make, such as sacrificing the ability to control individual bullets and the ease of use.

### A Complete Bullet Hell **Game** Engine

The Godot Projectile Engine only handles when, where, what, and how projectiles are spawned. GPE doesn't manage damage, status effects, or other related systems. You can use **[Custom Data]** to store information about these systems and use it as needed.

## How GPE works
