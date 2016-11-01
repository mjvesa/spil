package com.github.mjvesa.spil;

import com.vaadin.shared.JavaScriptExtensionState;
import com.vaadin.shared.ui.JavaScriptComponentState;

public class SchemeExtensionState extends JavaScriptExtensionState {
    private String lst;

    public void setLst(String lst) {
	this.lst = lst;
    }

    public String getLst() {
	return this.lst;
    }
}
