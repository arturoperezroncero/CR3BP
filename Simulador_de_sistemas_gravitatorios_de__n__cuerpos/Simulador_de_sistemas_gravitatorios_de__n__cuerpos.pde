//Simulación de un sistema de 'n' cuerpos.
//La imagen 'noise' s necesaria para calcular una distribución normal de las partículas. Cualquier imagen de ruido gaussiano sirve.
//La variable 'size' representa la densidad de partículas generadas. Si es demasiado baja, convendrá subir la opacidad de las partículas

import java.util.*;

List<PVector> attractors = new ArrayList<PVector>();
List<Particle> particles = new ArrayList<Particle>();

float[] velo;
float[] mass;
float punt, dm, dr, col1, col2, col3;
float dmax=0;
float dmin=999999999;
PImage img;
int size = 10;
color c;
int a;

void setup() {
  for(int i=0; i<width;i+=size){
    for(int u=0; u<height;u+=size){
      particles.add(new Particle(i,u));
    }
  }
  velo = new float[particles.size()];
  mass = new float[particles.size()];
  
  img = loadImage("noise.png");
  image(img,0,0);
  for(int i=0; i<width;i+=size){
    for(int u=0; u<height;u+=size){
      c=(get(i, u));
      a = c & 0xFF;
      
      mass[((height/size))*int(i/size)+int(u/size)] = map(a,0,255,200,25);
    }
   }  
   
  fullScreen();
}

void draw() {
  background(0);
  stroke(255);
  strokeWeight(.1);
 
  attractors.clear();
  for (int i = 0; i < particles.size(); i++) {
    Particle particle = particles.get(i);
    particle.system(i);
  }
  
  for (int i = 0; i < particles.size(); i++) {
    Particle particle = particles.get(i);
    
    for (int j = 0; j < attractors.size(); j++) {
      particle.attracted(attractors.get(j), mass[j]);
    }
    if(dr/dm>dmax){
      dmax=dr/dm;
    }
    if(dr/dm<dmin){
      dmin=dr/dm;
    }
    println(dmax,dmin);
    col1=map(dr/dm,50000,5,120,230);
    col2=map(dr/dm,50000,5,40,150);
    col3=map(dr/dm,50000,5,140,30);
    dm=0;
    dr=0;
    particle.update();
    particle.show(mass[i]/65,col1,col2,col3);
  }
  saveFrame();
}

class Particle {
  PVector pos;
  PVector posp;
  PVector prev;
  PVector vel;
  PVector acc;
  float mv = 0;

  Particle(float x, float y) {
    pos = new PVector(x, y);
    posp = new PVector(x, y);
    prev = new PVector(x, y);
    vel = new PVector(random(-mv,mv),random(-mv,mv));
    acc = new PVector();
  }
  
  void system(int i) {
    attractors.add(new PVector(this.pos.x, this.pos.y));
    velo[i]=mag(vel.x,vel.y);
  }

  void update() {
    vel.add(acc);
    vel.limit(50);
    pos.add(vel);
    acc.mult(0);
  }

  void show(float mass,float col1,float col2,float col3) {
    stroke(col1,col2,col3,150);
    strokeWeight(mass);
    point(this.pos.x, this.pos.y);
  }

  void attracted(PVector target, float mass) {
    PVector force = PVector.sub(target, pos);
    float d = force.mag();
    float G = .01;
    if(d<300){ //para compensar la falta de fuerzas fuera de la pantalla
      d = constrain(d, 5, 10000);
      dr+=d*d;
      dm += 1;
    }else{
      d=1000000;
    }
    float strength = mass * G / (d * d );
    force.setMag(strength);
    acc.add(force);
    //vel.mult(.999);
  }
}
