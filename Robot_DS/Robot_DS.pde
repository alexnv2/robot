//V 2.1.3 10.10.2018 
//Nosov Vyacheslav
//Processing programm
//*********************************
import controlP5.*;
ControlP5 cp5;
import g4p_controls.*;
GImageToggleButton btnSonar, btnIC, btnCamera, btnLight;
GLabel label1, label2, label3, label4, label5; 
int myColor = color(0);
// Прием по Wi-Fi видео с Web-камеры. 
import ipcapture.*;
//Сетевое управление
import processing.net.*;
//Создание канала с роботом
Client robot;
import processing.video.*;
import processing.sound.*;
SoundFile song, songOnn, songOff;
//Прием и передача данных
int[] comControl=new int[3];//Буфер команд управления
int intLenght; //длина принятых строк
String strData; // принятые данные
float fltData; //Численные значения прнятые от робота
String strKod;//Код принятых данных
int flagControl=0;//режим работы локатора 1
//радар
int intDegr;//угол
int val;//дистанция о препятсвии сонара
//int newLine = 13;
Ultrasonic sonic;
boolean logSonic=false;//радар выключен
//int rot;
IPCapture cam;
//Шрифты
PFont font, font1;
PFont myFont; 
boolean pressOff=true;   //Кнопка мыша отжата
boolean camOff=false; //камера выключена

boolean demo=false;// тестовый режим false

