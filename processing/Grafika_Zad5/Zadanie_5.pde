PImage sunTexture;
PShape sun;

PShape asteroid;
PShape beacon_o;
PShape beacon_i;

PImage ptex1;
PShape planet1;

PImage ptex2;
PShape planet2;

PImage ptex3;
PShape planet3;

PImage sky;

void setup() {
    size(1600, 1000, P3D);
    noStroke();
    
    sunTexture = loadImage("sun3.jpg");  
    sun = createShape(SPHERE, 80);
    sun.setTexture(sunTexture);
    
    asteroid = loadShape("asteroid.obj");
    beacon_o = loadShape("beacon_outer.obj");
    beacon_i = loadShape("beacon_inner.obj");
    beacon_i.setFill(color(10, 10, 255));
    
    ptex1 = loadImage("planet4.jpg"); 
    planet1 = createShape(SPHERE, 55);
    planet1.setTexture(ptex1);
    
    ptex2 = loadImage("planet2.jpg"); 
    planet2 = createShape(SPHERE, 30);
    planet2.setTexture(ptex2);
    
    ptex3 = loadImage("planet3.jpg"); 
    planet3 = createShape(SPHERE, 40);
    planet3.setTexture(ptex3);
    
    sky = loadImage("sky.png");
}

float t;

void draw() {
  background(0);
  
  hint(DISABLE_DEPTH_MASK);
  image(sky, 0, 0, width, height);
  hint(ENABLE_DEPTH_MASK);
  
  translate(width / 2, height / 2, 0);
  rotateX(-0.07);
  
  pushMatrix();
    rotateY(0.1*t);
    shape(sun);
  popMatrix(); 
  ambientLight(20, 20, 20);
  lightSpecular(100, 100, 100);
 
  pointLight(255,  250,  220,  0,  0,  0);

   // planet + 2 moons + beacon
   pushMatrix();
    rotateY(0.8*t);
    translate(420, 0, 0);
    pushMatrix();
      rotateY(3*t);
      translate(36, 0, 0);
      spotLight(10, 10, 255, 0, 0, 0, 1, 0, 0, 0.5*PI, 5);
      rotateZ(-0.5*PI);
      shape(beacon_o);
      shape(beacon_i);
    popMatrix();
    pushMatrix();
      rotateY(4.6*t);
      translate(60, 0, 0);
      fill(122, 67, 42);
      specular(0,0,0);
      sphere(8);
    popMatrix();
      pushMatrix();
      rotateY(1.8*t);
      translate(100, 0, 0);
      specular(255,255,255);
      fill(228, 221, 237);
      shininess(128.0);
      sphere(16);
    popMatrix();
    rotateY(3*t);
    shape(planet3);
  popMatrix();

   // cube
   pushMatrix();
    rotateY(0.57*t);
    translate(150, 0, 0);
    rotateY(-2*t);
    fill(26, 54, 44);
    box(40);
  popMatrix();
  
  // planet + ring (angled)
  pushMatrix();
    rotateY(0.3*t);
    translate(680, 0, 0);
    rotateY(-0.3*t);
    rotateZ(-0.08*PI); // tilt
    int[] rotate_factors = {1, 3, -5, 7, 3, 4, 2, -1, 2, 5,   4, -2, 1, 2, 3, 5, -4, -6, 3, 3,   -4, 6, 2, 1, 4, -1, 1, -6, 4, -1};
    for(int i = 0; i < 10; i++){
      float rotate_factor = i;
      pushMatrix();
        rotateY(0.2*i * PI);
        rotateY(4*t);
        translate(80, 0, 0);
        rotate(0.1*t, rotate_factors[i], rotate_factors[i+10], rotate_factors[i+20]);
        scale(0.4);
        shape(asteroid);
      popMatrix();
    }
    rotateY(t);
    shape(planet1);
  popMatrix();
  
   // planet + moon (angled)
   pushMatrix();
    rotateY(1.5*t);
    translate(240, 0, 0);
    pushMatrix();
      rotateY(6*t);
      translate(60, 0, 0);
      specular(100,100,100);
      shininess(50.0);
      fill(143, 173, 199);
      sphere(12);
    popMatrix();
    rotateY(-t);
    rotateZ(-0.1*PI); // 18 degrees tilt
    rotateY(5*t);
    shape(planet2);
  popMatrix();
 
  
  t = 0.001 * millis();
}
