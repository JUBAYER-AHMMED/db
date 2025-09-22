/*void MSDelay(unsigned char Time){
unsigned char y,z;
for(y=0;y<Time;y++)
for(z=0;z<250;z++);
}       */

void main()
{
TRISC = 0;
TRISD = 0;

while(1)
{

PORTD = 0b01000000;   //1
PORTC = 0b10000000;
delay_ms(1);
/*
PORTD = 0b00000010;        //2
PORTC = 0b11111111;
delay_ms(1);

  PORTD = 0b00100000;     //3
PORTC = 0b00010000;
delay_ms(10);

PORTD = 0b00010000;       //4
PORTC = 0b00010000;
delay_ms(1);

PORTD = 0b00001000;     //5
PORTC = 0b00010000;
delay_ms(1);
          /*
PORTD = 0b00000100;       //6
PORTC = 0b10010001;
delay_ms(1);


PORTD = 0b00000010;       //7
PORTC = 0b10010001;
delay_ms(1);


PORTD = 0b00000001;         //8
PORTC = 0b10011111;
delay_ms(1);  */

//PORTD = 0b10000000;
//PORTC = 0b11000000;
//MSDelay(10);

//PORTD = 0b10000000;
//PORTC = 0b11000000;
//MSDelay(10);

//PORTD = 0b10000000;
//PORTC = 0b11000000;
//MSDelay(10);

}
}