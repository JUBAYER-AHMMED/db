int i;
void main() {
    TRISD = 0; PORTD = 0xFF;


    
    for(i=0;i<1;i++){
    PORTD = 0b00000011;
    delay_ms(10);
    PORTD = 0xFF;
      delay_ms(1000);

    PORTD = 0b00000110;
    delay_ms(50);
    PORTD = 0xFF;
     delay_ms(1000);

    PORTD = 0b00001100;
    delay_ms(40);
    PORTD = 0xFF;
     delay_ms(1000);
       }
       
       
    while (1);
}