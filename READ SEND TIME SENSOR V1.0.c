/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : READ SEND TIME SENSOR
Version : V1.0
Date    : 29-Apr-2025
Author  : Nguyen Van Anh
Company : VART
Comments: 


Chip type               : ATmega328P
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512

modbus RTU, baud mac dinh 9600: 

*******************************************************/

#include <mega328p.h>
#include <Init.h>
#include <delay.h>
#include <string.h>
#include <stdlib.h>
#include <i2c.h>
#include <stdio.h>

#define IN1 PIND.5
#define IN2 PIND.6
#define IN3 PIND.7
#define IN4 PINB.0
#define SQW PINC.2

#define DE PORTD.2    //EN RS485
#define RST_RTC PORTC.3

#define ON      1
#define OFF     0

#define addr_baudrate        0x011
#define addr_diaChiSlave     0x012

unsigned char baudrate;
unsigned int diaChiSlave;
unsigned char buff_rx[20] = {0};
unsigned char buff_rx_baud[5] = {0};
unsigned char buff_rx_addr[5] = {0};
unsigned char length_rx = 0;
unsigned char F_rx = 0;
bit chuTrinhMay1 = 0;   //kiem tra tinh xac thuc cua 1 chu trinh vao phai co ra, va muon ra phai co vao
bit chuTrinhMay2 = 0;   //kiem tra tinh xac thuc cua 1 chu trinh vao phai co ra, va muon ra phai co vao

typedef struct {
    unsigned char second;
    unsigned char minute;
    unsigned char hour;
    unsigned char day;     // 1-7 (DS3231 luu th? trong tu?n)
    unsigned char date;    // Ngày (1-31)
    unsigned char month;   // Tháng (1-12)
    unsigned char year;    // Nam (00-99)
} RTC_Time;

RTC_Time current;
RTC_Time realTimeIn1;       //thoi diem lieu vao khuon may 1
RTC_Time realTimeOut1;      //thoi diem lieu ra khuon may 1
RTC_Time realTimeIn2;       //thoi diem lieu vao khuon may 2
RTC_Time realTimeOut2;      //thoi diem lieu ra khuon may 2
RTC_Time timeLuuHoa1;       //thoi gian luu hoa (tu luc vao den luc ra) máy 1
RTC_Time timeLuuHoa2;       //thoi gian luu hoa (tu luc vao den luc ra) máy 2
RTC_Time timeThaoTac1;      //thoi gian thao tac (tu luc ra lan truoc den vao lan sau) máy 1
RTC_Time timeThaoTac2;      //thoi gian thao tac (tu luc ra lan truoc den vao lan sau) máy 2

// Ghi thoi gian mac dinh khi nap code: 
RTC_Time set_time = {0, 28, 01, 2, 21, 5, 25};  // giây, phút, gio, thu, ngày, tháng, nam

unsigned char bcd_to_dec(unsigned char val) {
    return ((val >> 4) * 10 + (val & 0x0F));
}

unsigned char dec_to_bcd(unsigned char val) {
    return ((val / 10) << 4) | (val % 10);
}

void set_ds3231_datetime(RTC_Time *t) {
    i2c_start();
    i2c_write(0xD0);  // DS3231 I2C address + Write
    i2c_write(0x00);  // Start at register 0 (seconds)

    i2c_write(dec_to_bcd(t->second));
    i2c_write(dec_to_bcd(t->minute));
    i2c_write(dec_to_bcd(t->hour));
    i2c_write(dec_to_bcd(t->day));
    i2c_write(dec_to_bcd(t->date));
    i2c_write(dec_to_bcd(t->month));
    i2c_write(dec_to_bcd(t->year));

    i2c_stop();
}

