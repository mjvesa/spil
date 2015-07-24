;; Custom component examples
(load "vaadin.scm")

(define-macro (basic-label text)
  `(widget
    (client-init
     (element-append-child! root-element (element-new '(div ,text))))))

(define-macro (modifiable-label text)
  `(let ((component (widget
		     (client-init
		      (define text-div (element-new '(div ,text)))
		      (element-append-child! root-element text-div))
		     (client-rpc set-text
				 (js-set! text-div "innerHTML" "value goes here")))))
     (lambda (op)
       (case op
	 ((component) component)
	 ((set-text) (lambda (x) (call-client component 'set-text)))))))


(define component
  (widget
   (client-init      
     ((define canvas
	(element-new '(canvas)))
      (element-append-child! (js-invoke self "getElement") canvas)
      (define ctx
	(js-invoke canvas "getContext" "2d"))
      (js-set! ctx "fillStyle" "blue")
      (js-invoke ctx "fillRect" 10 10 100 100)))
    (client-rpc poks
		(begin
		  (console-warn "I was called")
		  (js-set! ctx "fillStyle" "green")
		  (js-invoke ctx "fillRect" 10 10 40 30)))))


(define (main ui)
  (let ((label (modifiable-label "whoa dude")))    
    (.addComponent ui (label 'component))
    ((label 'set-text) "stuff")
    (.addComponent ui (basic-label "<b>This is not modifiable</b>"))))

