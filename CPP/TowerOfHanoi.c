#include <stdio.h>
#include <stdlib.h>

#ifdef WIN32
#define CLEAR_SCREEN system("cls")
#else
#define CLEAR_SCREEN system("clear")
#endif

void TowerOfHanoi(int* TowerSize, int Tower[9][3], int* level);
void Draw(int* TowerSize, int Tower[9][3], int* level);
int Check(int* TowerSize, int Tower[9][3], int* level);



void NextLevel(int *TowerSize, int Tower[9][3], int *level) {

	if (*TowerSize > 11) {

		puts("Game Over! You WIN!");
		return;
	}

	int count = 1, i = 0, j = 0;		
			
	for (i = 0; i < *TowerSize; i++) {

		for (j = 0; j < 3; j++) {

			if (j == 0)
				Tower[i][j] = count++;

			else
				Tower[i][j] = 0;
		}
	}

	*level = *level + 1;
	
	Draw(TowerSize, Tower, level);
	TowerOfHanoi(TowerSize, Tower, level);
}



int Check(int* TowerSize, int Tower[9][3], int* level) {

	int checkRight = 1, checkMiddle = 1, i = 0;

	for (i = 0; i < *TowerSize; i++) {

		if (Tower[i][2] == checkRight)
			checkRight++;

		if (Tower[i][1] == checkMiddle)
			checkMiddle++;
	}

	if (checkRight - 1 == *TowerSize || checkMiddle - 1 == *TowerSize) {

		return 1;
	}

	return 0;
}



void Draw(int* TowerSize, int Tower[9][3], int* level) {
	
	CLEAR_SCREEN;

	printf("Welcome to game Tower of Hanoi! =)\nLet's play!\n\nLEVEL %i\n\n\n", *level);

	for (int i = 0; i < *TowerSize; i++) {

		for (int j = 0; j < 3; j++) {

			switch(Tower[i][j]){
				case 1:
					printf("      (------)      ");
					break;
				case 2:
					printf("     (--------)     ");
					break;
				case 3:
					printf("    (----------)    ");
					break;
				case 4:
					printf("   (------------)   ");
					break;
				case 5:
					printf("  (--------------)  ");
					break;
				case 6:
					printf(" (----------------) ");
					break;
				case 7:
					printf("(------------------)");
					break;
				default:
					if (Tower[i][j] == 0 && i == *TowerSize - 1) {
						printf("        |__|        ");
					}
					else {
						printf("        |  |        ");
					}
					break;
			}
		}
		
		printf("\n");
	}

	printf("\n          1                   2                   3\n");
}



void TowerOfHanoi(int* TowerSize, int Tower[9][3], int* level) {

	int from, to, changed = 0, win = 0, j = 0, k;
	char nextLevel;
	
	while (!win) {

		printf("\nEnter position to move : ");		scanf("%i %i", &from, &to);
		
		for (j = 0; j < *TowerSize; j++) {

			if (Tower[j][from - 1] != 0) {

				for (k = *TowerSize - 1; k >= 0; k--) {

					if (Tower[k][to - 1] == 0) {

						Tower[k][to - 1] = Tower[j][from - 1];
						Tower[j][from - 1] = 0;
						changed = 1;
					}

					else if (Tower[j][from - 1] > Tower[k][to - 1])

						changed = 1;

					if (changed) {

						break;
					}
				}
			}

			if (changed) {

				break;
			}
		}

		changed = 0;
		Draw(TowerSize, Tower, level);
		win = Check(TowerSize, Tower, level);
	}

	printf("\nGreat work! You have solved! =)\n\n\n");
	printf("Do you want to move to next level? [y/n]: ");

	scanf("%s", &nextLevel);

	if (nextLevel == 'y'){
		
		*TowerSize = *TowerSize + 1;
		NextLevel(TowerSize, Tower, level);
	}
}



int main() {
	
	int *level = 0;
	int *TowerSize = 3;

	printf("Welcome to game Tower of Hanoi! =)\n");
	printf("Let's play!\n\n");
	
	int Tower[9][3];
	
	NextLevel(&TowerSize, Tower, &level);

	return 0;
}
