package com.github.mjvesa.spil;

import com.vaadin.shared.ui.JavaScriptComponentState;

public class SchemeComponentState extends JavaScriptComponentState {
    private String list;

    public void setLst(String list) {
	this.list = list;
    }

    public String getLst() {
	return this.list;
    }
}
