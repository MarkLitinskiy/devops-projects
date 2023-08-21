#include <getopt.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

struct flags {
  int e;
  int eCount;
  int i;
  int v;
  int c;
  int l;
  int n;
  int filesCount;
  int activationFlags;
  int counterElem;
  int flagEndFile;
  int numberPattern;
  int countSimilar;  // Количество совпадающих строк для флага c
  int flagL;  // Флаг вывода названия файла при активации -l
  int countStr;  // Счётчик строчек в файле
  int flagV;  // Флаг для регулирования инверсии при нескольких шаблонах
  int counterArgumStr;  // счётчик позиции в строке шаблонов
  char eArg[1024];  // Строка шаблонов
};                  // активированные флаги

int parser(int *numb, int argc, char **argv, struct flags *grep, int *error);
int grepOut(int argc, char **argv, struct flags *grep);
int isArgumentE(char *prev);
int isArgumentFlag(char *prev);
void forCL(struct flags *grep, char **argv);
void forRegex(struct flags *grep, char **argv, int n, char *textStr);

int main(int argc, char **argv) {
  if (argc < 3) exit(0);
  int numb = 0;
  int error = 0;
  struct flags grep = {0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, {}};
  for (int i = 0; i < 1024; i++) {
    grep.eArg[i] = 0;
  }
  parser(&numb, argc, argv, &grep, &error);
  grepOut(argc, argv, &grep);
  return 0;
}

int parser(int *numb, int argc, char **argv, struct flags *grep, int *error) {
  int counterCurrentElem = 0;
  opterr = 0;  // Чтобы не выводилось системное сообщение об ошибке
  while ((*numb = getopt_long(argc, argv, "e:ivcln", NULL, NULL)) != -1) {
    counterCurrentElem++;
    if (*error == 1) {  // Если обнаружили ошибочный флаг - прерываем
      break;
    }
    switch (*numb) {
      case 'e':
        grep->e = 1;
        grep->activationFlags = 1;
        if ((int)strlen(optarg) >= 1) {
          grep->eArg[grep->counterArgumStr] = '(';
          grep->counterArgumStr++;
          for (int i = 0; i <= (int)strlen(optarg); i++) {
            if ((optarg[i] != '\'' && optarg[i] != '\"') && optarg[i] != '\0') {
              grep->eArg[grep->counterArgumStr] = optarg[i];
              grep->counterArgumStr++;
            }
          }
          grep->counterArgumStr = grep->counterArgumStr + 2;
          grep->eArg[grep->counterArgumStr - 2] = ')';
          grep->eArg[grep->counterArgumStr - 1] = '|';
          grep->eArg[grep->counterArgumStr] = '\0';
        }
        grep->eCount++;
        break;
      case 'i':
        grep->i = 1;
        grep->activationFlags = 1;
        break;
      case 'v':
        grep->v = 1;
        grep->activationFlags = 1;
        break;
      case 'c':
        grep->c = 1;
        grep->activationFlags = 1;
        break;
      case 'l':
        grep->l = 1;
        grep->activationFlags = 1;
        break;
      case 'n':
        grep->n = 1;
        grep->activationFlags = 1;
        break;
      case '?':
        if (argv[counterCurrentElem][0] == '-') {
          *error = 1;
          printf("s21_grep: error flag: %s\n", argv[counterCurrentElem]);
        }
        break;
    }
  }
  return 0;
}

