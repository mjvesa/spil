Spil
====

A small web app for writing Vaadin UIs in Scheme.  It Provides a simple view and  ability to evaluate Scheme
scripts either initiated by the user or when the source files change. The Scheme supported by JScheme is R4RS with some
limitations.

Technologies used:

    * JVM
    * Vaadin
    * JScheme


Workflow
========

Run make to make. The makefile needs to be modified to suit
your environment. Also add your source directory to spil.properties before building.

Purpose
=======
See how well Scheme can be used to implement Vaadin applications. Attempt to
strip everything that's not essential from Vaadin and see how small it can get.
