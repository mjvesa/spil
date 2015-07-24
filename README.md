Spil
====

A small web app for writing Vaadin UIs in Scheme.  It Provides a bare bones view and  ability to evaluate Scheme scripts either by pressing ctrl-r or when the source files change. Choice of tools for writing code is left for the user.

The Scheme supported by JScheme is R4RS with some limitations.

Technologies used:

    * JVM
    * Vaadin
    * JScheme
	* BiwaScheme

Goals
=====
* See how well Scheme can be used to implement Vaadin applications including theming, markup and client-server communication
* Attempt to strip everything that's not essential from Vaadin and see how small it can get.


Building
========
Run make to make. The makefile needs to be modified to suit
your environment. Also add your source directory to spil.properties before building.

