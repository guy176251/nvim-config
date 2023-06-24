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
