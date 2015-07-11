# For compiling Vaadin projects

WEBAPPS =  /home/mjvesa/opt/apache-tomcat-7.0.40/webapps
JFLAGS = -g -cp .:WEB-INF/lib/*:/home/mjvesa/opt/apache-tomcat-7.0.40/lib/* -d WEB-INF/classes

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
