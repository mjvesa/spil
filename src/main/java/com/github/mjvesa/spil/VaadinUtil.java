package com.github.mjvesa.spil;

import com.github.mjvesa.jscm.jsint.Pair;
import com.github.mjvesa.jscm.jsint.Procedure;
import com.vaadin.ui.Button;

public class VaadinUtil {

	public static Button.ClickListener buttonClickListener(final Procedure proc) {
		return new Button.ClickListener() {
			@Override
			public void buttonClick(Button.ClickEvent event) {
				proc.apply(new Pair(event, null));
			}	
		};
	}
}
