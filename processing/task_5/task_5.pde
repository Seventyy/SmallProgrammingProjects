import java.util.ArrayList;

CelestialBody sun;
ArrayList<CelestialBody> planets = new ArrayList<>();
ArrayList<CelestialBody> moons = new ArrayList<>();
PShape icosahedron;

float camX, camY, camZ;
float camSpeed = 5.0;

float delta;

void setup() {
  icosahedron = loadShape("icosahedron.obj");
  
  // size(800, 600, P3D); 
  camX = width / 2;
  camY = height / 2;
  camZ = (height/2.0) / tan(PI*60.0 / 360.0);
  perspective(PI/3.0, float(width)/float(height), camZ/10.0, camZ*10.0);


  size(1280, 720, P3D);
  //noStroke();

  sun = new CelestialBody(color(255, 209, 102), 75.0, createShape(SPHERE, 1));
  
  //planets.add(new CelestialBody(sun, color(239, 71 , 111), 20.0, 100.0, 0.26*PI, icosahedron));
  //planets.add(new CelestialBody(sun, color(247, 140, 107), 25.0, 210.0, 0.19*PI, icosahedron));
  //planets.add(new CelestialBody(sun, color(6  , 214, 160), 60.0, 350.0, 0.09*PI, icosahedron));
  //planets.add(new CelestialBody(sun, color(17 , 138, 178), 50.0, 490.0, 0.03*PI, icosahedron));

  //moons.add(new CelestialBody(planets.get(0), color(244, 107, 139), 11.0, 25.0, -0.93*PI, createShape(BOX, 1)));
  //moons.add(new CelestialBody(planets.get(0), color(249, 153, 175), 9.0, 35.0, -0.73*PI, createShape(BOX, 1)));
  
  //moons.add(new CelestialBody(planets.get(1), color(255, 173, 147), 13.0, 22.5, 0.79*PI, createShape(BOX, 1)));
  //moons.add(new CelestialBody(planets.get(1), color(255, 205, 189), 10.0, 37.5, -0.39*PI, createShape(BOX, 1)));
  
  //moons.add(new CelestialBody(planets.get(2), color(47 , 219, 176), 12.0, 47.5, -0.86*PI, createShape(BOX, 1)));
  //moons.add(new CelestialBody(planets.get(2), color(90 , 225, 191), 14.0, 62.5, -0.60*PI, createShape(BOX, 1)));
  
  //moons.add(new CelestialBody(planets.get(3), color(89, 175, 203), 18.0, 40.0, 0.40*PI, createShape(BOX, 1)));

} 

void draw() {
  delta = 1/frameRate;
  background(7, 59, 76);
  lights();
  
  sun.display();
  for (CelestialBody planet : planets) { planet.display(); }
  for (CelestialBody moon : moons) { moon.display(); }

  updateCamera();
  camera(camX, camY, camZ, width/2.0, height/2.0, 0, 0, 1, 0);
  
}

void updateCamera() {
  if (keyPressed) {
    if (key == 'w') {
      camY -= camSpeed;
    } else if (key == 's') {
      camY += camSpeed;
    } else if (key == 'a') {
      camX -= camSpeed;
    } else if (key == 'd') {
      camX += camSpeed;
    } else if (key == 'q') {
      camZ += camSpeed;
    } else if (key == 'e') {
      camZ += camSpeed;
    }
  }
}

class CelestialBody {
  CelestialBody primary;
  color colorr;
  float scale;
  float distance;
  float speed;
  PShape shape;

  PVector global_position;
  PVector relative_position;
  
  CelestialBody(color _colorr, float _scale, PShape _shape) {
    primary = null;
    distance = 0.0;
    speed = 0.0;
    scale = _scale;
    colorr = _colorr;
    shape = _shape;

    global_position = new PVector(width/2, height/2);
    relative_position = new PVector(0, 0);
    
    // shape.scale(scale);
  }

  CelestialBody(CelestialBody _primary, color _colorr, float _scale, float _distance, float _speed, PShape _shape) {
    primary = _primary;
    colorr = _colorr;
    scale = _scale;
    distance = _distance;
    speed = _speed;
    shape = _shape;

    relative_position = new PVector(distance, 0);
    relative_position.rotate(random(0, TWO_PI));
    global_position = new PVector(0,0);

    shape.scale(scale);
  }
 
  void display() {
    if (primary != null) {
      global_position.x = primary.global_position.x + relative_position.x;
      global_position.y = primary.global_position.y + relative_position.y;
    }
    
    
    fill(colorr);
    pushMatrix();
    translate(global_position.x, global_position.y, 0);
    shape(shape);
    popMatrix();

    relative_position.rotate(speed * delta);
  }
}
