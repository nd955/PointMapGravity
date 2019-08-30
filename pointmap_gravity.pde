int numShapes = 3;
ArrayList<MovingShape> shapes = new ArrayList();
int vertices = 1;
int radius = 20;
PVector pBound = new PVector(1920, 1080);
PVector vBound = new PVector(.1, .1);
int numGravityPoints = 10;
ArrayList<GravityPoint> gravityPoints = new ArrayList();
float forceBound = 0.75;
float friction = 0.5;
boolean leaveTrail = true;
boolean randomColors = true;
color backgroundColor;

void setup() {
  size(1920, 1080);
  
  if(randomColors) {
    backgroundColor = color(random(0,255),random(0,255),random(0,255),random(0,255));
  } else {
    backgroundColor = color(255);
  }
  background(backgroundColor);
  
  for(int i = 0; i < numGravityPoints; i++) {
    gravityPoints.add(new GravityPoint(pBound, forceBound));
  }
  
  for(int i = 0; i < numShapes; i++) {
    shapes.add(new MovingShape(vertices, pBound, vBound));
  }
}

void draw() {
  if(!leaveTrail) {
    background(backgroundColor);
  }
  for(MovingShape s : shapes) {
    s.draw();
    s.update();
  }
}

PVector createRandomPoint(float xBound, float yBound) {
  PVector point = new PVector(random(0,xBound), random(0,yBound));
  return point;
}

void keyPressed() {
  if(key == 's') {
    saveFrame("pointmap-gravity-####.png");
  }
}

class MovingShape {
  ArrayList<PVector> positions;
  ArrayList<PVector> velocities;
  int vertices;

  color col;
  
  MovingShape(int vertices, PVector positionBound, PVector velocityBound) {
    this.vertices = vertices;
    positions = new ArrayList();
    velocities = new ArrayList();
    
    for(int i = 0; i < vertices; i++) {
      positions.add(createRandomPoint(positionBound.x, positionBound.y));
      velocities.add(createRandomPoint(velocityBound.x, velocityBound.y));
    }
    
    if(randomColors) {
      this.col = color(random(0,255),random(0,255),random(0,255),random(0,255));
    } else {
      this.col = color(0);
    }
  }
  
  void draw() {
    stroke(this.col);
    fill(this.col);
    if(vertices == 1) {
      ellipse(positions.get(0).x, positions.get(0).y, radius, radius);
    } else {
      strokeWeight(radius);
      beginShape();
        for(int i = 0; i < vertices; i++) {
          vertex(positions.get(i).x, positions.get(i).y);
        }
      endShape(CLOSE);
    }
  }
  
  void update() {
    for(int i = 0; i < vertices; i++) {
      positions.get(i).add(velocities.get(i));
      
      PVector acceleration = new PVector(0,0);
      for(int j = 0; j < numGravityPoints; j++) {
        PVector gravityVector = new PVector(gravityPoints.get(j).position.x, gravityPoints.get(j).position.y);
        gravityVector.sub(positions.get(i));
        gravityVector.mult(gravityPoints.get(j).force);
        
        acceleration.add(gravityVector);
      }
      
      velocities.get(i).add(acceleration);
      
      if(positions.get(i).x < 0) {
        velocities.get(i).x = (abs(velocities.get(i).x) * friction);
      } else if (positions.get(i).x > pBound.x) {
        velocities.get(i).x = (-1 * abs(velocities.get(i).x) * friction);
      }
      if(positions.get(i).y < 0) {
        velocities.get(i).y = (abs(velocities.get(i).y) * friction);
      } else if(positions.get(i).y > pBound.y) {
        velocities.get(i).y = (-1 * abs(velocities.get(i).y) * friction);
      }
    }
  }
}

class GravityPoint {
  PVector position;
  float force;
  GravityPoint(PVector positionBound, float forceBound) {
    this.position = createRandomPoint(positionBound.x, positionBound.y);
    this.force = random(0,forceBound);
  }
}
