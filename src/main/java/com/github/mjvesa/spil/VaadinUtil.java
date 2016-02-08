package com.github.mjvesa.spil;

import com.vaadin.ui.Button;
import jsint.Pair;
import jsint.Procedure;

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
