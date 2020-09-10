//Simulación de un sistema de 3 cuerpos en un sistema rotatorio no-inercial.
//presionar 'o' para ver la constante de Jacobi en forma de líneas equipotenciales.
//presionar '0' para ver la imagen con más calidad visual.

import java.util.*;
import peasy.PeasyCam;
PeasyCam cam;

float def=.01;
float ratio=.01215;
boolean orb;
PVector pos = new PVector(1.03,-.05,-.03);
PVector vel = new PVector(.0003,.0000,.0004);
PVector acc = new PVector();
PVector pos1=new PVector(-ratio,0,0);
PVector pos2=new PVector(1-ratio,0,0);
List<PVector> trajectory = new ArrayList<PVector>();

void setup() {
  fullScreen(P3D);
  cam = new PeasyCam(this, 500,0,0,500);
}

void draw() {
  background(255);
  
  if(orb==true){
    for (float j = -5; j < 5; j+=def) {
        for (float k = -5; k < 5; k+=def) {
          float jacobi=(sq(j)+sq(k))+2*(1-ratio)/dist(pos1.x,pos1.y,pos1.z,j,k,0)+2*ratio/dist(pos2.x,pos2.y,pos2.z,j,k,0);
          
          float l1=3;
          float l2=3.5;
          
          for(float lin=l1;lin<l2;lin+=.1){
            if(jacobi>lin-.01 && jacobi<lin+.01){
              strokeWeight(3);
              stroke(map(jacobi,l1,l2,0,255),map(jacobi,l1,l2,150,0),map(jacobi,l1,l2,255,0),20);
              point(map(j,-5,5,-5000,5000),map(k,-5,5,-5000,5000),-jacobi*200+635);
            }
          }
        }
      }
  }
    
  stroke(255);
  trajectory.add(new PVector(map(pos.x,-5,5,-5000,5000),map(pos.y,-5,5,-5000,5000),map(pos.z,-5,5,-5000,5000)));
  for (int l = 0; l < trajectory.size()-1; l++) {
    strokeWeight(2.5);
    //point(trajectory.get(l).x, trajectory.get(l).y, trajectory.get(l).z);
    stroke(0,255,0);
    line(trajectory.get(l).x, trajectory.get(l).y, trajectory.get(l).z, trajectory.get(l+1).x, trajectory.get(l+1).y, trajectory.get(l+1).z);
    stroke(0);
  }
  
  if(dist(pos1.x,pos1.y,pos1.z,pos.x,pos.y,pos.z)>.02){
    acc=new PVector(2*vel.y + pos.x -(1-ratio)*(pos.x+ratio)/pow(sqrt(sq(pos.x+ratio)+sq(pos.y)+sq(pos.z)),3) -ratio*(pos.x-1+ratio)/pow(sqrt(sq(pos.x-1+ratio)+sq(pos.y)+sq(pos.z)),3),
    -2*vel.x + pos.y -(1-ratio)*pos.y/pow(sqrt(sq(pos.x+ratio)+sq(pos.y)+sq(pos.z)),3) - ratio*pos.y/pow(sqrt(sq(pos.x-1+ratio)+sq(pos.y)+sq(pos.z)),3),
    -(1-ratio)*pos.z*pow(sqrt(sq(pos.x+ratio)+sq(pos.y)+sq(pos.z)),-3) - ratio*pos.z*pow(sqrt(sq(pos.x-1+ratio)+sq(pos.y)+sq(pos.z)),-3));
  }
  
  acc.mult(.000001);
  vel.add(acc);
  pos.add(vel);
  
  strokeWeight(75);
  point(map(-ratio,-5,5,-5000,5000),0,0);
  strokeWeight(10);
  point(map(1-ratio,-5,5,-5000,5000),0,0);
  strokeWeight(3);
  point(map(pos.x,-5,5,-5000,5000),map(pos.y,-5,5,-5000,5000),map(pos.z,-5,5,-5000,5000));
}

void keyPressed(){
  if(key==CODED){
    if(keyCode==UP){
      def-=.002;
    }if(keyCode==DOWN){
      def+=.002;
    }
  }if(key=='0'){
      def=.001;
  }if(key=='1'){
      def=.1;
  }
  if(key=='o'){
    if(orb==false){
      orb=true;
    }else{
      orb=false;
    }
  }
}
