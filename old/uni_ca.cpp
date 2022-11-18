#include <conio.h>
#include <dos.h>
#include <string.h>
#include <stdlib.h>

struct dostime_t tm;
void interrupt (* OldHandler08H)(...);
void interrupt (* OldHandler09H)(...);

int hr = 0;
int mt = 0;
int sc = 0;
int ms = 0;

char show_ms = 0;
char eggsit = 0;

void interrupt NewHandler09H(...)
{
	if (inp(0x60) == 88) show_ms = !show_ms;
	if (inp(0x60) == 1) eggsit = 1;

	outp(0x20,0x20);
}

void interrupt NewHandler08H(...)
{
 char text[13] = "00:00:00.000";
                //012345678901
 char hour[3];
 char minute[3];
 char second[3];
 char millisecond[4];

 itoa(hr, hour, 10);
 itoa(mt, minute, 10);
 itoa(sc, second, 10);
 itoa(ms, millisecond, 10);

 text[0] = hour[0];
 text[1] = hour[1];

 text[3] = minute[0];
 text[4] = minute[1];

 text[6] = second[0];
 text[7] = second[1];

 text[9] = millisecond[0];
 text[10] = millisecond[1];
 text[11] = millisecond[2];
 
 if (hr <= 9)  { text[1] = text[0]; text[0] = '0';}
 if (mt <= 9)  { text[4] = text[3]; text[3] = '0';}
 if (sc <= 9)  { text[7] = text[6]; text[6] = '0';}
 if (ms <= 99) { text[11] = text[10]; text[10] = text[9]; text[9] = '0';}
 if (ms <= 9)  { text[11] = text[10]; text[10] = text[9]; text[9] = '0';}

 clrscr();
 for (int i = 0; i <= 11 - (!show_ms * 4); i++)
  pokeb(0xB800, 12 * 160 + (40 + i) * 2, text[i]);
 

 ms += 55;
 if (ms >= 1000)
 {
  ms -= 1000;
  sc++;
  if (sc >= 60)
  {
   sc -= 60;
   mt++;
   if (mt >= 60)
   {
    mt -= 60;
    hr++;
    if (hr >= 24)
    {
     hr-=24;
    }
   }
  }
 }

 outp(0x20,0x20);
}

void main()
{
 _dos_gettime(&tm);
 hr = tm.hour;
 mt = tm.minute;
 sc = tm.second;
 ms = tm.hsecond;

 textcolor(LIGHTGRAY);
 textbackground(BLACK);
 _setcursortype(_NOCURSOR);
 clrscr();

 OldHandler08H = getvect(0x08);
 setvect(0x08, NewHandler08H);
 OldHandler09H = getvect(0x09);
 setvect(0x09, NewHandler09H);

 do
 {
  _dos_gettime(&tm);
  delay(10);
 }
 while (!eggsit);
 
 setvect(0x08, OldHandler08H);
 setvect(0x09, OldHandler09H);

 _setcursortype(_NORMALCURSOR);
 clrscr();
}