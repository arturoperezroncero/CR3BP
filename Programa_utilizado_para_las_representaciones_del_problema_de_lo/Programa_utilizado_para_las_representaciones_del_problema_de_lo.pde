//Simulación de un sistema de 3 cuerpos, su potencial efectivo, y el comportamiento de objetos en sus puntos de Lagrange
//Pulsar '0' para obtener un resultado de buena calidad visual.

import java.util.*;
import peasy.PeasyCam;
PeasyCam cam;

List<PVector> attractors = new ArrayList<PVector>();
List<Particle> particles = new ArrayList<Particle>();
List<PVector> trajectory = new ArrayList<PVector>();

float[] velo;
float[] mass;
float punt, dm, dr, col1, col2, col3, max,f1,t;
float dmax=0;
float dmin=999999999;
PImage img;
int size = 50;
int a;
float x,velm;
float G = 1;

float freq=5;
PVector sol1,sol2,masscen;
PVector centre= new PVector(0,0);

void setup() {
  fullScreen(P3D);
  translate(width/2,height/2);
  cam = new PeasyCam(this, 1000);
  
  particles.add(new Particle(0,0,0,50,255,255,0)); 
  particles.add(new Particle(0,500,0,10,70,180,245));
  particles.add(new Particle(0,465.3319363,0,1,30,230,40));
  particles.add(new Particle(0,-500.2083333,0,1,30,230,40));
  particles.add(new Particle(0,534.66806372,0,1,30,230,40));
  particles.add(new Particle(465,183,0,1,30,230,40));
  particles.add(new Particle(-465,183,0,1,30,230,40));
  
  mass = new float[particles.size()]; 
  mass[0]=1000;
  mass[1]=1;
  mass[2]=.0000001;
  mass[3]=.0000001;
  mass[4]=.0000001;
  mass[5]=.0000001;
  mass[6]=.0000001;
  
  velo = new float[particles.size()];
  velo[0]=5;
}

void draw() {
  if(keyPressed){
    freq=.6;
  }
  background(255);
  stroke(255);
  strokeWeight(.1);
 
  attractors.clear();
  for(int i = 0; i < particles.size(); i++){
    Particle particle = particles.get(i);
    particle.system(i);
  }
  
  for(int i = 0; i < particles.size(); i++){
    Particle particle = particles.get(i);
    
    for(int j = 0; j < attractors.size(); j++){
      particle.attracted(attractors.get(j), mass[j]);
    }
    particle.update(i);
    particle.show();
  }
  
  for(int l = 0; l < trajectory.size(); l++){
    strokeWeight(3);
    stroke(255,0,0);
    point(trajectory.get(l).x,trajectory.get(l).y,trajectory.get(l).z);
  }
  
  for (float j = -700; j < 700; j+=freq) {
    for (float k = -sqrt(abs(490000-sq(j))); k < sqrt(abs(490000-sq(j))); k+=freq) {
      strokeWeight(1);
      masscen = new PVector((mass[1]*posP.x+mass[0]*centre.x)/(mass[1]+mass[0]),(mass[1]*posP.y+mass[0]*centre.y)/(mass[1]+mass[0]),0);
      float one=+sq(((sqrt(mass[0]/abs(dist(masscen.x,masscen.y,posP.x,posP.y))))/dist(masscen.x,masscen.y,posP.x,posP.y)*dist(masscen.x,masscen.y,j,k)))/2+(mass[0]/dist(centre.x,centre.y,j,k)+mass[1]/dist(posP.x,posP.y,j,k));
      for (float y = 0; y < 3.5; y+=.05) {
        if(one>y-.0075 && one<y+.0075){
          stroke(0,100);
          point(j,k,-one*100+296);
        }
      }
    }
    }
}

PVector pos1,pos2,posP,velP;
float dif=100;

class Particle {
  PVector pos;
  PVector posp;
  PVector prev;
  PVector vel;
  PVector acc;
  PVector mass;
  PVector col;
  float mv = 0;

  Particle(float x, float y, float z, float s, float c1, float c2, float c3) {
    pos = new PVector(x, y, z);
    posp = new PVector(x, y, z);
    prev = new PVector(x, y, z);
    vel = new PVector();
    mass = new PVector(s,s);
    col = new PVector(c1,c2,c3);
    if(pos.y==0){
      vel.add(0,0,0);
    }if(pos.y==500){
      vel.add(sqrt(2),0,0);
    }if(pos.y==465.3319363){
      vel.add(sqrt(2)/500*465.3319363,0,0);
    }if(pos.y==-500.2083333){
      vel.add(-sqrt(2)/500*500.2083333,0,0);
    }if(pos.y==534.66806372){
      vel.add(sqrt(2)/500*534.66806372,0,0);
    }if(pos.x==-465){
      vel.add(0.517602,1.31522,0);
    }if(pos.x==465){
      vel.add(0.517602,-1.31522,0);
    }
    
    acc = new PVector();
  }
  
  void system(int i) {
    attractors.add(new PVector(this.pos.x, this.pos.y, this.pos.z));
    velo[i]=mag(vel.x,vel.y,vel.z);
  }

  void update(int particle) {
    vel.add(acc);
    vel.limit(50);
    pos.add(vel);
    acc.mult(0);
    
    if(particle==0){
      centre=pos;
    }
    if(particle==1){
      posP=pos;
      velP=vel;
    }
  }

  void show() {
    stroke(this.col.x,this.col.y,this.col.z);
    strokeWeight(10);
    pushMatrix();
    translate(this.pos.x,this.pos.y,this.pos.z);
    trajectory.add(new PVector(this.pos.x, this.pos.y, this.pos.z));
    if(trajectory.size()>2000){
      trajectory.remove(0);
    }
    sphere(this.mass.x);
    popMatrix();
  }

  void attracted(PVector target, float mass) {
    PVector force = PVector.sub(target, pos);
    float d = force.mag();
    d = constrain(d, 5, 10000);
    float strength = mass * G / (d * d);
    force.setMag(strength);
    acc.add(force);
    
    if(mag(this.vel.x, this.vel.y, this.vel.z)>velm){
      velm=mag(this.vel.x, this.vel.y, this.vel.z);
    }
  }
}
