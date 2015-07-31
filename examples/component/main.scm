;; Custom component examples
(load "vaadin.scm")

;; Labels are not complex
(define-macro (basic-label text)
  `(widget
    (client
     (append-to-root (element-new '(div ,text))))))

;; Label with client and server RPC, state change listening and API using
;; message passing
(define-macro (modifiable-label text)
  `(let ((component (widget
		     (client
		      (define text-div (element-new '(div ,text)))
		      (element-append-child! root-element text-div)
		      (client-rpc (settext value)
				  (js-set! text-div "innerHTML" value)
				  (call-server 'testi '(test list)))
		      (on-state-change
		       (js-set! text-div "innerHTML"
				(get-state))))
		     (server-rpc (testi text)
				 (display (.toString text))))))
     (lambda (op)
       (case op
	 ((component) component)
	 ((settext) (lambda (text) (call-client-rpc component 'settext text)))))))


;; Drawing canvas with configurable client and server RPCs
;; TODO improve this so that only one rpc is needed
(define-macro (drawing-canvas cli-rpc serv-rpc target-rpc color)
  `(widget
    (client
     (let* ((canvas (element-new '(canvas width "200" height "200")))
	    (ctx (js-invoke canvas "getContext" "2d"))
	    (set-color (lambda  (color) (js-set! ctx "fillStyle" color)))
	    (rect (lambda (x y w h color)
		    (set-color color)
		    (js-invoke ctx "fillRect" x y w h))))
       (element-append-child! root-element canvas)
       (rect 0 0 200 200 "gray")
       (client-rpc ,@cli-rpc)
       (js-invoke canvas "addEventListener" "mousemove"
		  (js-closure
		   (lambda (ev)
		     (let ((x (js-ref ev "offsetX"))
			   (y (js-ref ev "offsetY")))
		       (rect x y 10 10 ,color)
		       (if (not (eq? ,target-rpc '()))
			     (call-server ,target-rpc (list x y)))))))))
    (server-rpc ,@serv-rpc)))

(define main-layout '())

(define (add-label text)
  (.addComponent main-layout (Label. text)))

(define right-canvas
  (drawing-canvas
   ((draw coords) (rect (car coords) (cadr coords) 10 10 "green"))
   ((a b) (display "nothing much"))
   '()
   "red"))

(define left-canvas
  (drawing-canvas
   ((a b) (display "nothing much"))
   ((sendcoords coords) (call-client-rpc right-canvas 'draw (.toString coords)))
   'sendcoords
   "blue"))

(define (main ui)
  (let ((label (modifiable-label "Old text")))
    (set! main-layout ui)
    (.addComponent ui (label 'component))
    ((label 'settext) "\"New text\"")
    (.addComponent ui (Button. "Change state"
   			       (VaadinUtil.buttonClickListener (lambda (event)
   								 (set-widget-state (label 'component) '(whole new state)))))))
  (.addComponent ui (basic-label "<b>This is not modifiable</b>"))

  (let ((hl (HorizontalLayout.)))
    (.setSpacing hl #t)
    (.addComponent hl left-canvas)
    (.addComponent hl right-canvas)
    (.addComponent ui hl)))

