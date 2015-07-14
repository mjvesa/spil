package com.github.mjvesa.spil;

import javax.servlet.annotation.WebServlet;

import java.lang.StringBuffer;
import java.nio.file.FileSystems;
import java.io.File;
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
import com.vaadin.ui.UI;
import com.vaadin.event.ShortcutAction.KeyCode;
import com.vaadin.event.ShortcutAction.ModifierKey;
import jscheme.JScheme;
import com.github.mjvesa.spil.WatchDir;

@Push
@Theme("base")
@Widgetset("com.vaadin.DefaultWidgetSet")
public class MyUI extends UI {

    private final String SOURCE_DIR = "/home/mjvesa/spil_src/";

    @Override
    protected void init(VaadinRequest vaadinRequest) {
        final VerticalLayout layout = new VerticalLayout();
        layout.setMargin(true);
        layout.setSizeFull();

        final VerticalLayout outputLayout = new VerticalLayout();
	outputLayout.setSizeFull();
        Button eval = new Button("Eval", event -> {
		outputLayout.removeAllComponents();
		final JScheme js = new JScheme();
		js.eval("(begin " + loadBuffer() + ")");
		js.call("main", outputLayout);
	    });
        eval.setClickShortcut(KeyCode.R, ModifierKey.CTRL);
        VerticalLayout mainLayout = 
	    new VerticalLayout(outputLayout, eval);
        mainLayout.setSizeFull();
	mainLayout.setExpandRatio(outputLayout, 1);
        setContent(mainLayout);
	new Thread() {
	    public void run() {		
		try {
		    new WatchDir(FileSystems.getDefault().getPath(SOURCE_DIR), true, () -> {
			    MyUI.this.access( new Runnable() {

				    public void run() {
					outputLayout.removeAllComponents();
					final JScheme js = new JScheme();
					js.eval("(begin " + loadBuffer() + ")");
					js.call("main", outputLayout);
					System.out.println("Dudes, I just evaled");
				    }
				});
				}).processEvents();
			} catch (IOException e) {
			e.printStackTrace();
		    }
		}
	    }.start();
	}

	    private String loadBuffer() {
	    StringBuffer sb = new StringBuffer();
	    try {
		FileReader fr = new FileReader(new File(SOURCE_DIR + "main.scm"));
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

	@WebServlet(urlPatterns = "/*", name = "MyUIServlet", asyncSupported = true)
	    @VaadinServletConfiguration(ui = MyUI.class, productionMode = false)
	    public static class MyUIServlet extends VaadinServlet {
	    }
    }
