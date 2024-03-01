[
 "|"
 ":"
] @punctuation

[
 "{%"
 "%}"
 "{{"
 "}}"
] @comment

(django_empty_comment) @comment
(string) @string
(integer) @number
(float) @float
(true) @boolean
(false) @boolean
(none) @boolean
(identifier) @variable

(attribute object:
    (primary_expression) @variable)

(attribute attribute:
    (identifier) @property)

(tag_statement tag_name:
    (identifier) @function)

(tag_statement tag_argument:
    (keyword_argument keyword_name:
        ((identifier) @parameter)))

(filter filter_name:
    ((identifier) @function))

[
 "for"
 "if"
 "not"
 "in"
 "and"
 "is"
 "as"
 "endfor"
 "endif"
 "else"
 "empty"
 "elif"
] @keyword
