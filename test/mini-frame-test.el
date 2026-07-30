;;; mini-frame-test.el --- Tests for mini-frame -*- lexical-binding: t -*-

(require 'ert)
(load (expand-file-name "../mini-frame.el"
                        (file-name-directory load-file-name))
      nil nil t)

(ert-deftest mini-frame-grow-only-preserves-pixel-height ()
  (let ((mini-frame-resize 'grow-only)
        (mini-frame-resize-min-height nil)
        (mini-frame-resize-max-height nil)
        (mini-frame-completions-frame nil)
        min-height)
    (cl-letf (((symbol-function 'frame-root-window)
               (lambda (_frame) 'window))
              ((symbol-function 'frame-parameter)
               (lambda (_frame _parameter) 10))
              ((symbol-function 'window-body-height)
               (lambda (_window pixelwise)
                 (should pixelwise)
                 45))
              ((symbol-function 'window-default-line-height)
               (lambda (_window) 20))
              ((symbol-function 'window-body-width)
               (lambda (&optional _window _pixelwise) 80))
              ((symbol-function 'frame-live-p)
               (lambda (_frame) nil)))
      (let ((mini-frame--fit-frame-function
             (lambda (_frame _max-height height &rest _args)
               (setq min-height height))))
        (mini-frame--resize-mini-frame 'frame)))
    (should (= min-height 2.25))))

;;; mini-frame-test.el ends here
