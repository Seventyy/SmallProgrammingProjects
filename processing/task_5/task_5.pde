import java.util.ArrayList;

CelestialBody sun;
ArrayList<CelestialBody> planets = new ArrayList<>();
ArrayList<CelestialBody> moons = new ArrayList<>();

float delta;

void setup() {
  size(2560, 1440, P3D);
  noStroke();
  

  fill(255, 209, 102);
  //specular(255, 255, 255);
  emissive(255, 209, 102); 
  sun = new CelestialBody(createShape(SPHERE, 75));
  //pointLight(255, 255, 204, 0, 0, 0);
  
  
  emissive(0, 0, 0); 
  fill(239, 71 , 111);
  PShape planet_1 = loadShape("icosahedron.obj");
  planet_1.setTexture(loadImage("planet_1_texture.png")); 
  planets.add(new CelestialBody(sun, 20.0/2, 100.0, 0.26*PI, planet_1));

  fill(247, 140, 107);
  PShape planet_2 = loadShape("icosahedron.obj");
  planet_2.setTexture(loadImage("planet_2_texture.png"));
  specular(255, 255, 255);
  planets.add(new CelestialBody(sun, 25.0/2, 210.0, 0.19*PI, planet_2));

  fill(6  , 214, 160);
  PShape planet_3 = loadShape("icosahedron.obj");
  planet_3.setTexture(loadImage("planet_3_texture.png"));
  planets.add(new CelestialBody(sun, 60.0/2, 350.0, 0.09*PI, planet_3));

  fill(17 , 138, 178);
  PShape planet_4 = loadShape("icosahedron.obj");
  planet_4.setTexture(loadImage("planet_4_texture.png"));
  planets.add(new CelestialBody(sun, 50.0/2, 490.0, 0.03*PI, planet_4));

  fill(244, 107, 139);
  moons.add(new CelestialBody(planets.get(0), 11.0, 25.0,-0.93*PI, createShape(BOX, 1)));
  fill(249, 153, 175);  
  moons.add(new CelestialBody(planets.get(0), 9.0, 35.0, -0.73*PI, createShape(BOX, 1)));
  
  fill(255, 173, 147);  
  moons.add(new CelestialBody(planets.get(1), 13.0, 22.5, 0.79*PI, createShape(BOX, 1)));
  fill(255, 205, 189);  
  moons.add(new CelestialBody(planets.get(1), 10.0, 37.5,-0.39*PI, createShape(BOX, 1)));
  
  fill(47 , 219, 176);  
  moons.add(new CelestialBody(planets.get(2), 12.0, 47.5,-0.86*PI, createShape(BOX, 1)));
  fill(90 , 225, 191);  
  moons.add(new CelestialBody(planets.get(2), 14.0, 62.5,-0.60*PI, createShape(BOX, 1)));
  
  fill(89 , 175, 203);  
  moons.add(new CelestialBody(planets.get(3), 18.0, 40.0, 0.40*PI, createShape(BOX, 1)));


} 

void draw() {
  delta = 1/frameRate;
  
  directionalLight(255, 255, 255, 0, 1, -1); 

  
  background(7, 59, 76);
  //lights();
  
  sun.display();
  for (CelestialBody planet : planets) { planet.display(); }
  for (CelestialBody moon : moons) { moon.display(); }
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
  
  CelestialBody(PShape _shape) {
    primary = null;
    distance = 0.0;
    speed = 0.0;
    scale = 1.0;
    shape = _shape;

    global_position = new PVector(width/2, height/2);
    relative_position = new PVector(0, 0);
  }

  CelestialBody(CelestialBody _primary, float _scale, float _distance, float _speed, PShape _shape) {
    primary = _primary;
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
    } else {
      pointLight(255, 255, 204, global_position.x, global_position.y, 0);
    }
    
    pushMatrix();
    translate(global_position.x, global_position.y, 0);
    shape(shape);
    popMatrix();

    relative_position.rotate(speed * delta);
  }
}
