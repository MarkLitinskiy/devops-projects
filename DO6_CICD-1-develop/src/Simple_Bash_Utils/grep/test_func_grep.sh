#!/bin/bash

SUCCESS=0
FAIL=0
COUNTER=0
DIFF_RES=""

declare -a tests=(
"s tests/test_0_grep.txt VAR"
 "for s21_grep.c ../Makefile VAR"
 "for s21_grep.c VAR"
# "-e for -e ^int s21_grep.c ../Makefile VAR"
 "-e ^int s21_grep.c VAR"
# "-e regex -e ^print s21_grep.c VAR"
# "-e while -e void s21_grep.c ../Makefile VAR"
)

declare -a extra=(
"-n for tests/test_1_grep.txt tests/test_2_grep.txt"
 "-n for tests/test_1_grep.txt"
 "-n -e ^\} tests/test_1_grep.txt"
"-c ^int tests/test_1_grep.txt tests/test_2_grep.txt"
"-e ^int tests/test_1_grep.txt tests/test_2_grep.txt"
"-e ^int tests/test_1_grep.txt"
"-n = tests/test_1_grep.txt tests/test_2_grep.txt"
"-i = tests/test_1_grep.txt tests/test_2_grep.txt"
"-v = tests/test_1_grep.txt tests/test_2_grep.txt"
#"-e"
"-i INT tests/test_5_grep.txt"
"-e INT tests/test_5_grep.txt"
"-echar tests/test_1_grep.txt tests/test_2_grep.txt"
#"-e = -e out tests/test_5_grep.txt"
"-i int tests/test_5_grep.txt"
"-i int tests/test_5_grep.txt"
"-n int tests/test_5_grep.txt"
#"-c -l aboba tests/test_1_grep.txt tests/test_5_grep.txt"
"-v tests/test_1_grep.txt -e ank"
"-n ) tests/test_5_grep.txt"
"-e ) tests/test_5_grep.txt"
"-l for tests/test_1_grep.txt tests/test_2_grep.txt"
"-e int tests/test_4_grep.txt"
#"-e = -e out tests/test_5_grep.txt"
#"-n -e ing -e as -e the -e not -e is tests/test_6_grep.txt"
#"-e ing -e as -e the -e not -e is tests/test_6_grep.txt"
"-n tests/test_3_grep.txt tests/test_5_grep.txt"
)

testing()
{
    t=$(echo $@ | sed "s/VAR/$var/")
    ./s21_grep $t > test_s21_grep.log
    grep $t > test_sys_grep.log
    DIFF_RES="$(diff -s test_s21_grep.log test_sys_grep.log)"
    (( COUNTER++ ))
    if [ "$DIFF_RES" == "Files test_s21_grep.log and test_sys_grep.log are identical" ]
    then
      (( SUCCESS++ ))
      #echo "\033[31m$FAIL\033[0m/\033[32m$SUCCESS\033[0m/$COUNTER \033[32msuccess\033[0m grep $t"
    else
      (( FAIL++ ))
      echo -e "\033[31m$FAIL\033[0m/\033[32m$SUCCESS\033[0m/$COUNTER \033[31mfail\033[0m grep $t"
    fi
    rm test_s21_grep.log test_sys_grep.log
}

# специфические тесты
for i in "${extra[@]}"
do
    var="-"
    testing $i
done

# 1 параметр
for var1 in v c l n
do
    for i in "${tests[@]}"
    do
        var="-$var1"
        testing $i
    done
done

# 2 параметра
for var1 in v n
do
    for var2 in v c l n
    do
        if [ $var1 != $var2 ]
        then
            for i in "${tests[@]}"
            do
                var="-$var1 -$var2"
                testing $i
            done
        fi
    done
done

# 3 параметра
# for var1 in v c l n
# do
#     for var2 in v c l n
#     do
#         for var3 in v c l n
#         do
#             if [ $var1 != $var2 ] && [ $var2 != $var3 ] && [ $var1 != $var3 ]
#             then
#                 for i in "${tests[@]}"
#                 do
#                     var="-$var1 -$var2 -$var3"
#                     testing $i
#                 done
#             fi
#         done
#     done
# done


echo -e "\033[31mFAIL: $FAIL\033[0m"
echo -e "\033[32mSUCCESS: $SUCCESS\033[0m"
echo "ALL: $COUNTER"
if [[ $FAIL -eq 0 ]]; then
 exit 0
 else 
 exit 1
 fi
