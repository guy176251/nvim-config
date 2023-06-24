((attribute
   (attribute_name) @_alpine
   (quoted_attribute_value
     (attribute_value) @javascript))
 (#lua-match? @_alpine "^[@:]%l+.-$"))

((attribute
   (attribute_name) @_alpine
   (quoted_attribute_value
     (attribute_value) @javascript))
 (#lua-match? @_alpine "^x[-]%l+$"))

(script_element
  (raw_text) @javascript)
