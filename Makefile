OS=$(shell ./deps/readies/bin/platform --osnick)
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
$(info OS=$(OS))

all: build
	
installRedisGears:
	OS=$(OS) /bin/bash ./Install_RedisGears.sh

installJVMPlugin:
	OS=bionic /bin/bash ./Install_JVMPlugin.sh

build: installRedisGears installJVMPlugin
	mvn -Dmaven.test.skip=true package
	mkdir -p ./artifacts/snapshot/
	mkdir -p ./artifacts/release/
	version=$(shell java -cp ./target/rghibernate-jar-with-dependencies.jar:./bin/RedisGears_JVMPlugin/gears_runtime/target/gear_runtime-jar-with-dependencies.jar com.redislabs.WriteBehind version) && cp ./target/rghibernate-jar-with-dependencies.jar ./artifacts/release/rghibernate-$(version)-jar-with-dependencies.jar && cp ./target/rghibernate-jar-with-dependencies.jar ./artifacts/snapshot/rghibernate-$(GIT_BRANCH)-jar-with-dependencies.jar

run: build
	/bin/bash ./run.sh

tests: build
	cd pytest; python3 -m RLTest --clear-logs -s
