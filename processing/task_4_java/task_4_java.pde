import java.util.ArrayList;

CelestialBody sun;
ArrayList<CelestialBody> planets = new ArrayList<>();
ArrayList<CelestialBody> moons = new ArrayList<>();
ArrayList<Asteroid> asteroids = new ArrayList<>();

ArrayList<CelestialBody> attractors = new ArrayList<>();


float delta = 1 / frameRate;

void setup() {
  size(1280, 720);
  noStroke();

  sun = new CelestialBody(color(255, 209, 102), 75.0);
  
  planets.add(new CelestialBody(sun, color(239, 71 , 111), 20.0, 100.0, 0.26*PI));
  planets.add(new CelestialBody(sun, color(247, 140, 107), 25.0, 210.0, 0.19*PI));
  planets.add(new CelestialBody(sun, color(6  , 214, 160), 60.0, 350.0, 0.09*PI));
  planets.add(new CelestialBody(sun, color(17 , 138, 178), 50.0, 490.0, 0.03*PI));

  moons.add(new CelestialBody(planets.get(0), color(244, 107, 139), 11.0, 25.0, 0.93*PI));
  moons.add(new CelestialBody(planets.get(0), color(249, 153, 175), 9.0, 35.0, 0.73*PI));
  
  moons.add(new CelestialBody(planets.get(1), color(255, 173, 147), 13.0, 22.5, 0.79*PI));
  moons.add(new CelestialBody(planets.get(1), color(255, 205, 189), 10.0, 37.5, 0.39*PI));
  
  moons.add(new CelestialBody(planets.get(2), color(47 , 219, 176), 12.0, 47.5, 0.86*PI));
  moons.add(new CelestialBody(planets.get(2), color(90 , 225, 191), 14.0, 62.5, 0.60*PI));
  
  moons.add(new CelestialBody(planets.get(3), color(89, 175, 203), 18.0, 40.0, 0.40*PI));

  attractors.add(sun);
  attractors.addAll(planets);
  attractors.addAll(moons);
} 

void draw() {
  background(7, 59, 76);
  
  sun.display();
  for (CelestialBody planet : planets) { planet.display(); }
  for (CelestialBody moon : moons) { moon.display(); }
  for (Asteroid asteroid : asteroids) { asteroid.display(attractors); }
}

PVector drag_start;

void mousePressed() {
  drag_start = new PVector(mouseX, mouseY);
}

void mouseReleased() {
  Asteroid asteroid = new Asteroid(drag_start); 
  asteroid.velocity = PVector.sub(new PVector(mouseX, mouseY), drag_start).mult(2.5);
  asteroids.add(asteroid);
}

class CelestialBody {
  CelestialBody primary;
  color colorr;
  float diameter;
  float distance;
  float speed;

  PVector global_position;
  PVector relative_position;
  
  CelestialBody(color _colorr, float _diameter) {
    primary = null;
    distance = 0.0;
    speed = 0.0;
    diameter = _diameter;
    colorr = _colorr;

    global_position = new PVector(width/2, height/2);
    relative_position = new PVector(0, 0);
  }

  CelestialBody(CelestialBody _primary, color _colorr, float _diameter, float _distance, float _speed) {
    primary = _primary;
    colorr = _colorr;
    diameter = _diameter;
    distance = _distance;
    speed = _speed;

    relative_position = new PVector(distance, 0);
    relative_position.rotate(random(0, TWO_PI));
    global_position = new PVector(0,0);
  }
 
  void display() {
    if (primary != null) {
      global_position.x = primary.global_position.x + relative_position.x;
      global_position.y = primary.global_position.y + relative_position.y;
    }
    
    fill(colorr);
    ellipse(global_position.x, global_position.y, diameter, diameter);

    relative_position.rotate(speed * delta);
  }
}

class Asteroid {
  float g_constant;
  float speed;
  
  PVector force;
  PVector velocity;
  PVector position;
  
  Asteroid(PVector _position) {
    g_constant = 25.0;
    force = new PVector(0,0);
    velocity = new PVector(0,0);
    position = _position;
  }
 
  void display(ArrayList<CelestialBody> attractors) {

    for (CelestialBody attractor : attractors) {
      float distance = PVector.sub(attractor.global_position, position).mag();
      if (distance <= attractor.diameter/2) {
         velocity.rotate(PI);
         velocity.mult(1.2);
         position = PVector.add(attractor.global_position, PVector.sub(position, attractor.global_position).normalize().mult(attractor.diameter/2));
      }
      PVector direction = PVector.sub(attractor.global_position, position).normalize();
      float magnitude = pow(attractor.diameter, 2.0) / pow(distance, 2.0) * g_constant;
      force.add(PVector.mult(direction, magnitude));
    }
    
    fill(150);
    ellipse(position.x, position.y, 10, 10);
    
    velocity.add(force);
    position.add(PVector.mult(velocity, delta));
    force = new PVector(0,0);
  }
}
