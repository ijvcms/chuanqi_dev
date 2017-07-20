user=${1:?no user}
passwd=${2:?no password}
game=${3:?no game db}

cd ../db_script
mysql -u$user -p$passwd -e "create database $game; use $game; source chuanqi_db.sql;"