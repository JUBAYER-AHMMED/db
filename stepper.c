void main()
{
TRISD = 0b0000000; // PORT D as output port
PORTD = 0b1111111;
do
{
PORTD = 0b00000011;
Delay_ms(500); // delay of 0.5s
PORTD = 0b00000110;
Delay_ms(500);
PORTD = 0b00001100;
Delay_ms(500);
PORTD = 0b00001001;
Delay_ms(500);
// energizing two phases at a time
}while(1); // loop executed infinite times