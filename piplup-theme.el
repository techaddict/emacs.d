(deftheme piplup
  "Created 2014-12-09.")

(custom-theme-set-variables
 'piplup
 '(blink-cursor-blinks 0)
 '(blink-cursor-delay 10)
 '(cursor-type (quote (bar . 3))))

(custom-theme-set-faces
 'piplup
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 1 :width normal))))
 '(cursor ((t (:background "green")))))

(provide-theme 'piplup)