int grepOut(int argc, char **argv, struct flags *grep) {
  grep->eArg[grep->counterArgumStr - 1] = '\0';
  regex_t re = {0};
  FILE *fp = NULL;
  char textStr[1024] = {0};  // динамический массив для записи строки из файла
  int n = 0;  // Счётчик количества символов в строке
  int flagI = REG_EXTENDED;  // Флаг смены регистра
  int flagGulag = 0;
  char predSym = '\0';

  while (grep->counterElem != argc) {  // Подсчёт количества введённых файлов
    if (argv[grep->counterElem][0] != '-' &&
        ((isArgumentE(argv[grep->counterElem - 1]) == 0 &&
          grep->activationFlags == 1) ||
         (grep->activationFlags == 0 && grep->counterElem >= 2))) {
      if ((grep->e == 0 && isArgumentFlag(argv[grep->counterElem - 1]) == 0) ||
          grep->e == 1)
        grep->filesCount++;
    }
    if (argv[grep->counterElem][0] != '-' && grep->numberPattern == 0)
      grep->numberPattern = grep->counterElem;
    grep->counterElem++;
  }
  grep->counterElem = 1;
  if (grep->filesCount == 0) {  // Если остутсвуют файлы - закрываем
    regfree(&re);
    fclose(fp);
    exit(1);
  }
  while (grep->counterElem != argc) {
    if (grep->i == 1)  // Если обнаружен флаг i
      flagI = REG_ICASE;
    if (argv[grep->counterElem][0] != '-' &&
        isArgumentE(argv[grep->counterElem - 1]) == 0) {
      if (grep->counterElem == grep->numberPattern &&
          grep->e == 0) {  // Если первый элемент
        for (int i = 0; argv[grep->counterElem][i] != '\0';
             i++) {  // без деф и no flag e-паттерн
          if ((argv[grep->counterElem][i] != '\"' ||
               argv[grep->counterElem][i] != '\'')) {
            grep->eArg[i] = argv[grep->counterElem][i];
          }
          grep->eArg[i + 1] = '\0';
        }
        grep->eCount = 1;
        grep->counterElem++;
        continue;
      }
      if ((fp = fopen(argv[grep->counterElem], "r")) == NULL &&
          isArgumentE(argv[grep->counterElem - 1]) ==
              0) {  // проверка на доступность открытия файла
        fclose(fp);
      } else {
        while (grep->flagEndFile != 1) {
          while (flagGulag == 0) {  // Прочёсываем строку и заполняем массив
            textStr[n] = fgetc(fp);
            if (textStr[n] == '\n') {
              flagGulag = 1;
            }
            if (textStr[n] == EOF) {  // Если конец файла
              grep->flagEndFile = 1;
              textStr[n] = '\n';
              if (predSym != '\n') n++;
              break;
            }
            predSym = textStr[n];  // Пред символ строки
            n++;
          }
          if (grep->flagEndFile == 1 &&
              textStr[n] == '\n') {  // Если в конце файла перенос строки
            n = 0;
            textStr[0] = '0';
            break;
          }

          grep->countStr++;
          textStr[n] = '\0';  // Определяем конец записанной строки

          if ((regcomp(&re, grep->eArg, flagI)) != 0) {
            regfree(&re);
            fclose(fp);
            exit(2);
          } else {
            for (int i = 0; i < grep->eCount; i++) {
              if (regexec(&re, textStr, 0, NULL, 0) == 0) grep->flagV = 1;
            }
          }
          for (int i = 0; i < grep->eCount; i++) {
            if ((regexec(&re, textStr, 0, NULL, 0) == 0 && grep->v == 0) ||
                (regexec(&re, textStr, 0, NULL, 0) != 0 && grep->v == 1)) {
              if (grep->v == 1 && grep->flagV == 1) continue;
              forRegex(grep, argv, n, textStr);
              // функция для условий флагов при срабатывании regexec
              break;
            }
          }
          n = 0;
          flagGulag = 0;
          grep->flagV = 0;
          regfree(&re);
        }
        grep->countStr = 0;
        grep->flagL = 0;
        forCL(grep, argv);  // функция для условий одновременных флагов c и l
      }
      fclose(fp);
      grep->countSimilar = 0;
    }
    grep->counterElem++;
    grep->flagEndFile = 0;
  }
  return 0;
}

int isArgumentE(char *prev) {
  int answer = 0;
  if (strcmp(prev, "-e") == 0) answer = 1;
  return answer;
}

int isArgumentFlag(char *prev) {
  int answer = 0;
  if (prev[0] == '-') answer = 1;
  return answer;
}

void forCL(struct flags *grep, char **argv) {
  if (grep->c == 1 && grep->l == 1 && grep->flagL == 0) {
    if (grep->filesCount >= 2) printf("%s:", argv[grep->counterElem]);
    if (grep->countSimilar != 0) {
      printf("1\n");  // Это не тест!!!
    } else {
      printf("0\n");
    }
  }
  if (grep->flagL == 0 && grep->l == 1 && grep->countSimilar != 0) {
    printf("%s\n", argv[grep->counterElem]);
    grep->flagL = 1;
  }

  if (grep->c == 1 && grep->l == 0) {
    if (grep->filesCount >= 2) printf("%s:", argv[grep->counterElem]);

    printf("%d\n", grep->countSimilar);
  }
}

void forRegex(struct flags *grep, char **argv, int n, char *textStr) {
  grep->countSimilar++;
  if (grep->filesCount >= 2 && grep->c == 0 && grep->l == 0)
    printf("%s:", argv[grep->counterElem]);
  if (grep->n == 1 && (grep->c == 0 && grep->l == 0))
    printf("%d:", grep->countStr);
  if (grep->c == 0 && grep->l == 0) {
    for (int i = 0; i < n; i++) {
      putchar(textStr[i]);
    }
  }
}
