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

((text) @python (#lua-match? @python "^{%p%s+%l+%s+.-%s+%p}$"))

((text) @python (#lua-match? @python "^{{%s+.-%s+}}$"))

((attribute
   (attribute_name) @_hyperscript
   (quoted_attribute_value (attribute_value) @python))
 (#eq? @_hyperscript "_"))
