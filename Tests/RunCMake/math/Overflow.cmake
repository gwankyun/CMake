foreach(expr IN ITEMS
    "-4 <<   1"
    "-4 >>   1"
    " 4 << -63"
    " 4 >> -63"
    " 4 <<  65"
    " 4 >>  65"
    " 0x7FFFFFFFFFFFFFFF + 1"
    "-0x7FFFFFFFFFFFFFFF - 2"
    " 0x7FFFFFFFFFFFFFFF * 2"
    "-~0x7FFFFFFFFFFFFFFF"
  )
  math(EXPR result "${expr}")
  message(STATUS "${expr}: ${result}")
endforeach()

function(inc_dec command value)
  set(new_value "${value}")
  math("${command}" new_value)
  message(STATUS "${command} ${value}: ${new_value}")
endfunction()

inc_dec(INCREMENT 9223372036854775807)
inc_dec(DECREMENT -9223372036854775808)
