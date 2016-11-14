package com.github.mjvesa.spil;

import com.github.mjvesa.jscm.jscheme.REPL;
import com.github.mjvesa.jscm.jscheme.SchemeProcedure;
import com.github.mjvesa.jscm.jsint.Closure;
import com.vaadin.annotations.JavaScript;
import com.vaadin.server.AbstractClientConnector;
import com.vaadin.server.AbstractJavaScriptExtension;
import com.vaadin.ui.JavaScriptFunction;

import elemental.json.JsonArray;

@JavaScript({"scheme_extension.js"})
public class SchemeExtension extends AbstractJavaScriptExtension {

    /**
	 * 
	 */
	private static final long serialVersionUID = 6460066739624418939L;


	public SchemeExtension() {
    }
	
	public void extendTarget(AbstractClientConnector target) {
		extend(target);
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
		    ((SchemeProcedure)target).apply(REPL.parseScheme(arguments.getString(0)));
		}});
    }


    public SchemeExtensionState getState() {
	return (SchemeExtensionState)super.getState();
    }
}

