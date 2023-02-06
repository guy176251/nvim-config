((attribute
   (attribute_name) @_alpine
   (quoted_attribute_value (attribute_value) @javascript))
 (#lua-match? @_alpine "^[@:]%l+.-$"))

((attribute
   (attribute_name) @_alpine
   (quoted_attribute_value (attribute_value) @javascript))
 (#lua-match? @_alpine "^x[-]%l+$"))

(script_element
  (raw_text) @javascript)

;((text) @htmldjango (#lua-match? @htmldjango "^{%p%s+%l+.-%s+%p}$"))
;
;((text) @htmldjango (#lua-match? @htmldjango "^{{%s+.-%s+}}$"))
;
;((attribute
;   (quoted_attribute_value (attribute_value) @htmldjango))
; (#lua-match? @htmldjango "^{{%s+.-%s+}}$"))

