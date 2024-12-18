import java.util.ArrayList;

CelestialBody sun;
ArrayList<CelestialBody> planets = new ArrayList<>();
ArrayList<CelestialBody> moons = new ArrayList<>();

PVector camera_position = new PVector();
PVector camera_normal = new PVector();
float camera_speed = 250.0;
float fov = PI / 3.0;

PShape spaceship;

float delta;

void setup() {
  size(2560, 1440, P3D);
  noStroke();
  
  spaceship = loadShape("spaceship.obj");
  spaceship.rotate(PI);
  spaceship.setTexture(loadImage("planet_2_texture.png"));

  camera_position = new PVector(0, 0, 500);
  camera_normal = new PVector(0, 0, -1);

  fill(255, 209, 102);
  emissive(255, 209, 102); 
  specular(250);
  shininess(20);
  sun = new CelestialBody(createShape(SPHERE, 75));
  emissive(0, 0, 0);
  
  /// PLANETY
  PShape planet_4 = loadShape("icosahedron.obj");
  planet_4.setTexture(loadImage("planet_4_texture.png"));
  planets.add(new CelestialBody(sun, 50.0/2, 490.0, 0.03*PI, planet_4, 4));
  
  PShape planet_1 = loadShape("icosahedron.obj");
  planet_1.setTexture(loadImage("planet_1_texture.png")); 
  planets.add(new CelestialBody(sun, 20.0/2, 100.0, 0.26*PI, planet_1, 1));

  PShape planet_2 = loadShape("icosahedron.obj");
  planet_2.setTexture(loadImage("planet_2_texture.png"));
  planets.add(new CelestialBody(sun, 25.0/2, 210.0, 0.19*PI, planet_2, 2));

  PShape planet_3 = loadShape("icosahedron.obj");
  planet_3.setTexture(loadImage("planet_3_texture.png"));
  planets.add(new CelestialBody(sun, 60.0/2, 350.0, 0.09*PI, planet_3, 3));


  /// KSIĘŻYCE
  specular(250);
  shininess(5);
  
  fill(244, 107, 139);
  moons.add(new CelestialBody(planets.get(0), 11.0, 25.0,-0.93*PI, createShape(BOX, 1), 5));
  fill(249, 153, 175);  
  moons.add(new CelestialBody(planets.get(0), 9.0, 35.0, -0.73*PI, createShape(BOX, 1), 6));
  
  specular(250);
  shininess(20);
  
  fill(255, 173, 147);  
  moons.add(new CelestialBody(planets.get(1), 13.0, 22.5, 0.79*PI, createShape(BOX, 1), 7));
  fill(255, 205, 189);  
  moons.add(new CelestialBody(planets.get(1), 10.0, 37.5,-0.39*PI, createShape(BOX, 1), 8));
  
  specular(50);
  shininess(20);
  
  fill(47 , 219, 176);  
  moons.add(new CelestialBody(planets.get(2), 12.0, 47.5,-0.86*PI, createShape(BOX, 1), 9));  
  fill(90 , 225, 191);  
  moons.add(new CelestialBody(planets.get(2), 14.0, 62.5,-0.60*PI, createShape(BOX, 1), 10));
  
  specular(50, 255, 255);
  shininess(20);
  
  fill(89 , 175, 203);  
  moons.add(new CelestialBody(planets.get(3), 18.0, 40.0, 0.40*PI, createShape(BOX, 1), 11));

} 


