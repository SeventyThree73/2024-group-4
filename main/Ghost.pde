//<<<<<<< main
final int UP = 1;
final int RIGHT = 2;
final int DOWN = 3;
final int LEFT = 4;


abstract class Ghost {
  int x, y; // Ghost's position
  int direction; // Ghost's movement direction
  int speed;
  GameMap map; // Reference to the game map
  Pacman pacman; // Reference to the player
  Pathfinder pf;
  long lastSwitchTime = 0; // Time of the last state switch
  int cellSize;
  boolean caughtPacman;

  int targetRow;
  int targetCol;
  int[] colour = {255, 0, 0};
    
  // Constructor
  Ghost(int startX, int startY, Pacman pacman, GameMap map, Pathfinder pf) {
    this.x = startX;
    this.y = startY;
    this.pacman = pacman;
    this.map = map;
    this.pf = pf;
    this.direction = (int)random(8); // Randomly initialize movement direction
    this.lastSwitchTime = 0;
    this.cellSize = map.cellSize;
    this.caughtPacman = false;
    this.speed = 100 * difficulty;
  }
  
  
  // Draw ghost methods
  // abstract void drawBlinky();
  // abstract void drawPinky();
  // abstract void drawInky();
  // abstract void drawClyde();


  // Update the ghost's position
  void update() {
    boolean speed_slow = false;
    boolean speed_stop = false;
    for (int i = 0; i < map.map.length; i++) {
      for (int j = 0; j < map.map[i].length; j++) {
        if (map.map[i][j] == 4) {
          speed_slow = true;
          speed = 100 * difficulty * 2;
        }
        if (map.map[i][j] == 6) {
          speed_stop = true;
        }
      }
    }
    if (!speed_slow) {
      speed = 100 * difficulty;
    }  
    direction = (int)random(8); // Randomly change direction
    if (!speed_stop) {
      move();  
    }
  }
  
  // Method to draw the ghost
  void drawGhost() {
    int baseX = x * cellSize + cellSize / 2;
    int baseY = y * cellSize + cellSize / 2;
    fill(colour[0], colour[1], colour[2]); // Set color

    noStroke();

    // Draw the body
    beginShape();
    // Semi-circular top
    arc(baseX, baseY, cellSize, cellSize, PI, TWO_PI);
    rect(baseX-cellSize/2, baseY, cellSize, cellSize/4);
    // Wavy bottom
    int wavySectionWidth = cellSize / 4;
    for (int i = 0; i < 4; i++) {
      int startX = baseX - cellSize / 2 + i * wavySectionWidth;
      int endX = startX + wavySectionWidth;
      arc((startX + endX)/2, baseY + cellSize/4, wavySectionWidth*0.75, wavySectionWidth*1.9, 0, PI);
    }
    endShape(CLOSE);

    // Draw the eyes
    fill(255); // White eyes
    ellipse(baseX - cellSize / 4, baseY - cellSize / 4, cellSize / 4, cellSize / 4);
    ellipse(baseX + cellSize / 4, baseY - cellSize / 4, cellSize / 4, cellSize / 4);
    
    // Draw the pupils
    fill(0); // Black pupils
    ellipse(baseX - cellSize / 4, baseY - cellSize / 4, cellSize / 8, cellSize / 8);
    ellipse(baseX + cellSize / 4, baseY - cellSize / 4, cellSize / 8, cellSize / 8);
  }


  // Toggle Ghost's state based on time
  void toggleGhostState() {
    targetMethod();
    if ( reachedTarget() ) {
      caughtPacman = true;
    }
    
    if (millis() - lastSwitchTime > speed) { // Check if X milliseconds have passed to update direction more frequently
      if (!map.checkPause()) {
        update();
      }
      lastSwitchTime = millis(); // Update switch time
    }
  }
  
  
  // Move ghost
  void move() {
    pf.setGrid(x, y, targetCol, targetRow);

    if ( pf.traverse() ) {
      
      x = pf.optimalPath.get(0).x;
      y = pf.optimalPath.get(0).y;
    }
    else { // Ghost is completely blocked off -> move randomly until able to reach target again
      randomMove();
    }
  }
  
  
  // If ghost blocked and cannot find target -> move randomly
  void randomMove() {
    
    int newX = -1;
    int newY = -1;
    
    // Get valid move
    while ( !map.checkMove(newX, newY) ) {
      
      int direction = (int) random(1, 5);
    
      switch (direction) {
      
      case UP:
        newX = this.x;
        newY = this.y - 1;
        break;
      case RIGHT:
        newX = this.x + 1;
        newY = this.y;
        break;
      case DOWN:
        newX = this.x;
        newY = this.y + 1;
        break;
      case LEFT:
        newX = this.x - 1;
        newY = this.y;
        break;
      default:
        break;
      }
      
    }
    
    // Update position
    this.x = newX;
    this.y = newY;
    
  }
  
  
  // Check if a ghost has caught pacman -> game over
  boolean reachedTarget() {
    // TODO
    // println("#######################");
    // println(x, y);
    // println(pacman.getCurrentNode());
    if ( this.x == pacman.getCurrentNode()[0] && this.y == pacman.getCurrentNode()[1] ) {
      return true;
    }
    
    return false;
  }
  
  void targetMethod() {
    targetRow = pacman.y;
    targetCol = pacman.x;
  }
}


class Blinky extends Ghost {
  // Constructor
  Blinky(int startX, int startY, Pacman pacman, GameMap map, Pathfinder pf) {
    super(startX, startY, pacman, map, pf);
    this.colour = new int[]{255, 0, 0};
  }
}


class Pinky extends Ghost {
  // Constructor
  Pinky(int startX, int startY, Pacman pacman, GameMap map, Pathfinder pf) {
    super(startX, startY, pacman, map, pf);
    this.colour = new int[]{245, 151, 198};
  }

  // Get Pinky's target node
  @Override
  void targetMethod() {
    int[] target = {x, y};
    switch(pacman.getCurrentDirection() + 1) {
      case UP:
        target[0] = pacman.x;
        target[1] = pacman.y - 2;
        break;
      case RIGHT:
        target[0] = pacman.x + 2;
        target[1] = pacman.y;
        break;
      case DOWN:
        target[0] = pacman.x;
        target[1] = pacman.y + 2;
        break;
      case LEFT:
        target[0] = pacman.x - 2;
        target[1] = pacman.y;
        break;
      default:
        break;
    }
    
    if (map.checkMove(target[0], target[1])) {
    }
    else {
      target[0] = x;
      target[1] = y;
    }
    targetRow = target[1];
    targetCol = target[0];
  }
}
