; inherits: html


;[
; "<"
; "/>"
; ">"
; "</"
;] @punctuation.bracket
;] @constant

(doctype) @comment

((attribute_name) @parameter
  (#lua-match? @parameter "^up[-]%l+$"))

((attribute_name) @parameter
  (#lua-match? @parameter "^x[-]%l+$"))

((attribute_name) @parameter
  (#lua-match? @parameter "^[@:]%l+.-$"))

; colors regular variables in strings with tokyonight theme
((attribute
   (attribute_name) @_alpine
   (quoted_attribute_value (attribute_value) @operator))
 (#lua-match? @_alpine "^[@:]%l+.-$"))

((attribute
   (attribute_name) @_alpine
   (quoted_attribute_value (attribute_value) @operator))
 (#lua-match? @_alpine "^x[-]%l+$"))
