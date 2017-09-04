package com.github.mjvesa.spil;

import com.vaadin.shared.JavaScriptExtensionState;

public class SchemeExtensionState extends JavaScriptExtensionState {
 	private static final long serialVersionUID = 4549308722540237059L;
	private String lst;

    public void setLst(String lst) {
	this.lst = lst;
    }

    public String getLst() {
	return this.lst;
    }
}
