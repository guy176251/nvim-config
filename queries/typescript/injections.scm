; angular inline templates
((decorator
   (call_expression
     (identifier) @_decorator
     (arguments
       (object
         (pair
           (property_identifier) @_key
           (template_string) @html)))))
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
               (string_fragment) @css)))))))
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
             (template_string) @css))))))
 (#eq? @_decorator "Component") (#eq? @_key "styles"))
