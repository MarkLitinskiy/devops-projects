all: build clean

build: s21_cat s21_grep

s21_cat: cat/s21_cat.c
	gcc -Wall -Werror -Wextra cat/s21_cat.c -o cat/s21_cat

s21_grep: grep/s21_grep.c
	gcc -Wall -Werror -Wextra grep/s21_grep.c -o grep/s21_grep

check_style: cat/s21_cat grep/s21_grep
	clang-format --Werror -n cat/s21_cat.c grep/s21_grep.c

check_func:
	cd cat && bash test_func_cat.sh
	cd grep && bash test_func_grep.sh

clean:
	rm cat/s21_cat
	rm grep/s21_grep