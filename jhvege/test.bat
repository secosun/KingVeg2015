@echo on
docker inspect --type=image  ghcr.io/secosun/mysqlphpbase:latest |  find /C "LastTagTime" >temp
set /p existbase=<temp
if %existbase%==1 goto A 

:A
echo xyz
