# For compiling Vaadin projects

TOMCAT = /home/yobi/opt/tomcat
WEBAPPS =  $(TOMCAT)/webapps
JFLAGS = -g -cp .:WEB-INF/lib/*:$(TOMCAT)/lib/* -d WEB-INF/classes

JC = javac
.SUFFIXES: .java .class
.java.class:
	$(JC) $(JFLAGS) $*.java

CLASSES = \
	./src/main/java/com/github/mjvesa/spil/VaadinUtil.java \
	./src/main/java/com/github/mjvesa/spil/MyUI.java \

default: classes package deploy

classes: $(CLASSES:.java=.class)

package:
	zip -r spil.war *

deploy:
	cp spil.war $(WEBAPPS)

clean:
	$(RM) $(CLASSES:.java=.class)
