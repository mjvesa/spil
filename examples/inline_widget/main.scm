;;; In-line widget definition example
(load "vaadin.scm")
(define signature '()) ;;; This is a signature as a series of coordinates
(define (create-form)
  (vertical-layout
   (text-field "First name")
   (text-field "Last name")
   (text-field "Address")
    ;;; We need a drawing area for signature, so let's create it here
    (widget
     ((client
       (let* ((mouse-down #f)
              (canvas (element-new '(canvas width "400" height "200")))
              (ctx (js-invoke canvas "getContext" "2d"))
              (set-color (lambda  (color) (js-set! ctx "fillStyle" color)))
              (rect (lambda (x y w h color)
                      (set-color color)
                      (js-invoke ctx "fillRect" x y w h))))
         (append-to-root canvas)
         (rect 0 0 400 200 "gray")
         (console-warn "about to expand some stuff")
         (add-listeners canvas
                        ((mousedown (js-lambda (ev) (set! mouse-down #t)))
                         (mouseup (js-lambda (ev) (set! mouse-down #f)))
                         (mousemove (js-lambda (ev)
                                               (let ((x (js-ref ev "offsetX"))
                                                     (y (js-ref ev "offsetY")))
                                                 (if mouse-down
                                                     (rect x y 10 10 "black")))))))))))))

;;;;;;;;;
;; MAIN
;;;;;;;;;
(define (main ui)
  (.addComponent ui (create-form)))