int Patm; // Давление
int Tatm; // Тепература
//Указатель курса
kkp kurs;
int intKKPX=1050;//координаты х
int intKKPY=550;// координаты y
int intKKPD=200; // диаметр
int  u, b;
int heading;//курс принятый от датчика
//String data="";
//Обороты и скорость
SpeedRev sn, sv;//обороты и скорость
String sts=" м/мин";
String stn=" об/мин";
int iSpeed; //скорость
int iRev; //обороты
// SETUP****************************************************************
void setup() {
  fullScreen();
  //  size(1280, 730);
  //ККП
  kurs=new kkp(intKKPX, intKKPY, intKKPD);
  kurs.cVnut=#234567;
  kurs.cVnesh=#ffff00;
  kurs.z=30;

  u=330;//стрелка
  b=-20;//смещение 20 - первый круг
  heading=300;//Курс по умолчанию
  //Кнопки управления
  cp5 = new ControlP5(this);
  //Вперед
  cp5.addBang("buttonForward")
    .setPosition(600, 500)
    .setImages(loadImage("Arrow-Forward.png"), loadImage("Arrow-Forward-Active.png"), loadImage("Arrow-Forward-Press.png") )
    .updateSize();
  //Назад
  cp5.addBang("buttonBackward")
    .setPosition(600, 600)
    .setImages(loadImage("Arrow-Backward.png"), loadImage("Arrow-Backward-Active.png"), loadImage("Arrow-Backward-Press.png"))
    .updateSize();
  //Влево
  cp5.addBang("buttonTurnLeft")
    .setPosition(575, 550)
    .setImages(loadImage("Arrow-Left.png"), loadImage("Arrow-Left-Active.png"), loadImage("Arrow-Left-Press.png"))
    .updateSize();
  //Вправо
  cp5.addBang("buttonTurnRight")
    .setPosition(625, 550)
    .setImages(loadImage("Arrow-Right.png"), loadImage("Arrow-Right-Active.png"), loadImage("Arrow-Right-Press.png"))
    .updateSize();

  //ИК препятсвие
  btnIC = new GImageToggleButton(this, 28, 490);
  btnIC.fireAllEvents(true); 
  createLabels();

  // Радар
  btnSonar = new GImageToggleButton(this, 28, 560);
  createLabels();

  //Камера
  btnCamera = new GImageToggleButton(this, 28, 630);
  createLabels();

  //Свет
  //  btnLight = new GImageToggleButton(this, 28, 700);
  //  createLabels();

  //Фото
  cp5.addButton("btnFoto")
    .setPosition(270, 490)
    .setImages(loadImage("Foto.png"), loadImage("Foto-Active.png"), loadImage("Foto-Press.png") )
    .updateSize();
  ;

  noStroke();
  //Горизонтальный и вертикальный слайдер
  cp5.addSlider("Y")
    .setPosition(540, 120)
    .setSize(20, 200)
    .setRange(0, 100)
    //.setNumberOfTickMarks(20)
    .setSliderMode(Slider.FLEXIBLE)
    ;
  cp5.addSlider("X")
    .setPosition(85, 400)
    .setSize(360, 20)
    .setRange(180, 0) 
    .setValue(90)
    //.setNumberOfTickMarks(7)
    .setSliderMode(Slider.FLEXIBLE)
    ;
  cp5.getController("X").getValueLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  //Скорость
  cp5.addSlider("R")
    .setPosition(372, 640)
    .setSize(150, 20)
    .setRange(0, 100)
    .setValue(10)
    ;
  cp5.addSlider("L")
    .setPosition(372, 670)
    .setSize(150, 20)
    .setRange(0, 100)
    .setValue(10)
    ;
  //Масштаб
  cp5.addRadioButton("radio")
    .setPosition(610, 40)
    .setItemWidth(20)
    .setItemHeight(20)
    .addItem(" 300", 0)
    .addItem(" 180", 1)
    .addItem(" 60", 2)
    .setColorLabel(color(0, 255, 0))
    .activate(0)
    ;

  //Режим работы локатора 1-30 гр. развертка 2-180 градусов развертка
  cp5.addRadioButton("radar")
    .setPosition(1160, 40)
    .setItemWidth(20)
    .setItemHeight(20)
    .addItem(" 1", 0)
    .addItem(" 2", 1)
    .setColorLabel(color(0, 255, 0))
    .activate(0)
    ;
  font = createFont("Courier New", 30);
  textFont(font);
  textAlign(LEFT);

  //Камера
  if (demo==true) {
    cam = new IPCapture(this, "http://192.168.1.1:8080/?action=stream", "", "");
    //      cam.start();
    //Управление роботом
    robot = new Client(this, "192.168.1.1", 2001); // Подключаемся к роботу
  }
  // радар
  myFont = createFont("verdana", 12);
  sonic=new Ultrasonic(900, 350, 300);
  sonic.mashtab=50;

  //Звук работы фотоаппарата,Выключателей
  song = new SoundFile(this, "FotoClick.mp3");
  songOnn=new SoundFile(this, "sOnn.mp3");
  songOff=new SoundFile(this, "sOff.mp3");

  //скорость и обороты x,y,d,0,color,делений, цена делений,дилитель
  font1 = createFont("Courier New", 12);
  //  textFont(font1); 
  sn=new SpeedRev(800, 550, 150, 0, #0000ff, 30, 10, 0.5);
  sv=new SpeedRev(450, 550, 150, 0, #0000ff, 30, 15, 3);
}
//END SETUP
//*********************************************************************************************************
void draw() {
  background(myColor);
  //Отправка запроса на получение данных локатора, Т, Р, К  
  comControl[0]=0x13;
  comControl[1]=0x06;
  comControl[2]=0x01;
  send_comand_control();
  delay(50);
  //********************************************************
  strokeWeight(5);
  fill(65, 105, 225);
  stroke(65, 105, 225);
  textSize(16);
  textAlign(LEFT);
  text("Камера", 220, 15);
  text("Ультразвуковой локатор", 800, 15);
  text("Управление", 580, 490);
  text("Скорость", 410, 630);
  text("Температура: "+Integer.toString(Tatm)+" гр. С", 720, 670);
  text("Давление: "+Integer.toString(Patm)+" мм рт.ст", 720, 690);
  text("Фото", 272, 485);
  //  text("Видео", 370, 560);
  if (camOff!=true) {
    noStroke();
    fill(17, 17, 17);
    rect(20, 20, 500, 375);
  }
  noStroke();
  fill(17, 17, 17);
  ellipse(542, 15, 10, 10);//индикатор приема данных о курсе
  ellipse(554, 15, 10, 10);//индикатор приема данных о температуре
  ellipse(566, 15, 10, 10);//индикатор приема данных о давление
  ellipse(578, 15, 10, 10);//индикатор приема данных о дальности
  ellipse(590, 15, 10, 10);//индикатор приема данных об оборотах
  //*****************************************************************
  if (demo==true) {
    if (camOff==true) {
      if (cam.isAvailable()) {
        cam.read();
        image(cam, 20, 20, 500, 375);
      }
    }
    decoder();// прием данных от робота
  }


  //kkp
  kurs.display(heading);
  kurs.strelka(u);
  kurs.strelkaBok(b);
  //
  sn.display();
  sv.display();

  if (demo==true) {
    sn.strelka(iRev, stn);
    sv.strelka(iSpeed, sts);
  } else {
    sn.strelka(48, stn);
    sv.strelka(int(48*0.065*PI), sts);
  }
  //************************************************
  // fill(0);
  // Вывод на экран показаний
  if (logSonic==true) {
    sonic.radar(intDegr, val);
    rectMode(LEFT);//необходим для сброса уставки в классе ultrasonic
  } else {
    fill(0, 100, 0);
    text("Масштаб", 641, 33);
    text("Режим", 1175, 33);
    noStroke();
    fill(17, 17, 17);
    arc(900, 350, 600, 600, PI, TWO_PI, CHORD);
  }
  delay(50);
}
//END DRAW *************************************************************
public void createLabels() {
  label1 = new GLabel(this, 80, 490, 120, 50);
  label1.setText("ИК датчик препятсвия");
  //  label1.setTextBold();
  label1.setOpaque(true);
  label2 = new GLabel(this, 80, 560, 120, 50);
  label2.setText("Ультрозвуковой локатор");
  //label2.setTextBold();
  label2.setOpaque(true);
  label3 = new GLabel(this, 80, 630, 120, 50);
  label3.setText("Камера");
  // label3.setTextBold();
  label3.setOpaque(true);
  //  label4 = new GLabel(this, 80, 700, 120, 50);
  //  label4.setText("Свет");
  //  label4.setTextBold();
  //  label4.setOpaque(true);
}



//Углы поворота камеры
void X(int angleX) {
  comControl[0]=0x01;
  comControl[1]=0x07;
  comControl[2]=angleX;
  send_comand_control();
  // delay(50);
}
void Y(int angleY) {
  comControl[0]=0x01;
  comControl[1]=0x08;
  comControl[2]=angleY;
  send_comand_control();
  // delay(50);
} 

//Скорость
void L(int theSpeed) {
  comControl[0]=0x02;
  comControl[1]=0x01;
  comControl[2]=theSpeed;
  send_comand_control();
}

void R(int theSpeed) {
  comControl[0]=0x02;
  comControl[1]=0x02;
  comControl[2]=theSpeed;
  send_comand_control();
}

//Выключатели
void handleToggleButtonEvents(GImageToggleButton button, GEvent event) {
  if (button == btnIC && event == GEvent.CLICKED) {
    int theValue=button.getState();
    if (theValue==1) {
      comControl[0]=0x13;
      comControl[1]=0x03;
      comControl[2]=0x01;
      send_comand_control();
      songOnn.play();
    } else {
      comControl[0]=0x13;
      comControl[1]=0x03;
      comControl[2]=0x00;
      send_comand_control();
      songOff.play();
    }
  }
  if (button == btnSonar && event == GEvent.CLICKED) {
    int theSonar=button.getState();
    if (theSonar==1) {
      comControl[0]=0x13;
      comControl[1]=0x05;
      comControl[2]=0x01;
      send_comand_control();
      logSonic=true;
      songOnn.play();
    } else {
      comControl[0]=0x13;
      comControl[1]=0x05;
      comControl[2]=0x00;
      send_comand_control();
      logSonic=false;
      songOff.play();
    }
  }
  if (button == btnCamera && event == GEvent.CLICKED) {
    int theCamera=button.getState(); 
    if (theCamera == 1) {
      songOnn.play();
      camOff=true;
      if (demo==true)cam.start();
    } else {
      songOff.play();
      camOff=false;
      if (demo==false) cam.stop();
    }
  }
  if (button == btnLight && event == GEvent.CLICKED) {
    int theLight=button.getState(); 
    if (theLight==1) {
      comControl[0]=0x04;
      comControl[1]=0x00;
      comControl[2]=0x00;
      send_comand_control();
      songOnn.play();
    } else {
      comControl[0]=0x04;
      comControl[1]=0x01;
      comControl[2]=0x00;
      send_comand_control();
      songOff.play();
    }
  }
}


//Фото
void btnFoto() {
  int iDay = day(); 
  int iMonth = month();
  int iYear = year();
  int iSecond = second();  
  int iMinute = minute(); 
  int iHour = hour(); 
  song.play();
  String fotoName=String.valueOf(iDay)+String.valueOf(iMonth)+String.valueOf(iYear)+String.valueOf(iHour)+String.valueOf(iMinute)+String.valueOf(iSecond)+".jpg";
  PImage img=get(20, 20, 500, 375);
  img.save(fotoName);
}

public void buttonForward() {
  comControl[0]=0x00;
  comControl[1]=0x01;
  comControl[2]=0x00;
  send_comand_control();
  pressOff=false;
}

public void buttonBackward() {
  comControl[0]=0x00;
  comControl[1]=0x02;
  comControl[2]=0x00;
  send_comand_control();
  pressOff=false;
}

public void buttonTurnLeft() {
  comControl[0]=0x00;
  comControl[1]=0x03;
  comControl[2]=0x00;
  send_comand_control();
  pressOff=false;
}

public void buttonTurnRight() {
  comControl[0]=0x00;
  comControl[1]=0x04;
  comControl[2]=0x00;
  send_comand_control();
  pressOff=false;
}


//Управление масштабом радара
void radio(int theC) {
  switch(theC) {
    case(0):
    sonic.mashtab=50;
    break;
    case(1):
    sonic.mashtab=30;
    break;
    case(2):
    sonic.mashtab=10;
    break;
  }
} 
//Управление режимом работы локатора
void radar(int theR) {
  switch(theR) {
    case(0):
    comControl[0]=0x13;
    comControl[1]=0x07;
    comControl[2]=0x00;
    send_comand_control();
    flagControl=0;
    break;
    case(1):
    comControl[0]=0x13;
    comControl[1]=0x07;
    comControl[2]=0x01;
    send_comand_control();
    flagControl=1;
    break;
  }
}
void mousePressed() {
}

void mouseReleased() {
  if (pressOff==false) {
    comControl[0]=0x00;
    comControl[1]=0x00;
    comControl[2]=0x00;
    send_comand_control();
    pressOff=true;
  }
}
//Передача команд управления
void send_comand_control() {
  if (demo==true) {
    robot.write(0xff);
    robot.write(comControl[0]);
    robot.write(comControl[1]);
    robot.write(comControl[2]);
    robot.write(0xff);
  }
  //println("Команда");
  //println(comControl[0]);
  //println(comControl[1]);
  //println(comControl[2]);
}
//Декодирование принятых данных
void decoder() {
  fill(0, 255, 0);
  u=0;
  b=0;
  if (robot.available() > 0) {
    strData = robot.readStringUntil('\n');
    while (strData != null) {

      //    println(strData);

      intLenght=strData.length();
      fltData=float(strData.substring(0, intLenght-3));
      strKod=strData.substring(intLenght-3, intLenght-2);
      //  println(strKod);
      switch(strKod) {
      case "T": 
        ellipse(554, 15, 10, 10);//индикатор приема данных о температуре
        Tatm=int(fltData); 
        break;
      case "P": 
        ellipse(566, 15, 10, 10);//индикатор приема данных о давление
        Patm=int(fltData); 
        break;
      case "K":  
        ellipse(542, 15, 10, 10);//индикатор приема данных о курсе
        heading=int(fltData);
        break;
      case "U": 
        intDegr=180-int(fltData);
        //      println(fltData);
        break;
      case "D":  
        ellipse(578, 15, 10, 10);//индикатор приема данных о дальности
        val=int(fltData);
        //      println(val);
        break;
      case "N":
        ellipse(590, 15, 10, 10);//индикатор приема данных о оборотах
        iRev=int(fltData); //обороты
        iSpeed=int(iRev*0.065*PI);//скорость
        break;
      }
      strData = robot.readStringUntil('\n');
    }
  }
}
