function(bad_predicate in out)
  # Deliberately does NOT set ${out}
endfunction()

set(mylist alpha bravo charlie)
list(FILTER mylist INCLUDE PREDICATE bad_predicate)
