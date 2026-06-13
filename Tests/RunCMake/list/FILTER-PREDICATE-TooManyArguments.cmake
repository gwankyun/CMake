function(my_predicate in out)
  set(${out} TRUE PARENT_SCOPE)
endfunction()

set(mylist alpha bravo charlie)
list(FILTER mylist INCLUDE PREDICATE my_predicate extra_arg)
