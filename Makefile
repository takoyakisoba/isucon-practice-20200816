.PHONY: gogo kataribe slow-log

gogo:
	sudo systemctl stop h2o
	sudo systemctl stop torb.go
	ssh isucon-app-3 sudo systemctl stop mariadb.service
	sudo truncate --size 0 /var/log/h2o/access.log
	ssh isucon-app-3 -sudo truncate --size 0 /var/lib/mysql/mysql-slow.log
	make -C app/webapp/go build
	sleep 2
	sudo systemctl start torb.go
	sudo systemctl start h2o
	ssh isucon-app-3 sudo systemctl start mariadb.service
	sleep 2
	./app/exec_bench.sh

kataribe:
	sudo cat /var/log/h2o/access.log | ./kataribe 

slow-log:
	sudo mysqldumpslow -s at -t 10 /var/lib/mysql/mysql-slow.log