void draw() {
  delta = 1/frameRate;
  
  //directionalLight(63, 63, 63, 0, 1, -1); 
  lightSpecular(255, 255, 255);
  directionalLight(127,127,127, 0, 1, -1); 
  pointLight(255, 255, 204, 0, 0, 0);
  
  background(7, 59, 76);
  //lights();
  
  sun.display();
  for (CelestialBody planet : planets) { planet.display(); }
  for (CelestialBody moon : moons) { moon.display(); }

  perspective(fov, float(width)/float(height), 1, 1000000);
  updateCamera();
  camera(
    camera_position.x, camera_position.y, camera_position.z,
    camera_normal.x * 1000000, camera_normal.y * 1000000, camera_normal.z * 1000000,
    0, 1, 0
  );

  fill(55);
  pushMatrix();
  float ship_distance = 20;
  translate(
    camera_position.x + camera_normal.x * ship_distance,
    camera_position.y + camera_normal.y * ship_distance,
    camera_position.z + camera_normal.z * ship_distance);
  shape(spaceship);
  popMatrix();
}

class CelestialBody {
  CelestialBody primary;
  color colorr;
  float scale;
  float distance;
  float speed;
  int id;
  float phase;
  float deviation_scale;
  PShape shape;

  PVector global_position;
  PVector relative_position;
  
  CelestialBody(PShape _shape) {
    primary = null;
    distance = 0.0;
    speed = 0.0;
    scale = 1.0;
    shape = _shape;
    id = 0;
    phase = 0;

    global_position = new PVector(0, 0);
    relative_position = new PVector(0, 0);
  }

  CelestialBody(CelestialBody _primary, float _scale, float _distance, float _speed, PShape _shape, int _id) {
    primary = _primary;
    scale = _scale;
    distance = _distance;
    speed = _speed;
    shape = _shape;
    id = _id;
    phase = random(0, TWO_PI);
  
    deviation_scale = random(distance*0.2, distance*0.6);

    relative_position = new PVector(distance, 0);
    relative_position.rotate(random(0, TWO_PI));
    global_position = new PVector(0,0);

    shape.scale(scale);
  }
 
  void display() {
    if (primary != null) {
      global_position.x = primary.global_position.x + relative_position.x;
      global_position.y = primary.global_position.y + relative_position.y;
      global_position.z = primary.global_position.z + relative_position.z;
    } 
    
    if (id == 4) {
      spotLight(255, 255, 255,
       global_position.x+scale, global_position.y, global_position.z,
       1, 0, 0, PI/16, 600);
      pushMatrix();
      translate(global_position.x+scale, global_position.y, global_position.z);
      sphere(10);
      popMatrix();
    } 
    
    pushMatrix();
    translate(global_position.x, global_position.y, global_position.z);
    shape(shape);
    popMatrix();

    relative_position.rotate(speed * delta);
    relative_position.z = sin(relative_position.heading() + phase) * deviation_scale;
  }
}


void updateCamera() {
  if (keyPressed) {
    if (key == 'w') {
      camera_position = PVector.add(camera_position, PVector.mult(camera_normal.normalize(), camera_speed * delta));
    } 
    else if (key == 's') {
      camera_position = PVector.add(camera_position, PVector.mult(camera_normal.normalize(), -camera_speed * delta));
    } 
    else if (key == 'a') {
      PVector vec = new PVector(camera_normal.x, camera_normal.z);
      vec.rotate(-PI/2 * delta);
      camera_normal = new PVector(vec.x, camera_normal.y, vec.y);
    } 
    else if (key == 'd') {
      PVector vec = new PVector(camera_normal.x, camera_normal.z);
      vec.rotate(PI/2 * delta);
      camera_normal = new PVector(vec.x, camera_normal.y, vec.y);
    }
    else if (key == ' ') {
      PVector vec = new PVector(camera_normal.y, camera_normal.z);
      vec.rotate(-PI/2 * delta);
      camera_normal = new PVector(camera_normal.x, vec.x, vec.y);
    } 
    else if (keyPressed && key == CODED && keyCode == SHIFT) {
      PVector vec = new PVector(camera_normal.y, camera_normal.z);
      vec.rotate(PI/2 * delta);
      camera_normal = new PVector(camera_normal.x, vec.x, vec.y);
    }
  }
}


void mouseWheel(MouseEvent e) {
  fov -= e.getCount() * PI / 180; 
  fov = constrain(fov, PI/6, PI/2); 
}
