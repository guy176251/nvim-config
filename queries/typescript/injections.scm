; angular inline templates
((decorator
   (call_expression
     (identifier) @_decorator
     (arguments
       (object
         (pair
           (property_identifier) @_key
           (template_string) @injection.content
             (#set! injection.include-children)
             (#set! injection.language "html"))))))
 (#eq? @_decorator "Component") (#eq? @_key "template"))

; angular inline styles
((decorator
   (call_expression
     (identifier) @_decorator
     (arguments
       (object
         (pair
           (property_identifier) @_key
           (array
             (string
               (string_fragment) @injection.content
                 (#set! injection.include-children)
                 (#set! injection.language "css"))))))))
 (#eq? @_decorator "Component") (#eq? @_key "styles"))

; angular inline styles "template string"
((decorator
   (call_expression
     (identifier) @_decorator
     (arguments
       (object
         (pair
           (property_identifier) @_key
           (array
             (template_string) @injection.content
               (#set! injection.include-children)
               (#set! injection.language "css")))))))
 (#eq? @_decorator "Component") (#eq? @_key "styles"))
