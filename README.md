# Two-Player-PingPong-game

#### Video Demo:  https://youtu.be/p3WMn39f5LU 

#### Description:

This project is a two-player Pong game implemented in Java using the Swing GUI framework. It simulates a classic arcade-style table tennis match, where each player controls a vertical paddle on opposite sides of the screen to hit a moving ball. The goal is to prevent the ball from passing your paddle while trying to score points against the opponent.
What I learned from developing this project were being able to developed a real-time interactive game using standard Java. Gained experience with event-driven programming and game loops. Applied object-oriented programming (OOP) principles to manage game entities. Practiced GUI development using Swing, and managed rendering and timing.

How It Works:

The game window opens with a welcome screen prompting users to press T to start. Two players control paddles on the left and right using the keyboard:

Player 1: W and S keys to move up and down

Player 2: I and K keys to move up and down

A ball starts stuck to the serving player's paddle. After pressing C, the ball is released. It bounces off the top and bottom walls, and if it hits a paddle, it rebounds. If it passes a paddle, the opposing player scores. Each player starts with 2 lives; if the ball passes them, their score decreases. The game ends when one player's score hits zero, and a "Game Over" message displays with the winner.
