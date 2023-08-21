#! /bin/bash

scp src/Simple_Bash_Utils/cat/s21_cat root@172.24.116.8:/usr/local/bin
scp src/Simple_Bash_Utils/grep/s21_grep root@172.24.116.8:/usr/local/bin

ssh root@172.24.116.8 ls -lah /usr/local/bin/