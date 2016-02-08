package com.github.mjvesa.spil;

import javax.servlet.annotation.WebServlet;

import java.lang.StringBuffer;
import java.util.Properties;
import java.net.URL;
import java.nio.file.FileSystems;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.FileReader;
import com.vaadin.annotations.Theme;
import com.vaadin.annotations.VaadinServletConfiguration;
import com.vaadin.annotations.Widgetset;
import com.vaadin.annotations.Push;
import com.vaadin.server.VaadinRequest;
import com.vaadin.server.VaadinServlet;
import com.vaadin.ui.VerticalLayout;
import com.vaadin.ui.Button;
import com.vaadin.ui.Button.ClickListener;
import com.vaadin.ui.UI;
import com.vaadin.event.ShortcutAction.KeyCode;
import com.vaadin.event.ShortcutAction.ModifierKey;
import jscheme.JScheme;
import com.github.mjvesa.spil.WatchDir;
import com.github.mjvesa.spil.WatchDir.FileChangeCallback;

//@Push
@Theme("base")
@Widgetset("com.vaadin.DefaultWidgetSet")
public class MyUI extends UI {

    private String sourceDir; 
    private Button evalButton;
    private JScheme scheme;

    @Override
    protected void init(VaadinRequest vaadinRequest) {
        setPollInterval(1000);
        loadProps();
        final VerticalLayout layout = new VerticalLayout();
        layout.setMargin(true);
        layout.setSizeFull();

        final VerticalLayout outputLayout = new VerticalLayout();
        outputLayout.setSizeFull();
        Button eval = new Button("Eval", new ClickListener()  {
            public void buttonClick(Button.ClickEvent event) {
                outputLayout.removeAllComponents();
                final JScheme js = new JScheme();
                js.eval("(begin " + loadBuffer() + ")");
                js.call("main", outputLayout);
        }});
    evalButton = eval;
    eval.setClickShortcut(KeyCode.R, ModifierKey.CTRL);
    VerticalLayout mainLayout = new VerticalLayout(outputLayout, eval);
    mainLayout.setSizeFull();
	mainLayout.setExpandRatio(outputLayout, 1);
    setContent(mainLayout);
        /*
	new Thread() {
	    public void run() {		
		try {
		    new WatchDir(FileSystems.getDefault().getPath(sourceDir), true, new FileChangeCallback() {
		    public void fileChange() {
			    MyUI.this.access( new Runnable() {
				    public void run() {
				        evalButton.click();
		            }
				});
		    }}).processEvents();
		} catch (IOException e) {
		    e.printStackTrace();
		}
	    }
	    }.start();*/
    }

    private String loadBuffer() {
	StringBuffer sb = new StringBuffer();
	try {
	    FileReader fr = new FileReader(new File(sourceDir + "main.scm"));
	    char[] chars = new char[100];
	    while (fr.ready()) {
		int count = fr.read(chars);
		sb.append(chars, 0, count);
	    }
	} catch (FileNotFoundException e) {
	    e.printStackTrace();
	} catch (IOException e) {
	    e.printStackTrace();
	}
	return sb.toString();
    }

   private void loadProps() {
	try {
	    URL propsURL = getClass().getClassLoader().getResource("spil.properties");
	    Properties props = new Properties();
	    FileInputStream in = new FileInputStream(propsURL.getPath());
	    props.load(in);
	    in.close();
	    sourceDir = props.getProperty("PROJECT_DIR");
	} catch (FileNotFoundException e) {
	    e.printStackTrace();
	} catch (IOException e) {
	    e.printStackTrace();
	}
    }

    public void setInterpreter(JScheme scheme) {
	this.scheme = scheme;
    }

    public JScheme getInterpreter() {
	return this.scheme;
    }

    public static MyUI getCurrent() {
	return (MyUI)UI.getCurrent();
    }
    

    @WebServlet(urlPatterns = "/*", name = "MyUIServlet", asyncSupported = true)
    @VaadinServletConfiguration(ui = MyUI.class, productionMode = false)
    public static class MyUIServlet extends VaadinServlet {
    }
}
