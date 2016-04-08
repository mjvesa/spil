Spil
====

A small web app for writing Vaadin UIs in Scheme.  It Provides a bare bones view and  ability to evaluate Scheme scripts either by pressing ctrl-r or when the source files change. Choice of tools for writing code is left for the user.

The Scheme supported by JScheme is R4RS with some limitations.

Technologies used:

    * JVM
    * Vaadin
    * JScheme
	* BiwaScheme

Examples
========

It's possible to implement complete custom widgets using a tiny fraction of the code required when using Java.

A basic label implemented as a custom widget:

```
(define-widget (basic-label text)
  `((client
      (append-to-root (element-new '(div ,text))))))
```

Here's a complete example of a custom widget that features client->server rpc, server->client rpc and shared state. Defining any of those is as easy as defining new functions:

```
(define-macro (modifiable-label text)
  `(let ((component (widget
		     (client
		      (let ((text-div (element-new '(div ,text))))
			(element-append-child! root-element text-div)
			(client-rpc (settext value)
				    (js-set! text-div "innerHTML" value))
			(on-state-change
			 (js-set! text-div "innerHTML"
				  (get-state)))))
		     (server-rpc (testi text)
				 (display (.toString text))))))
     (lambda (op)
       (case op
	 ((component) component)
	 ((settext) (lambda (text) (call-client-rpc component 'settext text)))))))
```

Goals
=====
* See how well Scheme can be used to implement Vaadin applications including theming, markup and client-server communication
* Attempt to strip everything that's not essential from Vaadin and see how small it can get.


Building
========
Run make to make. The makefile needs to be modified to suit
your environment. Also add your source directory to spil.properties before building.

