package com.github.mjvesa.spil;

import com.vaadin.shared.ui.JavaScriptComponentState;

public class SchemeComponentState extends JavaScriptComponentState {
    private String lst;

    public void setLst(String lst) {
	this.lst = lst;
    }

    public String getLst() {
	return this.lst;
    }
}
