int val_gr;
int potPin1 = 0;

int val_fi;
int potPin2 = 1;

int val_wa;
int potPin3 = 2;

int val_wo;
int potPin4 = 3;

int val_me;
int potPin5 = 4;

void setup() {
  // put your setup code here, to run once:
  pinMode(potPin1, INPUT);
  pinMode(potPin2, INPUT);
  pinMode(potPin3, INPUT);
  pinMode(potPin4, INPUT);
  pinMode(potPin5, INPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  val_gr = analogRead(potPin1);
  val_fi = analogRead(potPin2);
  val_wa = analogRead(potPin3);
  val_wo = analogRead(potPin4);
  val_me = analogRead(potPin5);

  Serial.print(val_gr);
  Serial.print(" ");
  Serial.print(val_fi);
  Serial.print(" ");
  Serial.print(val_wa);
  Serial.print(" ");
  Serial.print(val_wo);
  Serial.print(" ");
  Serial.println(val_me);

  delay(100);
}
