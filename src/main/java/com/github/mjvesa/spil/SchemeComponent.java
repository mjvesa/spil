package com.github.mjvesa.spil;

import com.vaadin.annotations.JavaScript;
import com.vaadin.ui.AbstractJavaScriptComponent;
    
@JavaScript({"biwascheme-0.6.2.js", "scheme_component.js"})
public class SchemeComponent extends AbstractJavaScriptComponent {

    public SchemeComponent() {
    }

    public void setComponentCode(String src) {
	callFunction("setComponentCode", src);
    }

    public void callClient(String func, Object...args) {
	callFunction(func, args);
    }
	
    public void callClient(String func) {
	callFunction(func);
    }
	
}

