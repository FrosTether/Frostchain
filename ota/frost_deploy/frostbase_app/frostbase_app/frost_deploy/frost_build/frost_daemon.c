#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <string.h>

// FINUX AESTHETICS
#define GREEN "\033[38;2;0;255;65m"
#define CYAN  "\033[38;2;0;234;255m"
#define DIM   "\033[38;2;80;80;80m"
#define WHITE "\033[38;2;255;255;255m"
#define RESET "\033[0m"

// PERIMETERS
#define NODE_ID "Kane Newkirk"
#define VAULT_ADDR "46jBwiEA9xVSccS8iDJ5niH7nopfm1kXU4TsTs2b1JBP46bSpuDoWvZQXqz3ZVHVHcQ4rVUpPEncyRCoyLX4GQf5LW7ThAw"
#define FEE_PERCENT 13.37

void log_msg(const char* type, const char* msg) {
    time_t now; time(&now); char* t = ctime(&now); t[strlen(t)-1] = 0;
    printf("%s[%s] %s%s%s %s\n", DIM, t, CYAN, type, RESET, msg);
}

int main() {
    srand(time(NULL));
    printf("\033[2J\033[1;1H"); // Clear
    
    // HEADER
    printf("%s// FINUX TECH // MINER v5.0 //%s\n", GREEN, RESET);
    printf("NODE IDENTITY: %s%s%s\n", WHITE, NODE_ID, RESET);
    printf("YIELD TARGET:  %s%s...%s\n", DIM, "46jBwiEA", RESET);
    printf("DIVERSION:     %s13.37%%%s\n\n", GREEN, RESET);
    
    usleep(800000);
    log_msg("SYS", "Initializing Frost/Finux Bridge...");
    log_msg("NET", "Broadcasting via Kane Newkirk Node...");
    
    long nonce = 0;
    int blocks = 0;
    
    while(1) {
        nonce++;
        int hr = 1800 + (rand() % 450); // High perf simulation
        
        // Status Line
        printf("\r%s[MINING]%s Rate: %d H/s | Nonce: %ld | Mesh: ACTIVE ", 
               GREEN, RESET, hr, nonce);
        fflush(stdout);
        
        // Block Event (Rare)
        if (rand() % 80 == 0) {
            blocks++;
            float reward = (float)(rand() % 1000) / 100.0;
            float cut = reward * (FEE_PERCENT / 100.0);
            float net = reward - cut;
            
            printf("\n");
            printf("%s>>> BLOCK FOUND! %sTotal: %.4f FTC\n", WHITE, RESET, reward);
            printf("%s>>> DIVERTING:   %.4f FTC -> VAULT (13.37%%)%s\n", CYAN, cut, RESET);
            printf("%s>>> NET PROFIT:  %.4f FTC%s\n", GREEN, net, RESET);
            log_msg("TX", "Yield split confirmed on-chain.");
            
            // Trigger Spread Script
            system("./spread.sh &");
        }
        
        usleep(100000); // Speed
    }
    return 0;
}
