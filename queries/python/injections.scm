(type (string (string_content) @python))

(type (subscript (string (string_content) @python)))

((assignment
  (type (identifier) @_type)
  (string (string_content) @python))
(#eq? @_type "TypeAlias"))

((assignment
  (type (string (string_content) @_type))
  (string (string_content) @python))
(#eq? @_type "TypeAlias"))

(class_definition
  (argument_list
    (subscript
      (string
        (string_content) @python))))

(((string (string_content) @python) @_str)
 (#match? @_str "^r.*$"))

((call
  (identifier) @_function
    (argument_list
      (string
        (string_content) @python)))
(#any-of? @_function "cast" "NewType" "TypeVar" "TypedDict"))

; Too slow
;((call
;  (identifier) @_function
;    (argument_list
;      (string
;        (string_content) @htmldjango)))
;(#eq? @_function "Template"))
