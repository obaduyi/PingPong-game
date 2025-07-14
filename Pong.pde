Paddle player1 = new Paddle(30, 300, 20, 100); 
Paddle player2 = new Paddle(770, 300, 20, 100);
int player1InitialY = 300; // Starting Y position for Player 1
int player2InitialY = 300;
Ball ball = new Ball(400, 300, 20, 20);

// Buttons
boolean wKey, sKey, iKey, kKey;

// Scoreboard
int player1Score = 2;
int player2Score = 2;
boolean gameOver = false, gameRunning = false;

boolean ballStuck = true; // Ball is stuck after scoring
boolean player1Start = true; // Determines which paddle holds the ball

void setup() {
  size(800, 600);
  noStroke();
}

void draw() {
  background(0);

  if (!gameRunning) {
    displayStartMessage();
    return;
  }

  if (gameOver) {
    displayGameOver();
    return;
  }

  player1.display();
  player2.display();
  ball.display();

  player1.movePlayer1();
  player2.movePlayer2();
  ball.move();

  // Scoreboard
  fill(255);
  textSize(28);
  text(player1Score, 32, 40);
  text(player2Score, width - 64, 40);
}

// Display start message
void displayStartMessage() {
  fill(255);
  textSize(30);
  textAlign(CENTER, CENTER);
  text("Press T to Start", width / 2, height / 2);
}

// Display game over message
void displayGameOver() {
  fill(255);
  textSize(50);
  textAlign(CENTER, CENTER);
  if (player1Score <= 0) {
    text("Game Over! Player 2 Wins", width / 2, height / 2);
  } else if (player2Score <= 0) {
    text("Game Over! Player 1 Wins", width / 2, height / 2);
  }
  textSize(30);
  text("Press N to Restart", width / 2, height / 2 + 50);
}

// Paddle class
class Paddle {
  int x, y;
  int paddleWidth, paddleHeight;
  final int velocity = 5;

  // Paddle constructor
  Paddle(int x, int y, int paddleWidth, int paddleHeight) {
    this.x = x;
    this.y = y;
    this.paddleWidth = paddleWidth;
    this.paddleHeight = paddleHeight;
  }

  void display() {
    fill(255);
    rectMode(CENTER);
    rect(x, y, paddleWidth, paddleHeight);
  }

  void movePlayer1() {
    if (wKey && y > paddleHeight / 2) {
      y -= velocity;
    }
    if (sKey && y < height - paddleHeight / 2) {
      y += velocity;
    }
  }

  void movePlayer2() {
    if (iKey && y > paddleHeight / 2) {
      y -= velocity;
    }
    if (kKey && y < height - paddleHeight / 2) {
      y += velocity;
    }
  }
}

// Button controls
void keyPressed() {
  if ((key == 't' || key == 'T') && !gameOver) {
    gameRunning = true;
  }
  if (key == 'n' || key == 'N') {
    resetGame();
  }
  if (key == 'c' || key == 'C') {
    ballStuck = false;
  }
  if (key == 'w' || key == 'W') wKey = true;
  if (key == 's' || key == 'S') sKey = true;
  if (key == 'i' || key == 'I') iKey = true;
  if (key == 'k' || key == 'K') kKey = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W') wKey = false;
  if (key == 's' || key == 'S') sKey = false;
  if (key == 'i' || key == 'I') iKey = false;
  if (key == 'k' || key == 'K') kKey = false;
}

void resetGame() {
  gameRunning = false;
  gameOver = false;
  player1Score = 2;
  player2Score = 2;
  
  // Reset paddles to their starting positions
  player1.y = player1InitialY;
  player2.y = player2InitialY;
  
  ball.resetBall();
}

// Ball class
class Ball {
  int x, y;
  int ballWidth, ballHeight;
  int x_velocity = (int(random(2)) * 8) - 4;
  int y_velocity = ((int)random(1) > 0.5) ? (int)random(3, 10) : (int)random(-10, -3);

