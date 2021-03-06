package com.github.mjvesa.spil;

import com.github.mjvesa.jscm.jscheme.REPL;
import com.github.mjvesa.jscm.jscheme.SchemeProcedure;
import com.github.mjvesa.jscm.jsint.Closure;
import com.github.mjvesa.spil.SchemeComponentState;
import com.vaadin.annotations.JavaScript;
import com.vaadin.ui.AbstractJavaScriptComponent;
import com.vaadin.ui.JavaScriptFunction;
import elemental.json.JsonArray;

@JavaScript({ "scheme_component.js" })
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

	public void registerServerRpc(String name, final Closure target) {
		addFunction(name, new JavaScriptFunction() {
			public void call(JsonArray arguments) {
				((SchemeProcedure) target).apply(REPL.parseScheme(arguments.getString(0)));
			}
		});
	}

	public SchemeComponentState getState() {
		return (SchemeComponentState) super.getState();
	}
}
