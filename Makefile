# For compiling Vaadin projects

TOMCAT = /home/mjvesa/opt/tomcat
WEBAPPS =  $(TOMCAT)/webapps
CLASSPATH = .:WEB-INF/lib/*:$(TOMCAT)/lib/*:WEB-INF/classes
JFLAGS = -g -cp $(CLASSPATH) -d WEB-INF/classes -source 1.6 -target 1.6

JC = javac
.SUFFIXES: .java .class
.java.class:
	$(JC) $(JFLAGS) $*.java

CLASSES = \
	./src/main/java/com/github/mjvesa/spil/VaadinUtil.java \
	./src/main/java/com/github/mjvesa/spil/WatchDir.java \
	./src/main/java/com/github/mjvesa/spil/SchemeComponentState.java \
	./src/main/java/com/github/mjvesa/spil/SchemeComponent.java \
	./src/main/java/com/github/mjvesa/spil/MyUI.java \

default: classes package deploy

classes: $(CLASSES:.java=.class)

package:
	cp -r src/main/resources/* WEB-INF/classes
	cp spil.properties WEB-INF/classes
	cp scm/* WEB-INF/classes
	zip -r spil.war *

deploy:
	cp spil.war $(WEBAPPS)

clean:
	$(RM) $(CLASSES:.java=.class)
