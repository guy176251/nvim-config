; inherits: html

(attribute_name) @keyword

[
 "<"
 ">"
 "</"
 "/>"
] @punctuation.bracket

(doctype) @comment

((tag_name) @type (#match? @type "^(head|body)$"))

((tag_name) @comment (#eq? @comment "html"))

(element
  (start_tag
    ((tag_name) @function)
    (attribute (attribute_name) @_alpine))
  (#lua-match? @_alpine "^[@:]%l+.-$"))

(element
  (start_tag
    (attribute (attribute_name) @_alpine))
  (end_tag ((tag_name) @function))
  (#lua-match? @_alpine "^[@:]%l+.-$"))

(element
  (start_tag
    ((tag_name) @function)
    (attribute (attribute_name) @_alpine))
  (#lua-match? @_alpine "^x[-]%l+$"))

(element
  (start_tag
    (attribute (attribute_name) @_alpine))
  (end_tag ((tag_name) @function))
  (#lua-match? @_alpine "^x[-]%l+$"))

(element
  (self_closing_tag
    ((tag_name) @function)
    (attribute (attribute_name) @_alpine))
  (#lua-match? @_alpine "^[@:]%l+.-$"))

(element
  (self_closing_tag
    ((tag_name) @function)
    (attribute (attribute_name) @_alpine))
  (#lua-match? @_alpine "^x[-]%l+$"))

(element (start_tag ((tag_name) @function) (#eq? @function "template")))
(element (end_tag ((tag_name) @function) (#eq? @function "template")))
