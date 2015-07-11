package com.github.mjvesa.spil;

import javax.servlet.annotation.WebServlet;

import java.lang.StringBuffer;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.FileReader;
import com.vaadin.annotations.Theme;
import com.vaadin.annotations.VaadinServletConfiguration;
import com.vaadin.annotations.Widgetset;
import com.vaadin.server.VaadinRequest;
import com.vaadin.server.VaadinServlet;
import com.vaadin.ui.VerticalLayout;
import com.vaadin.ui.Button;
import com.vaadin.ui.TextArea;
import com.vaadin.ui.HorizontalSplitPanel;
import com.vaadin.ui.UI;
import com.vaadin.event.ShortcutAction.KeyCode;
import com.vaadin.event.ShortcutAction.ModifierKey;
import jscheme.JScheme;


@Theme("base")
@Widgetset("com.vaadin.DefaultWidgetSet")
public class MyUI extends UI {
	
	private final String SOURCE_FILE = "/home/mjvesa/sorsat.scm";

    @Override
    protected void init(VaadinRequest vaadinRequest) {
		HorizontalSplitPanel hsp = new HorizontalSplitPanel();
		hsp.setSizeFull();		
        final VerticalLayout layout = new VerticalLayout();
        layout.setMargin(true);
        layout.setSizeFull();
        final TextArea ta = new TextArea();
        ta.setSizeFull();
        ta.setImmediate(true);
        ta.setValue(loadBuffer());
        layout.addComponent(ta);
        layout.setExpandRatio(ta, 1);       
        final VerticalLayout outputLayout = new VerticalLayout();
        Button eval = new Button("Eval", event -> {
			saveBuffer(ta.getValue());
			outputLayout.removeAllComponents();
			final JScheme js = new JScheme();
			System.out.println("Here we go!");
			System.out.println(ta.getValue());
			System.out.println(js.eval("(begin " + ta.getValue() + ")"));
			js.call("main", outputLayout);
		});
		eval.setClickShortcut(KeyCode.R, ModifierKey.CTRL);
		VerticalLayout mainLayout = 
        new VerticalLayout(hsp, eval);
		mainLayout.setSizeFull();
		mainLayout.setExpandRatio(hsp, 1);
		setContent(mainLayout);
        hsp.setFirstComponent(layout);
        hsp.setSecondComponent(outputLayout);
    }
    
    private void saveBuffer(String buffer) {
		try {
            File file = new File(SOURCE_FILE);
            file.createNewFile();
            FileWriter fw = new FileWriter(file);
            fw.write(buffer);
            fw.flush();
            fw.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
	}
	
	private String loadBuffer() {
		
		StringBuffer sb = new StringBuffer();
		try {
			FileReader fr = new FileReader(new File(SOURCE_FILE));
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
