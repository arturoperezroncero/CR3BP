//Simulación de un sistema de 3 cuerpos en un sistema rotatorio no-inercial.
//Cuenta con un algoritmo de selección de órbitas periódicas (beta).
//La sensibilidad del selector está representada como la variable 'di2', y se deberá ajustar para cada caso.

float t,jac;
float G=1;
float m1=1000;
float m2=100;
float M=m1+m2;
float mu1=G*m1;
float mu2=G*m2;
float R=mu1+mu2;
float w=sqrt(G*M/pow(R, 3));
float ratio=m2/(m1);

PVector pos1;
PVector pos2;

import java.util.*;
import peasy.PeasyCam;
PeasyCam cam;

List<PVector> attractors = new ArrayList<PVector>();
List<Particle> particles = new ArrayList<Particle>();
List<PVector> trajectory = new ArrayList<PVector>();

float[] velo;
float[] mass;
float punt, dm, dr, col1, col2, col3, max, f1;
float dmax=0;
float dmin=999999999;
PImage img;
int size = 50;
float x, velm;

PVector sol1, sol2, masscen;
PVector centre= new PVector(0, 0);

boolean jaco1,jaco2,jaco3,orb,ciclo,first,passed,repet;
float freq=100;
float jac1;
float ma=0;
float mi=500;
float di1=1;
float di2=.001;
int rep;

void setup() {
  fullScreen(P3D);
  translate(width/2, height/2);
  cam = new PeasyCam(this, 1000);

  particles.add(new Particle(-ratio, 0, 0, 0, 0, 0, 50, m1,0,0,0)); 
  particles.add(new Particle(1-ratio, 0, 0, 0, 0, 0, 20, m2,0,0,0));
  
  for (float i = ma; i < mi; i+=di1) {
    particles.add(new Particle(1.08,0,0,i,.08,0,5,0,i,0,0));
  }

  first=true;
}

void draw() {
  t+=.001;
  background(0);
  stroke(255);
  strokeWeight(.1);

  for (int i = 0; i < particles.size(); i++) {
    Particle particle = particles.get(i);
    particle.update(i);
    particle.show();
  }
  if(repet==true){
    repet=false;
    for (int i = 2; i < particles.size(); i++) {
      Particle particle = particles.get(i);
      println(mi,ma,"lol");
      particle.repe(map(i,0,particles.size(),mi,ma));
    }
    mi=500;
    ma=0;
  }

  for (int l = 0; l < trajectory.size()-1; l++) {
    if (orb==true) {
      strokeWeight(2.5);
      stroke(255, 0, 0);
      point(trajectory.get(l).x, trajectory.get(l).y, trajectory.get(l).z);
    }
  }
  if(jaco1==true){
    for (int j = -750; j < 750; j+=freq) {
      for (float k = -sqrt(abs(562500-sq(j))); k < sqrt(abs(562500-sq(j))); k+=freq) {
        stroke(255);
        strokeWeight(2);
        float jacobi=(sq(map(j,-2500,2500,-5,5))+sq(map(k,-2500,2500,-5,5)))+2*(1-ratio)/dist(map(pos1.x,-5,5,-2500,2500),map(pos1.y,-5,5,-2500,2500),map(pos1.z,-5,5,-2500,2500),j,k,0)+2*ratio/dist(map(pos2.x,-5,5,-2500,2500),map(pos2.y,-5,5,-2500,2500),map(pos2.z,-5,5,-2500,2500),j,k,0);
        
        for(float lin=0;lin<2;lin+=.1){
          if(jacobi>lin-.01 && jacobi<lin+.01){
            point(j,k,-jacobi*100);
          }
        }
      }
    }
  }
  if(jaco2==true){
    for (int j = -1250; j < 1251; j+=1) {
      for (int k = -1250; k < 1251; k+=freq) {
        stroke(255,50);
        strokeWeight(2);
        float jacobi=(sq(map(j,-750,750,-.1,.1))+sq(map(k,-750,750,-.1,.1)))+2*(1-ratio)/dist(map(pos1.x,-5,5,-2500,2500),map(pos1.y,-5,5,-2500,2500),map(pos1.z,-5,5,-2500,2500),j,k,0)+2*ratio/dist(map(pos2.x,-5,5,-2500,2500),map(pos2.y,-5,5,-2500,2500),map(pos2.z,-5,5,-2500,2500),j,k,0);
        point(j,k,-jacobi*10000);
      }
    }
    for (int j = -1250; j < 1251; j+=freq) {
      for (int k = -1250; k < 1251; k+=1) {
        stroke(255,50);
        strokeWeight(2);
        float jacobi=(sq(map(j,-750,750,-.1,.1))+sq(map(k,-750,750,-.1,.1)))+2*(1-ratio)/dist(map(pos1.x,-5,5,-2500,2500),map(pos1.y,-5,5,-2500,2500),map(pos1.z,-5,5,-2500,2500),j,k,0)+2*ratio/dist(map(pos2.x,-5,5,-2500,2500),map(pos2.y,-5,5,-2500,2500),map(pos2.z,-5,5,-2500,2500),j,k,0);
        point(j,k,-jacobi*10000);
      }
    }
  }
  if(jaco3==true){
    for (int j = -750; j < 750; j+=freq) {
      for (float k = -sqrt(abs(562500-sq(j))); k < sqrt(abs(562500-sq(j))); k+=freq) {
        stroke(255);
        strokeWeight(2);
        float jacobi=(sq(map(j,-2500,2500,-1,1))+sq(map(k,-2500,2500,-1,1)))+2*(1-ratio)/dist(map(pos1.x,-5,5,-2500,2500),map(pos1.y,-5,5,-2500,2500),map(pos1.z,-5,5,-2500,2500),j,k,0)+2*ratio/dist(map(pos2.x,-5,5,-2500,2500),map(pos2.y,-5,5,-2500,2500),map(pos2.z,-5,5,-2500,2500),j,k,0);
        
        if(jacobi>map(mouseX,0,width,0,.1)-.002 && jacobi<map(mouseX,0,width,0,.1)+.002){
          stroke(0,0,255);
        }else{
          stroke(255);
        }
        strokeWeight(2);
        point(j,k,-jacobi*1000);
      }
    }
  }
}

