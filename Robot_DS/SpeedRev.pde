class SpeedRev {
  float x, y, d; //координаты места и диаметр
  color cCircle; //цвет кольца
  int  ug; //скорость в радианах
  float ugol; //скорость в м/мин
  int iVal; //ноль отчета
  int iDelUv;//
  int iDelUm;
  float iDelitel;
  SpeedRev(float xpos, float ypos, float diametr, int iValue,color cFon,int iDv,int iDm, float iDs) {
    x=xpos;//координаты центра х
    y=ypos;//координыты центра y
    d=diametr/2; //радиус
    iVal=iValue; //ноль
    cCircle=cFon;//цвет разметки
    iDelUv=iDv;
    iDelUm=iDm;
    iDelitel=iDs;
  }
  void display() {
    //кольцо
    textFont(font1);
    noFill();
    stroke(cCircle);
    strokeWeight(3);
    pushMatrix();
    translate(x, y);
    arc(0, 0, 2*d+2, 2*d+2, radians(150), radians(390));
    // кольцо по 10 м/мин.
    strokeWeight(2);
    kolso(d-d/15, d, iDelUv);
    //кольцо по 5 м/мин
    strokeWeight(1);
    kolso(d-d/30, d, iDelUm);   
    fill(cCircle);
    //внутренние цифры
    osifr(d-23, iDelUv, iVal);
    popMatrix();
  }

  private void strelka(int ugol,String stv) {
    ug=int(ugol*iDelitel)+150;
//    fill(cCircle);
    strokeWeight(3);
    pushMatrix();
    translate(x, y);
    ellipse(0, 0, 12, 12);
    text(ugol+stv,0,50);
    float x1=(d-20)*cos(radians(ug));
    float y1=(d-20)*sin(radians(ug));
    float x2=15*cos(radians(ug)+PI);
    float y2=15*sin(radians(ug)+PI);
    line(x1, y1, x2, y2);
    float x3=(d-35)*cos(radians(ug-3));
    float y3=(d-35)*sin(radians(ug-3));
    float x4=(d-35)*cos(radians(ug+3));
    float y4=(d-35)*sin(radians(ug+3));
    beginShape(TRIANGLES);
    vertex(x1, y1);
    vertex(x3, y3);
    vertex(x4, y4);
    endShape();
    popMatrix();
}
//разметка колец
private void kolso(float r0, float r00, int z0) {
  for (int i=150; i<=390; i=i+z0) {
    float x1=r0*cos(radians(i));
    float y1=r0*sin(radians(i));
    float x2=r00*cos(radians(i));
    float y2=r00*sin(radians(i));
    line(x1, y1, x2, y2);
  }
}

//оцифровка колец
void osifr(float r0, int d1, int iValu) {
  for (int i=150; i<=390; i=i+d1) {
    float x1=r0*cos(radians(i));
    float y1=r0*sin(radians(i));
    textAlign(CENTER);
    text(iValu, x1, y1);
    iValu=iValu+int(iDelUv/iDelitel);
  }
}


}
