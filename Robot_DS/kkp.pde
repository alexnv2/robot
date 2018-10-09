class kkp {
  int x5, y5, d; //координаты места и диаметр
  color cVnut, cVnesh; //цвет внутренних и внешних колец
  int  z, ug; //курс,разрядность, угол стрелки
  float ugol; //Курс
  kkp(int xpos, int ypos, int diametr) {
    x5=xpos;//координаты центра х
    y5=ypos;//координыты центра y
    d=diametr/2; //радиус
  }
  void display(int ugol) {
    fill(255);
    noStroke();
    pushMatrix();
    translate(x5,y5);
    for(int i=-3;i<=3;i=i+1){
    ellipse(0+i*20,0,6,6);//Боковое смещение
    }
    popMatrix();
    fill(cVnesh);
    noStroke();
    triangle(x5, y5-d-2, x5-6, y5-d-20, x5+6, y5-d-20);//Верхний указатель ноля
    stroke(cVnesh);
    pushMatrix();
    translate(x5, y5);
    strokeWeight(1);
    //внешнее кольцо 10 гр.
    kolso(d+d/20, d+2, 10);
    //внешнее кольцо 30 гр
    strokeWeight(3);
    kolso(d+d/15, d+2, 30);
    //цифры внешнего кольца
    strokeWeight(2);
    rotate(3*PI/2);//поворот на 270 градусов
    //внешшнее цифры
    osifr(d+23, false);
    popMatrix();
    //внутреннее кольцо
    noFill();
    stroke(cVnut);
    pushMatrix();
    translate(x5, y5);
    ellipse(0, 0, 2*d+2, 2*d+2);
    rotate(radians(270-ugol));//поворот на 90градусов и вращение
    // кольцо по 10 гр.
    strokeWeight(2);
    kolso(d-d/15, d, 10);
    //кольцо по 5 гр.
    strokeWeight(1);
    kolso(d-d/30, d, 5);   
    fill(cVnut);
    //внутренние цифры
    osifr(d-23, true);
    popMatrix();
  }

  private void strelka(int ug) {
    stroke(255, 255, 0);
    strokeWeight(2);
    pushMatrix();
    translate(x5, y5);
    fill(255, 255, 0);
    ellipse(0, 0, 6, 6);
    float x6=(d-15)*cos(radians(ug+270));
    float y6=(d-15)*sin(radians(ug+270));
    float x7=(d-15)*cos(radians(ug+270)+PI);
    float y7=(d-15)*sin(radians(ug+270)+PI);
    line(x6, y6, x7, y7);
    float x8=(d-25)*cos(radians(ug+267));
    float y8=(d-25)*sin(radians(ug+267));
    float x9=(d-25)*cos(radians(ug+273));
    float y9=(d-25)*sin(radians(ug+273));
    beginShape(TRIANGLES);
    vertex(x8, y8);
    vertex(x6, y6);
    vertex(x9, y9);
    endShape();
    popMatrix();
  }
  //разметка колец
  private void kolso(float r0, float r00, int z0) {
    for (int i=0; i<=360; i=i+z0) {
      float x10=r0*cos(radians(i));
      float y10=r0*sin(radians(i));
      float x11=r00*cos(radians(i));
      float y11=r00*sin(radians(i));
      line(x10, y10, x11, y11);
    }
  }

  //оцифровка колец
  private void osifr(float r0, boolean v) {
    for (int i=0; i<360; i=i+z) {
      float x12=r0*cos(radians(i));
      float y12=r0*sin(radians(i));
      pushMatrix();
      translate(x12, y12);
      textAlign(CENTER);
      if (v==true) {
        rotate(radians(i)+PI/2);
        text(i/10, 0, 0);
      } else {
        rotate(PI/2);
        textAlign(CENTER);
        if (i!=0) {
          text(i/10, 0, 0);
        }
      } 
      popMatrix();
    }
  }
//стрелка бокового уклонения
private void strelkaBok(int bug){
 stroke(255);
 pushMatrix();
 translate(x5,y5);
 line(0+bug,0+60,0+bug,0-60);
 popMatrix();
}

}
