#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

struct flags {
  int b;
  int e;
  int n;
  int s;
  int t;
  int v;
  int E;
  int T;
};  // активированные флаги

int parser(int *numb, int argc, char **argv, struct flags *cat, int *error);
int catOut(int argc, char **argv, struct flags *cat);
void catN(char currentPrev, int counterStr, int flag);
void catB(char current, char currentPrev, int counterStr, int flag);
void catS(char current, char currentPrev);
void catE(char current);
void unvisibleSym(char current);

int main(int argc, char **argv) {
  int numb = 0;
  int error = 0;
  struct flags cat = {0, 0, 0, 0, 0, 0, 0, 0};
  parser(&numb, argc, argv, &cat, &error);
  if (error == 0) {
    catOut(argc, argv, &cat);
  }
  return 0;
}

int parser(int *numb, int argc, char **argv, struct flags *cat, int *error) {
  int counterCurrentElem = 0;

  const struct option long_options[] = {
      {"number-nonblank", no_argument, NULL, 10},
      {"number", no_argument, NULL, 20},
      {"squeeze-blank", no_argument, NULL, 30},
      {NULL, 0, NULL, 0}};  // Объявляем длинные флаги

  opterr = 0;  // Чтобы не выводилось системное сообщение об ошибке
  while ((*numb = getopt_long(argc, argv, "benstvET", long_options, NULL)) !=
         -1) {
    counterCurrentElem++;
    if (argv[counterCurrentElem][0] != '-' ||
        *error == 1) {  // Если не флаг или ошибочный - прерываем
      break;
    }
    switch (*numb) {
      case 'b':
        cat->b = 1;
        break;
      case 'e':
        cat->e = 1;
        break;
      case 'n':
        cat->n = 1;
        break;
      case 's':
        cat->s = 1;
        break;
      case 't':
        cat->t = 1;
        break;
      case 'v':
        cat->v = 1;
        break;
      case 'E':
        cat->E = 1;
        break;
      case 'T':
        cat->T = 1;
        break;
      case 10:
        cat->b = 1;
        break;
      case 20:
        cat->n = 1;
        break;
      case 30:
        cat->s = 1;
        break;
      case '?':
        if (argv[counterCurrentElem][0] == '-') {
          *error = 1;
          printf("s21_cat: error flag: %s\n", argv[counterCurrentElem]);
        }
        break;
    }
    if (cat->b == 1 && cat->n == 1) cat->n = 0;
  }
  return 0;
}

int catOut(int argc, char **argv, struct flags *cat) {
  int counterElem = 1;
  int counterStr = 1;        // cчётчик строчек
  int counterStrSoderg = 1;  // счётчик непустых строк
  int flagFirstSym = 0;      // флаг первой строки
  char *textFile =
      (char *)malloc(2 * sizeof(char));  // динамический массив для записи файла
  int n = 0;  // Счётчик количества символов в файле с запасом +1
  int flagGulag = 0;
  char currentSyms[3] = {0};

  FILE *fp;
  while (counterElem != argc) {
    if (argv[counterElem][0] != '-') {
      if ((fp = fopen(argv[counterElem], "r")) ==
          NULL) {  // проверка на доступность открытия файла
        fclose(fp);
      } else {
        while (flagGulag == 0) {  // Прочёсываем файл и заполняем массив
          textFile = (char *)realloc(textFile, n + 2);
          textFile[n] = fgetc(fp);
          if (textFile[n] == EOF) {
            flagGulag = 1;
          }
          n++;
        }
        n = 0;
        while (textFile[n] != EOF) {
          if (n == 0) {
            currentSyms[0] = '\0';
            currentSyms[1] = textFile[n];
            currentSyms[2] = textFile[n + 1];
          } else {
            currentSyms[0] = textFile[n - 1];
            currentSyms[1] = textFile[n];
            currentSyms[2] = textFile[n + 1];
          }
          if (cat->s == 1) {
            if (currentSyms[0] == '\n' && currentSyms[2] == '\n') {
              n++;
              continue;
            }
          }
          if (currentSyms[0] == '\n') {  // Счётчик строк в файле
            counterStr++;
            if (currentSyms[1] != '\n' && counterStr != 2) {
              counterStrSoderg++;
            }
          }

          if (cat->n == 1) catN(currentSyms[0], counterStr, flagFirstSym);
          if (cat->b == 1)
            catB(currentSyms[1], currentSyms[0], counterStrSoderg,
                 flagFirstSym);
          if (cat->t == 1 || cat->T == 1) {
            if (currentSyms[1] == '\t') {
              printf("^I");
              n++;
              continue;
            }
          }
          if (cat->e == 1 || cat->E == 1) {
            catE(currentSyms[1]);
          }
          if (cat->t == 1 || cat->e == 1 || cat->v == 1) {
            unvisibleSym(currentSyms[1]);
          } else {
            putchar(currentSyms[1]);
          }
          if (flagFirstSym == 0)  // Проверка на первый символ
            flagFirstSym = 1;
          n++;
        }
      }
    }
    flagGulag = 0;
    flagFirstSym = 0;
    counterStrSoderg = 1;
    counterStr = 1;
    counterElem++;
    n = 0;
  }
  free(textFile);
  fclose(fp);
  return 0;
}

void catN(char currentPrev, int counterStr, int flag) {
  int countNumbers = 0;  // Количество цифр в числе номера строки
  int vrem = counterStr;
  while (vrem > 0) {  // Считаем количество цифр в числе
    countNumbers++;
    vrem = vrem / 10;
  }

  if (currentPrev == '\n' || flag == 0) {
    for (int i = 0; i < 6 - countNumbers;
         i++) {  // В зависимости от количества сивмолов пробелы
      printf(" ");
    }
    printf("%d\t", counterStr);
  }
}

void catB(char current, char currentPrev, int counterStr, int flag) {
  int countNumbers = 0;  // Количество цифр в числе номера строки
  int vrem = counterStr;
  while (vrem > 0) {  // Считаем количество цифр в числе
    countNumbers++;
    vrem = vrem / 10;
  }

  if ((currentPrev == '\n' || flag == 0) &&
      !(currentPrev == '\n' && current == '\n')) {
    if ((flag == 0 && current != '\n') || (flag != 0)) {
      for (int i = 0; i < 6 - countNumbers;
           i++) {  // В зависимости от количества сивмолов пробелы
        printf(" ");
      }
      printf("%d\t", counterStr);
    }
  }
}

void catE(char current) {
  if (current == '\n') {
    putchar('$');
  }
}

void unvisibleSym(char current) {
  if (((current < 32) && current != 10 && current != 9) || current == 127) {
    if (current == 127) {
      current = 63;
    } else {
      current = current + 64;
    }
    printf("^%c", current);
  } else {
    putchar(current);
  }
}
