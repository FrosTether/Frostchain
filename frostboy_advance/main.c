#include <tonc.h>

#define STATE_LOGO 0
#define STATE_BIOS 1
#define STATE_MENU 2
#define STATE_GAME1 3
#define STATE_GAME2 4

int state = STATE_LOGO;
int menu_sel = 0;
int t = 0;

void run_logo() {
    if(t==1) { m3_fill(CLR_WHITE); tte_printf("#{P:70,70;C:0}FAT PRODUCTIONS"); }
    if(t>120) { state=STATE_BIOS; t=0; }
}

void run_bios() {
    if(t==1) { m3_fill(CLR_BLACK); tte_printf("#{P:10,10;C:2}FROST OS KERNEL v219"); tte_printf("#{P:10,30}LOADING WAN DRIVERS..."); }
    if(t>30 && t<150) m3_rect(20,140, 20+t, 145, CLR_LIME);
    if(t>180) { state=STATE_MENU; t=0; }
}

void run_menu() {
    key_poll();
    if(key_hit(KEY_UP) || key_hit(KEY_DOWN)) { menu_sel ^= 1; t=0; } // Force redraw
    if(key_hit(KEY_A)) { state = (menu_sel==0 ? STATE_GAME1 : STATE_GAME2); t=0; m3_fill(CLR_BLACK); return; }

    if(t==0) { // Draw UI once per change
        m3_fill(CLR_BLACK);
        tte_printf("#{P:80,10;C:3}FROSTBOY ADVANCE");
        m3_rect(40,40,200,70, (menu_sel==0 ? CLR_DARK(5) : 0));
        m3_rect(40,80,200,110, (menu_sel==1 ? CLR_DARK(5) : 0));
        m3_frame(40,40,200,70, (menu_sel==0 ? CLR_CYAN : CLR_GRAY));
        m3_frame(40,80,200,110, (menu_sel==1 ? CLR_MAGENTA : CLR_GRAY));
        tte_printf("#{P:50,50}> CRYPTODOKU");
        tte_printf("#{P:50,90}> FROSTCRUSH");
    }
}

void run_game1() {
    if(t==1) { m3_fill(CLR_BLACK); tte_printf("#{P:10,10;C:6}CRYPTODOKU VALIDATOR"); }
    if(t%60==0) tte_printf("#{P:10,140;C:2}HASH: 906.6 H/s [SYNC]");
    key_poll(); if(key_hit(KEY_B)) { state=STATE_MENU; t=0; }
}

void run_game2() {
    if(t==1) { m3_fill(CLR_MAGENTA); tte_printf("#{P:80,70;C:1}FROSTCRUSH"); }
    key_poll(); if(key_hit(KEY_B)) { state=STATE_MENU; t=0; }
}

int main() {
    REG_DISPCNT = DCNT_MODE3 | DCNT_BG2;
    tte_init_bmp(3, &vwf_default, NULL);
    while(1) {
        vid_vsync(); t++;
        switch(state) {
            case STATE_LOGO: run_logo(); break;
            case STATE_BIOS: run_bios(); break;
            case STATE_MENU: run_menu(); break;
            case STATE_GAME1: run_game1(); break;
            case STATE_GAME2: run_game2(); break;
        }
    }
    return 0;
}
