com_github_mjvesa_spil_SchemeComponent = function() {

    var biwascheme = new BiwaScheme.Interpreter(function(e) { console.log(e.message); })

    this.onStateChange = function() {
    }


    this.setComponentCode = function(code) {
	// This is a horrible hack to access this from Scheme
	com_github_mjvesa_spil_SchemeComponent.self = this;
	biwascheme.evaluate(code);
    }
}
