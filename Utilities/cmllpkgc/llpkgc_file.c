/* Distributed under the OSI-approved BSD 3-Clause License.
   See accompanying file LICENSE.rst for details.  */

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "llpkgc_file.h"

#define CALLBACK_MAYBE(PARSER, NAME)                                           \
  do {                                                                         \
    const llpkgc_file_settings_t* settings;                                    \
    settings =                                                                 \
        (const llpkgc_file_settings_t*) (PARSER)->llpkgc_file__settings;       \
    if(settings == NULL || settings->NAME == NULL) {                           \
      err = 0;                                                                 \
      break;                                                                   \
    }                                                                          \
    err = settings->NAME((PARSER));                                            \
  } while(0)

#define SPAN_CALLBACK_MAYBE(PARSER, NAME, START, LEN)                          \
  do {                                                                         \
    const llpkgc_file_settings_t* settings;                                    \
    settings =                                                                 \
        (const llpkgc_file_settings_t*) (PARSER)->llpkgc_file__settings;       \
    if(settings == NULL || settings->NAME == NULL) {                           \
      err = 0;                                                                 \
      break;                                                                   \
    }                                                                          \
    err = settings->NAME((PARSER), (START), (LEN));                            \
    if(err == -1) {                                                            \
      err = PFCE_USER;                                                         \
      llpkgc_file_set_error_reason((PARSER), "Span callback error in " #NAME); \
    }                                                                          \
  } while(0)

enum llpkgc_file_unfinished_state {
  PFUS_NONE = 0,
  PFUS_IDENT = 1,
  PFUS_BAREWORDS = 2,
  PFUS_EXPECT_VALUE = 3,
  PFUS_VALUE = 4,
  PFUS_VALUE_LITERAL = 5,
  PFUS_VALUE_SUBSTITUTION = 6,
};

void llpkgc_file_init(llpkgc_file_t* parser,
    const llpkgc_file_settings_t* settings) {
  llpkgc_file__internal_init(parser);

  parser->llpkgc_file__settings = (void*) settings;
}

void llpkgc_file_reset(llpkgc_file_t* parser) {
  llpkgc_file_settings_t* settings = parser->llpkgc_file__settings;
  void* data = parser->data;

  llpkgc_file__internal_init(parser);

  parser->llpkgc_file__settings = settings;
  parser->data = data;
}

void llpkgc_file_settings_init(llpkgc_file_settings_t* settings) {
  memset(settings, 0, sizeof(*settings));
}

llpkgc_file_errno_t llpkgc_file_execute(llpkgc_file_t* parser, const char* data,
    size_t len) {
  return llpkgc_file__internal_execute(parser, data, data + len);
}

int llpkgc_file__line_begin(llpkgc_file_t* s, const char* p, const char* endp);
int llpkgc_file__ident_span(llpkgc_file_t* s, const char* p, const char* endp);

llpkgc_file_errno_t llpkgc_file_finish(llpkgc_file_t* parser) {
  int err = PFCE_OK;

  if(parser->error == PFCE_LOOKAHEAD) {
    if(parser->error_pos == NULL) {
      parser->error = PFCE_INTERNAL;
      parser->reason = "Missing lookahead error position";
      return parser->error;
    }

    parser->llpkgc_file__eof = 1;
    llpkgc_file_resume(parser);
    err = llpkgc_file_execute(parser, parser->error_pos, 1);
    parser->llpkgc_file__eof = 0;

    if(err != PFCE_OK) {
      return err;
    }

    parser->llpkgc_file__lookahead = 0;
  } else if(parser->error != 0) {
    return parser->error;
  }

  switch(parser->llpkgc_file__unfinished) {
    case PFUS_IDENT:
    case PFUS_BAREWORDS:
      CALLBACK_MAYBE(parser, on_barewords_complete);
      if(err != PFCE_OK) {
        parser->error = err;
        return err;
      }

      CALLBACK_MAYBE(parser, on_value_complete);
      if(err != PFCE_OK) {
        parser->error = err;
        return err;
      }
      break;

    case PFUS_EXPECT_VALUE:
    case PFUS_VALUE:
      CALLBACK_MAYBE(parser, on_value_complete);
      if(err != PFCE_OK) {
        parser->error = err;
        return err;
      }
      break;

    case PFUS_VALUE_LITERAL:
      CALLBACK_MAYBE(parser, on_value_literal_complete);
      if(err != PFCE_OK) {
        parser->error = err;
        return err;
      }

      CALLBACK_MAYBE(parser, on_value_complete);
      if(err != PFCE_OK) {
        parser->error = err;
        return err;
      }
      break;

    case PFUS_VALUE_SUBSTITUTION:
      parser->reason = "Invalid EOF state";
      parser->error = PFCE_UNFINISHED;
      return PFCE_UNFINISHED;

    case PFUS_NONE:
      break;
  }

  CALLBACK_MAYBE(parser, on_pkgc_complete);
  return err;
}

void llpkgc_file_pause(llpkgc_file_t* parser) {
  if(parser->error != PFCE_OK) {
    return;
  }

  parser->error = PFCE_PAUSED;
  parser->reason = "Paused";
}

void llpkgc_file_resume(llpkgc_file_t* parser) {
  if(parser->error != PFCE_PAUSED && parser->error != PFCE_LOOKAHEAD) {
    return;
  }

  parser->error = 0;
}

llpkgc_file_errno_t llpkgc_file_get_errno(const llpkgc_file_t* parser) {
  return parser->error;
}

const char* llpkgc_file_get_error_reason(const llpkgc_file_t* parser) {
  return parser->reason;
}

void llpkgc_file_set_error_reason(llpkgc_file_t* parser, const char* reason) {
  parser->reason = reason;
}

const char* llpkgc_file_get_error_pos(const llpkgc_file_t* parser) {
  return parser->error_pos;
}

const char* llpkgc_file_errno_name(llpkgc_file_errno_t err) {
  switch(err) {
    case PFCE_OK:
      return "PFCE_OK";
    case PFCE_INTERNAL:
      return "PFCE_INTERNAL";
    case PFCE_PAUSED:
      return "PFCE_PAUSED";
    case PFCE_USER:
      return "PFCE_USER";
    case PFCE_UNFINISHED:
      return "PFCE_UNFINISHED";
    case PFCE_LOOKAHEAD:
      return "PFCE_LOOKAHEAD";
  }
  return "INVALID_ERRNO";
}

int llpkgc_file__lookahead(llpkgc_file_t* s, const char* p, const char* endp) {
  if(p == endp) {
    llpkgc_file_set_error_reason(s, "Invalid lookahead state");
    return PFCE_INTERNAL;
  }

  if(p + 1 == endp) {
    if(s->llpkgc_file__eof != 0) {
      s->llpkgc_file__lookahead = 0;
      return 3;
    }

    s->llpkgc_file__lookahead = (uint8_t) *p;
    return PFCE_LOOKAHEAD;
  }

  s->llpkgc_file__lookahead = 0;

  if(*p != '$') {
    llpkgc_file_set_error_reason(s, "Invalid lookahead state");
    return PFCE_INTERNAL;
  }

  switch(p[1]) {
    case '{':
      return 1;
    case '$':
      return 2;
    default:
      return 0;
  }
}

int llpkgc_file__lookahead_backslash(llpkgc_file_t* s, const char* p,
    const char* endp) {
  if(p == endp) {
    llpkgc_file_set_error_reason(s, "Invalid lookahead state");
    return PFCE_INTERNAL;
  }

  if(p + 1 == endp) {
    if(s->llpkgc_file__eof != 0) {
      s->llpkgc_file__lookahead = 0;
      return 4;
    }

    s->llpkgc_file__lookahead = (uint8_t) *p;
    return 5;
  }

  s->llpkgc_file__lookahead = 0;

  if(*p != '\\') {
    llpkgc_file_set_error_reason(s, "Invalid lookahead state");
    return PFCE_INTERNAL;
  }

  switch(p[1]) {
    case '\r':
    case '\n':
      return 1;
    case '#':
      return 2;
    case '\\':
      return 3;
    default:
      return 0;
  }
}

int llpkgc_file__line_begin(llpkgc_file_t* s, const char* p, const char* endp) {
  int err;
  CALLBACK_MAYBE(s, on_line_begin);
  return err;
}

int llpkgc_file__ident_span(llpkgc_file_t* s, const char* p, const char* endp) {
  int err;
  SPAN_CALLBACK_MAYBE(s, on_ident, p, endp - p);
  return err;
}

int llpkgc_file__prop_decl_complete(llpkgc_file_t* s, const char* p,
    const char* endp) {
  int err;
  CALLBACK_MAYBE(s, on_property_complete);
  return err;
}

int llpkgc_file__var_decl_complete(llpkgc_file_t* s, const char* p,
    const char* endp) {
  int err;
  CALLBACK_MAYBE(s, on_variable_complete);
  return err;
}

int llpkgc_file__barewords_decl_complete(llpkgc_file_t* s, const char* p,
    const char* endp) {
  int err;
  CALLBACK_MAYBE(s, on_barewords_complete);
  return err;
}

int llpkgc_file__lit_span(llpkgc_file_t* s, const char* p, const char* endp) {
  int err;
  SPAN_CALLBACK_MAYBE(s, on_value_literal, p, endp - p);
  return err;
}

int llpkgc_file__lit_complete(llpkgc_file_t* s, const char* p,
    const char* endp) {
  int err;
  CALLBACK_MAYBE(s, on_value_literal_complete);
  return err;
}

int llpkgc_file__sub_span(llpkgc_file_t* s, const char* p, const char* endp) {
  int err;
  SPAN_CALLBACK_MAYBE(s, on_value_substitution, p, endp - p);
  return err;
}

int llpkgc_file__sub_complete(llpkgc_file_t* s, const char* p,
    const char* endp) {
  int err;
  CALLBACK_MAYBE(s, on_value_substitution_complete);
  return err;
}

int llpkgc_file__val_complete(llpkgc_file_t* s, const char* p,
    const char* endp) {
  int err;
  CALLBACK_MAYBE(s, on_value_complete);
  return err;
}
