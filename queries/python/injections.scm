(type
  (string
    (string_content) @injection.content
      (#set! injection.include-children)
      (#set! injection.language "python")))

(type
  (subscript
    (string
      (string_content) @injection.content
        (#set! injection.include-children)
        (#set! injection.language "python"))))

((assignment
  (type
    (identifier) @_type)
  (string
    (string_content) @injection.content
      (#set! injection.include-children)
      (#set! injection.language "python")))
(#eq? @_type "TypeAlias"))

((assignment
  (type
    (string
      (string_content) @_type))
  (string
    (string_content) @injection.content
      (#set! injection.include-children)
      (#set! injection.language "python")))
(#eq? @_type "TypeAlias"))

(class_definition
  (argument_list
    (subscript
      (string
        (string_content) @injection.content
          (#set! injection.include-children)
          (#set! injection.language "python")))))

(((string
    (string_content) @injection.content
      (#set! injection.include-children)
      (#set! injection.language "python")) @_str)
 (#match? @_str "^r.*$"))

((call
  (identifier) @_function
    (argument_list
      (string
        (string_content) @injection.content
          (#set! injection.include-children)
          (#set! injection.language "python"))))
(#any-of? @_function "cast" "NewType" "TypeVar" "TypedDict"))

; Too slow
;((call
;  (identifier) @_function
;    (argument_list
;      (string
;        (string_content) @htmldjango)))
;(#eq? @_function "Template"))
