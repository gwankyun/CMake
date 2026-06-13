function(bad_predicate in out)
  # Deliberately does NOT set ${out}
endfunction()

set(mylist alpha bravo charlie)
list(TRANSFORM mylist TOUPPER PREDICATE bad_predicate)
