package com.github.mjvesa.spil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;

import org.jsoup.nodes.Element;

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
import com.vaadin.server.BootstrapFragmentResponse;
import com.vaadin.server.BootstrapListener;
import com.vaadin.server.BootstrapPageResponse;
import com.vaadin.server.Page;
import com.vaadin.server.SessionInitEvent;
import com.vaadin.server.SessionInitListener;
import com.vaadin.server.VaadinRequest;
import com.vaadin.server.VaadinServlet;
import com.vaadin.ui.VerticalLayout;
import com.vaadin.ui.Button;
import com.vaadin.ui.Button.ClickListener;
import com.vaadin.ui.themes.ValoTheme;
import com.vaadin.ui.UI;
import com.vaadin.event.ShortcutAction.KeyCode;
import com.vaadin.event.ShortcutAction.ModifierKey;
import com.github.mjvesa.jscm.jscheme.JScheme;
import com.github.mjvesa.spil.WatchDir;
import com.github.mjvesa.spil.WatchDir.FileChangeCallback;

@Push
@Theme("base")
@Widgetset("com.github.mjvesa.spil.SpilWidgetset")
public class SpilUI extends UI {

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
		Button eval = new Button("Eval", new ClickListener() {
			public void buttonClick(Button.ClickEvent event) {
				outputLayout.removeAllComponents();
				final JScheme js = new JScheme();
				js.eval("(begin " + loadBuffer() + ")");
				js.call("main", outputLayout);
			}
		});
		evalButton = eval;
		eval.setClickShortcut(KeyCode.E, ModifierKey.CTRL);
		VerticalLayout mainLayout = new VerticalLayout(outputLayout, eval);
		mainLayout.setSizeFull();
		mainLayout.setExpandRatio(outputLayout, 1);
		setContent(mainLayout);

		new Thread() {
			public void run() {
				try {
					new WatchDir(FileSystems.getDefault().getPath(sourceDir), true, new FileChangeCallback() {
						public void fileChange() {
							SpilUI.this.access(new Runnable() {
								public void run() {
									evalButton.click();
								}
							});
						}
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
			FileReader fr = new FileReader(new File(sourceDir + "main.scm"));
			char[] chars = new char[100];
			while (fr.ready()) {
				int count = fr.read(chars);
				sb.append(chars, 0, count);
			}
			fr.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return sb.toString();
	}

	private void loadProps() {
		try {
			URL propsURL = getClass().getResource("spil.properties");
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

	public static SpilUI getCurrent() {
		return (SpilUI) UI.getCurrent();
	}

	@WebServlet(urlPatterns = "/*", name = "SpilUIServlet", asyncSupported = true)
	@VaadinServletConfiguration(ui = SpilUI.class, productionMode = false)
	public static class SpilUIServlet extends VaadinServlet {

		@Override
		protected void servletInitialized() throws ServletException {
			super.servletInitialized();
			getService().addSessionInitListener(new SessionInitListener() {

				public void sessionInit(SessionInitEvent event) {
					event.getSession().addBootstrapListener(biwaschemeInjector);
				}
			});
		}
	}

	public static void evalScheme(String code) {
		String sanitizedCode = code.replace("'", "\\'");
		Page.getCurrent().getJavaScript()
				.execute(" var biwascheme = new BiwaScheme.Interpreter(function(e) { console.error(e.message); });"
						+ "biwascheme.evaluate('" + sanitizedCode + "');");
	}

	public static BootstrapListener biwaschemeInjector = new BootstrapListener() {

		@Override
		public void modifyBootstrapPage(BootstrapPageResponse response) {
			Element head = response.getDocument().getElementsByTag("head").get(0);
			Element polymer = response.getDocument().createElement("script");
			polymer.attr("src", "VAADIN/js/biwascheme.js");
			head.appendChild(polymer);
		}

		@Override
		public void modifyBootstrapFragment(BootstrapFragmentResponse response) {

		}
	};
}
