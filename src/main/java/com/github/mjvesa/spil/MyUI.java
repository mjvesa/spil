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
import com.vaadin.ui.UI;
import com.vaadin.event.ShortcutAction.KeyCode;
import com.vaadin.event.ShortcutAction.ModifierKey;
import jscheme.JScheme;


@Theme("base")
@Widgetset("com.vaadin.DefaultWidgetSet")
public class MyUI extends UI {

    private final String SOURCE_FILE = "/home/yobi/main.scm";

    @Override
    protected void init(VaadinRequest vaadinRequest) {
        final VerticalLayout layout = new VerticalLayout();
        layout.setMargin(true);
        layout.setSizeFull();

        final VerticalLayout outputLayout = new VerticalLayout();
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
        setContent(mainLayout);
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