void keyReleased(){
  ciclo=false;
  if(key=='o'){
    if(orb==false){
      orb=true;
    }else{
      orb=false;
    }
  }
  if(key=='j'){
    if(jaco1==false && jaco2==false && jaco3==false && ciclo==false){
      jaco1=true;
      jaco2=false;
      jaco3=false;
      ciclo=true;
    }if(jaco1==true && jaco2==false && jaco3==false && ciclo==false){
      jaco1=false;
      jaco2=true;
      jaco3=false;
      ciclo=true;
    }if(jaco1==false && jaco2==true && jaco3==false && ciclo==false){
      jaco1=false;
      jaco2=false;
      jaco3=true;
      ciclo=true;
    }if(jaco1==false && jaco2==false && jaco3==true && ciclo==false){
      jaco1=false;
      jaco2=false;
      jaco3=false;
      ciclo=true;
    }
    ciclo=true;
  }
  if(jaco2==true){
    if(key=='1'){
      freq=200;
    }if(key=='2'){
      freq=150;
    }if(key=='3'){
      freq=100;
    }if(key=='4'){
      freq=50;
    }if(key=='5'){
      freq=25;
    }if(key=='6'){
      freq=15;
    }if(key=='7'){
      freq=10;
    }if(key=='8'){
      freq=5;
    }if(key=='9'){
      freq=3;
    }
  }
  if(jaco1==true || jaco3==true){
    if(key=='1'){
      freq=100;
    }if(key=='2'){
      freq=75;
    }if(key=='3'){
      freq=50;
    }if(key=='4'){
      freq=25;
    }if(key=='5'){
      freq=15;
    }if(key=='6'){
      freq=10;
    }if(key=='7'){
      freq=5;
    }if(key=='8'){
      freq=3;
    }if(key=='9'){
      freq=1;
    }
  }
}

PVector posP,velP;
float dif=100;

float redu=.00001;

class Particle {
  PVector pos;
  PVector posp;
  PVector prev;
  PVector vel;
  PVector acc;
  PVector mass;
  PVector col,data;
  float mv = 0;

  Particle(float x, float v1, float y, float v2, float z, float v3, float s, float m, float d1, float d2, float d3) {
    pos = new PVector(x, y, z);
    posp = new PVector(x, y, z);
    prev = new PVector(x, y, z);
    vel = new PVector(v1*redu,v2*redu,v3*redu);
    mass = new PVector(s,m);
    acc = new PVector();
    data = new PVector(d1,d2,d3);
  }