void read_ds3231_datetime(RTC_Time *t) {
    i2c_start();
    i2c_write(0xD0);  // DS3231 I2C address + Write
    i2c_write(0x00);  // Start at register 0 (seconds)
    i2c_start();
    i2c_write(0xD1);  // DS3231 I2C address + Read

    t->second = bcd_to_dec(i2c_read(1));
    t->minute = bcd_to_dec(i2c_read(1));
    t->hour   = bcd_to_dec(i2c_read(1));
    t->day    = bcd_to_dec(i2c_read(1));
    t->date   = bcd_to_dec(i2c_read(1));
    t->month  = bcd_to_dec(i2c_read(1) & 0x1F);  // Mask century bit
    t->year   = bcd_to_dec(i2c_read(0));

    i2c_stop();
}


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0x53;
// Place your code here

}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer1 value
TCNT1H=0xBC80 >> 8;
TCNT1L=0xBC80 & 0xff;
// Place your code here

}

// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Reinitialize Timer2 value
TCNT2=0x53;
// Place your code here

}
//=================================================================================


//TRUYEN DATA RA NGOAI ==================================================================================
void send1(unsigned char udata){//Ham gui 1 ky tu ASCII
    while(!(UCSR0A & (1<<UDRE0)));//Kiem tra co UDRE    //while(UCSRA.5 != 1);
    UDR0=udata;//Send 1 byte
}

void send(unsigned char *s){//Ham gui chuoi ki tu qua UART  ==================================================================================
     unsigned char n,i;
     DE = 1;
     n=strlen(s); //Dem xem co bao nhieu ky tu
     for(i=0;i<n;i++)//Vong lap gui tung ky tu 1
     {      
        send1(s[i]);
     }   
     DE = 0;
}


//==========================BEGIN DOC GHI VAO EPPROM ==========================
void epprom_write(unsigned int add, unsigned char data)
{
    while(EECR & (1<<EEPE));
    EEAR=add;
    EEDR=data;
    EECR=(1<<EEMPE);
    EECR|=(1<<EEPE);
}

unsigned char epprom_read(unsigned int add)
{
    while(EECR & (1<<EEPE));
    EEAR=add;
    EECR|=(1<<EERE);
    return EEDR; 
} 

void setting()
{
    if (epprom_read(0x010) != 1)
    {
        epprom_write(addr_baudrate,0x01); //1            //khoi tao khi nap code co baudrate 9600     
        epprom_write(addr_diaChiSlave,0x01);          //khoi tao khi nap code chon dia chi slave la 01
        epprom_write(0x010,1); //sau khi luu gia tri default cho cac thong so thi set len 1 de sau ko ghi nua 
        set_ds3231_datetime(&set_time);     //set realtime 1 lan khi nap code
    } 
     
    baudrate        = epprom_read(addr_baudrate);     
    diaChiSlave     = epprom_read(addr_diaChiSlave); 
    
    if      (baudrate == 1)
        UBRR0L = 71;     // THACH ANH 11.0592Mhz  71  9600  baud
    else if (baudrate == 2) 
        UBRR0L = 47;     // THACH ANH 11.0592Mhz  47  14400 baud
    else if (baudrate == 3) 
        UBRR0L = 35;     // THACH ANH 11.0592Mhz  35  19200 baud 
    else if (baudrate == 4) 
        UBRR0L = 17;     // THACH ANH 11.0592Mhz  17  38400 baud  
}

//==========================END DOC GHI VAO EPPROM ==========================  

