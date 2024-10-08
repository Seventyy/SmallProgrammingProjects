import java.util.ArrayList;
import java.util.Arrays;

PImage bg;

ArrayList<Planet> planets = new ArrayList<>();

void setup() {
  size(1280, 720);
  noStroke();

  bg = loadImage("bg.bmp");
  
  planets.add(new Planet(color(20 , 75 , 160), 35, 120.0, 1.2*PI, new ArrayList<>(Arrays.asList(
    new Moon(color(210, 220, 230), 6.0, 35.0, 2.2*PI)
  ))));

  planets.add(new Planet(color(150, 80 , 250), 25, 200.0, 0.8*PI, new ArrayList<>(Arrays.asList(
    new Moon(color(250, 80 , 25 ), 9.0, 27.5, 2.4*PI),
    new Moon(color(100, 200, 100), 4.0, 37.5, 1.2*PI)
  ))));

  planets.add(new Planet(color(200, 0  , 40 ), 60, 360.0, 0.3*PI, new ArrayList<>(Arrays.asList(
    new Moon(color(0  , 250, 150), 8.0, 50.0, 2.6*PI),
    new Moon(color(250 , 70 , 10 ), 5.5, 62.5, 1.8*PI)
  ))));

  planets.add(new Planet(color(80 , 250, 130), 50, 500.0, 0.2*PI, new ArrayList<>(Arrays.asList(
    new Moon(color(70 , 220, 150), 6.5, 35.0, 1.2*PI),
    new Moon(color(90 , 260, 210), 10.0, 60.0, 2.8*PI)
  ))));
} 

void draw() {
  background(bg);
  
  translate(width/2, height/2);

  fill(color(250, 250, 100));
  ellipse(0, 0, 80, 80);
  for (Planet planet : planets) { 
    planet.update();
    planet.draw(); 
  }
}

class Planet {
  color body_color;
  float size;
  float distance;
  float angular_velocity;
  ArrayList<Moon> moons;

  PVector position;

  Planet(color _body_color, float _size, float _distance, float _angular_velocity, ArrayList<Moon> _moons) {
    body_color = _body_color;
    size = _size;
    distance = _distance;
    angular_velocity = _angular_velocity;
    moons = _moons;

    position = new PVector(distance, 0);
    position.rotate(random(0, TWO_PI));
  }
 
  void draw() {
    fill(body_color);
    ellipse(position.x, position.y, size, size);
    
    for (Moon moon : moons) {
      fill(moon.body_color);
      ellipse(position.x + moon.position.x, position.y + moon.position.y, moon.size, moon.size);
    }
  }

  void update() {
    position.rotate(angular_velocity / 60);
    for (Moon moon : moons) {
      moon.position.rotate(moon.angular_velocity / 60);
    }
  }
}

class Moon {
  color body_color;
  float size;
  float distance;
  float angular_velocity;

  PVector position;

  Moon(color _body_color, float _size, float _distance, float _angular_velocity) {
    body_color = _body_color;
    size = _size;
    distance = _distance;
    angular_velocity = _angular_velocity;

    position = new PVector(distance, 0);
    position.rotate(random(0, TWO_PI));
  }
}
