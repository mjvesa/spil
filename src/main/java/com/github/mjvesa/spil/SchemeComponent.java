package com.github.mjvesa.spil;

import com.vaadin.annotations.JavaScript;
import com.vaadin.ui.AbstractJavaScriptComponent;
import com.vaadin.ui.JavaScriptFunction;
import elemental.json.JsonArray;
import jscheme.SchemeProcedure;
import jscheme.REPL;
import jsint.Pair;
import jsint.Closure;

@JavaScript({"biwascheme-0.6.2.js", "scheme_component.js"})
public class SchemeComponent extends AbstractJavaScriptComponent {

    public SchemeComponent() {
    }

    public void setComponentCode(String src) {
	callFunction("setComponentCode", src);
    }

    public void callClient(String func, String args) {
	callFunction(func, args);
    }
	
    public void callClient(String func) {
	callFunction(func);
    }

    public void registerServerRpc(String name, Closure target) {
	addFunction(name, new JavaScriptFunction() {
		public void call(JsonArray arguments) {
		    ((SchemeProcedure)target).apply(REPL.parseScheme(arguments.getString(0)));
		}});
    }
}