void main(void)
{       
    Init();    
    i2c_init();
    delay_ms(100); 
    setting();
    realTimeOut1.hour = realTimeOut1.minute = realTimeOut1.second = 0; 
    
    while (1)
    {  
        /*  
        //========================================================
           read_ds3231_datetime(&current);
            
//             In ra UART neu can
             printf("Time: %02u:%02u:%02u Date: %02u/%02u/20%02u\r\n",
                    current.hour, current.minute, current.second,
                    current.date, current.month, current.year);

            delay_ms(1000); 
        //========================================================  
        */  
    
        //========================================================
        //GHI THOI GIAN IN OUT SENSSOR 1
        if(IN1 == OFF && chuTrinhMay1 == OFF) 
        {
            read_ds3231_datetime(&realTimeIn1);     //may 1
            
            //tinh time thao tac tu lan ra truoc toi lan vao tiep theo  
            if ((realTimeOut1.hour || realTimeOut1.minute || realTimeOut1.second) != 0)
            {
                timeThaoTac1.hour = realTimeIn1.hour - realTimeOut1.hour;
                timeThaoTac1.minute = realTimeIn1.minute - realTimeOut1.minute;
                timeThaoTac1.second = realTimeIn1.second - realTimeOut1.second;       
                printf("Time thao tac may 1: %02u:%02u:%02u\r\n",
                    timeThaoTac1.hour, timeThaoTac1.minute, timeThaoTac1.second); 
            }
             
            printf("Time lieu vao may 1: %02u:%02u:%02u Date: %02u/%02u/20%02u\r\n",
                realTimeIn1.hour, realTimeIn1.minute, realTimeIn1.second,
                realTimeIn1.date, realTimeIn1.month, realTimeIn1.year);  
            chuTrinhMay1 = ON;
            delay_ms(200);
        }  
        
        if(IN2 == OFF && chuTrinhMay1 == ON) 
        {
            read_ds3231_datetime(&realTimeOut1);    //may 1
            printf("Time lieu ra may 1: %02u:%02u:%02u Date: %02u/%02u/20%02u\r\n",
                realTimeOut1.hour, realTimeOut1.minute, realTimeOut1.second,
                realTimeOut1.date, realTimeOut1.month, realTimeOut1.year);
            delay_ms(200);  
            
            //tinh time luu hoa may 1
            timeLuuHoa1.hour = realTimeOut1.hour - realTimeIn1.hour;
            timeLuuHoa1.minute = realTimeOut1.minute - realTimeIn1.minute;
            timeLuuHoa1.second = realTimeOut1.second - realTimeIn1.second;
            printf("Time Luu Hoa may 1: %02u:%02u:%02u\r\n",
                timeLuuHoa1.hour, timeLuuHoa1.minute, timeLuuHoa1.second);
            chuTrinhMay1 = OFF;
            delay_ms(200);
        }        
        //========================================================   
        
        //========================================================
        //GHI THOI GIAN IN OUT SENSSOR 2
        if(IN3 == OFF && chuTrinhMay2 == OFF) 
        {
            read_ds3231_datetime(&realTimeIn2);  //may 2
            
            //tinh time thao tac tu lan ra truoc toi lan vao tiep theo  
            if ((realTimeOut2.hour || realTimeOut2.minute || realTimeOut2.second) != 0)
            {
                timeThaoTac2.hour = realTimeIn2.hour - realTimeOut2.hour;
                timeThaoTac2.minute = realTimeIn2.minute - realTimeOut2.minute;
                timeThaoTac2.second = realTimeIn2.second - realTimeOut2.second;       
                printf("Time thao tac may 2: %02u:%02u:%02u\r\n",
                    timeThaoTac2.hour, timeThaoTac2.minute, timeThaoTac2.second); 
            }
             
            printf("Time lieu vao may 2: %02u:%02u:%02u Date: %02u/%02u/20%02u\r\n",
                realTimeIn2.hour, realTimeIn2.minute, realTimeIn2.second,
                realTimeIn2.date, realTimeIn2.month, realTimeIn2.year);  
            chuTrinhMay2 = ON;
            delay_ms(200);
        }  
        
        if(IN4 == OFF && chuTrinhMay2 == ON) 
        {
            read_ds3231_datetime(&realTimeOut2);  //may 2
            printf("Time lieu ra may 2: %02u:%02u:%02u Date: %02u/%02u/20%02u\r\n",
                realTimeOut2.hour, realTimeOut2.minute, realTimeOut2.second,
                realTimeOut2.date, realTimeOut2.month, realTimeOut2.year);
            delay_ms(200);  
            
            //tinh time luu hoa may 2
            timeLuuHoa2.hour = realTimeOut2.hour - realTimeIn2.hour;
            timeLuuHoa2.minute = realTimeOut2.minute - realTimeIn2.minute;
            timeLuuHoa2.second = realTimeOut2.second - realTimeIn2.second;
            printf("Time Luu Hoa may 2: %02u:%02u:%02u\r\n",
                timeLuuHoa2.hour, timeLuuHoa2.minute, timeLuuHoa2.second);
            chuTrinhMay2 = OFF;
            delay_ms(200);
        }        
        //========================================================
    }
}
