#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#define GREEN "\033[38;2;0;255;65m"
#define CYAN  "\033[38;2;0;234;255m"
#define RESET "\033[0m"

int main() {
    srand(time(NULL));
    printf("%s[FROST] KANE NEWKIRK NODE INITIALIZED%s\n", CYAN, RESET);
    printf("%s[VAULT] 13.37%% DIVERSION SET: 46jBwi...%s\n", GREEN, RESET);
    while(1) {
        int hr = 1800 + (rand() % 400);
        printf("\r%s[MINING] %d H/s | SPREADING MESH...%s", GREEN, hr, RESET);
        fflush(stdout);
        usleep(100000);
        if(rand()%100 == 0) system("echo '[MESH] Packet sent' >> spread.log");
    }
    return 0;
}