  void update(int particle) {  
    pos1=new PVector(-ratio,0,0);
    pos2=new PVector(1-ratio,0,0);
    if(particle>=2){
      acc.mult(0);
      float r1=sqrt(sq(this.pos.x+ratio)+sq(this.pos.y));
      float r2=sqrt(sq(this.pos.x-1+ratio)+sq(this.pos.y));
      float a=1;
      float b=1;
      acc=new PVector(a*(2*this.vel.y+this.pos.x)-((1-ratio)*(this.pos.x+ratio)/pow(dist(pos1.x,pos1.y,pos1.z,this.pos.x,this.pos.y,this.pos.z),3)+ratio*(this.pos.x-1+ratio)/pow(dist(pos2.x,pos2.y,pos2.z,this.pos.x,this.pos.y,this.pos.z),3))*b,
      a*(-2*this.vel.x+this.pos.y)-((1-ratio)*this.pos.y/pow(dist(pos1.x,pos1.y,pos1.z,this.pos.x,this.pos.y,this.pos.z),3)+ratio*this.pos.y/pow(dist(pos2.x,pos2.y,pos2.z,this.pos.x,this.pos.y,this.pos.z),3))*b,
      (-(1-ratio)*this.pos.z/pow(dist(pos1.x,pos1.y,pos1.z,this.pos.x,this.pos.y,this.pos.z),3)-ratio*this.pos.z/pow(dist(pos2.x,pos2.y,pos2.z,this.pos.x,this.pos.y,this.pos.z),3))*b);
      strokeWeight(2);
      acc.mult(redu);
      acc.limit(.01);
      vel.add(acc);
      pos.add(vel);
      
      
      float sens=.000253;
      if(millis()>1000 && mass.y<1 && this.pos.x>.5 && this.pos.z<0 && this.pos.y>=-di2 && this.pos.y<=di2 && this.vel.z>=-di2 && this.vel.z<=di2 && this.vel.x>=-di2 && this.vel.x<=di2){
        mass.x=6;
        passed=true;
        if(this.data.x<mi){
          mi=this.data.x;
        }if(this.data.x>ma){
          ma=this.data.x;
        }
        println(mi,ma);
      }if(((millis()>20000 + 20000*rep && mass.y<1))){
        if(passed==true){
          passed=false;
          di1*=.9;
          di2*=.9;
        }else{
          di1*=.9;
          di2*=1.05;
        }
        repet=true;
        rep++;
      }
    }
  }

  void show() {
    float x,y,z;
    pushMatrix();
    translate(map(this.pos.x,-5,5,-2500,2500),map(this.pos.y,-5,5,-2500,2500),map(this.pos.z,-5,5,-2500,2500));
    strokeWeight(mass.x);
    if(mass.x==6){
      stroke(0,255,0);
    }else{
      stroke(255);
    }
    point(0,0,0);
    popMatrix();
    
    if(mass.y<1){
      text(data.x+"  "+data.y+"  "+data.z,map(this.pos.x,-5,5,-2500,2500),map(this.pos.y,-5,5,-2500,2500),map(this.pos.z,-5,5,-2500,2500));
      if(first==true){
        jac1=(sq(map(this.pos.x,-2500,2500,-1,1))+sq(map(this.pos.y,-2500,2500,-1,1)))+2*(1-ratio)/dist(map(pos1.x,-5,5,-2500,2500),map(pos1.y,-5,5,-2500,2500),map(pos1.z,-5,5,-2500,2500),this.pos.x,this.pos.y,0)+2*ratio/dist(map(pos2.x,-5,5,-2500,2500),map(pos2.y,-5,5,-2500,2500),map(pos2.z,-5,5,-2500,2500),this.pos.x,this.pos.y,0)-sq(mag(this.vel.x,this.vel.y,this.vel.z));
        //println(jac1);
        first=false;
      }
      
      trajectory.add(new PVector(map(this.pos.x,-5,5,-2500,2500),map(this.pos.y,-5,5,-2500,2500),map(this.pos.z,-5,5,-2500,2500)));
      if(trajectory.size()>200000){
        trajectory.remove(0);
      }
    }
  }
  
  void repe(float i){
    pos=new PVector(1.08,0,.08);
    vel=new PVector(0,i*redu,0);
    mass.x=5;
  }
}