  static final int TRAIL_LENGTH = 20;
  float[] trailX = new float[TRAIL_LENGTH];
  float[] trailY = new float[TRAIL_LENGTH];

  Ball(int x, int y, int ballWidth, int ballHeight) {
    this.x = x;
    this.y = y;
    this.ballWidth = ballWidth;
    this.ballHeight = ballHeight;

    for (int i = 0; i < TRAIL_LENGTH; i++) {
      trailX[i] = x;
      trailY[i] = y;
    }
  }

  void display() {
    noStroke();

    for (int i = TRAIL_LENGTH - 1; i >= 0; i--) {
      float alpha = map(i, 0, TRAIL_LENGTH - 1, 255, 20);
      float size = map(i, 0, TRAIL_LENGTH - 1, ballWidth, ballWidth / 2);

      fill(255, 255, 255, alpha);
      ellipse(trailX[i], trailY[i], size, size);
    }

    fill(255);
    ellipse(x, y, ballWidth, ballHeight);
  }

  void move() {
    if (ballStuck) return;

        // Shift previous positions to the right
    for (int i = TRAIL_LENGTH - 1; i > 0; i--) {
      trailX[i] = trailX[i - 1];
      trailY[i] = trailY[i - 1];
    }

        // Store the new position at the front
    trailX[0] = x;
    trailY[0] = y;
       
        // Move the ball
    x += x_velocity;
    y += y_velocity;

        // Bounce off top and bottom walls
    if (y <= ballHeight / 2 || y >= height - ballHeight / 2) {
      y_velocity *= -1;
    }
    // **Check for collisions with paddles**
    if (x - ballWidth / 2 <= player1.x + player1.paddleWidth / 2 &&  // Ball reaches left paddle
        y >= player1.y - player1.paddleHeight / 2 && y <= player1.y + player1.paddleHeight / 2) {
        x_velocity *= -1; // Reverse direction
        x = player1.x + player1.paddleWidth / 2 + ballWidth / 2; // Prevent sticking
    }

    if (x + ballWidth / 2 >= player2.x - player2.paddleWidth / 2 &&  // Ball reaches right paddle
        y >= player2.y - player2.paddleHeight / 2 && y <= player2.y + player2.paddleHeight / 2) {
        x_velocity *= -1; // Reverse direction
        x = player2.x - player2.paddleWidth / 2 - ballWidth / 2; // Prevent sticking
    }

    // Check for scores
    if (x < 0) {
        player1Score--;
        resetBallEveryRound(false);
    } else if (x > width) {
        player2Score--;
        resetBallEveryRound(true);
    }

    // Check for game over
    if (player1Score <= 0 || player2Score <= 0) {
        gameOver = true;
    }
  }

  void resetBall() {
    x = width / 2;
    y = height / 2;
    
    ballStuck = true;
    player1Start = true;

    for (int i = 0; i < TRAIL_LENGTH; i++) {
      trailX[i] = x;
      trailY[i] = y;
    }
  }

  void resetBallEveryRound(boolean player1Scored) {
    ballStuck = true;
   
   // Position the ball near Player 1's paddle
    if (player1Scored) {
        x = player1.x + player1.paddleWidth / 2 + ballWidth / 2; 
        y = player1.y;
    } else {
      // Position the ball near Player 2's paddle
        x = player2.x - player2.paddleWidth / 2 - ballWidth / 2;
        y = player2.y;
    }
    player1Start = player1Scored;
    
    //Ball x-velocity: Randomly choose either −4 or 4 (not between).
    x_velocity = (int(random(2)) * 8) - 4;
    
    //Ball y-velocity: Randomly choose in the ranges of either [−10, −3) or [3, 10).
    if (random(1) > 0.5) {
        y_velocity = int(random(3, 10));  // Positive velocity
    } else {
        y_velocity = -int(random(3, 10)); // Negative velocity
    }
    
          // Reset the trail to the new starting position
    for (int i = 0; i < TRAIL_LENGTH; i++) {
        trailX[i] = x;
        trailY[i] = y;
    }
    
  }
}
