/* Distributed under the OSI-approved BSD 3-Clause License.
   See accompanying file LICENSE.rst for details.  */

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "llpkgc_frag.h"

#define CALLBACK_MAYBE(PARSER, NAME)                                           \
  do {                                                                         \
    const llpkgc_frag_settings_t* settings;                                    \
    settings =                                                                 \
        (const llpkgc_frag_settings_t*) (PARSER)->llpkgc_frag__settings;       \
    if(settings == NULL || settings->NAME == NULL) {                           \
      err = 0;                                                                 \
      break;                                                                   \
    }                                                                          \
    err = settings->NAME((PARSER));                                            \
  } while(0)

#define SPAN_CALLBACK_MAYBE(PARSER, NAME, START, LEN)                          \
  do {                                                                         \
    const llpkgc_frag_settings_t* settings;                                    \
    settings =                                                                 \
        (const llpkgc_frag_settings_t*) (PARSER)->llpkgc_frag__settings;       \
    if(settings == NULL || settings->NAME == NULL) {                           \
      err = 0;                                                                 \
      break;                                                                   \
    }                                                                          \
    err = settings->NAME((PARSER), (START), (LEN));                            \
    if(err == -1) {                                                            \
      err = PFFE_USER;                                                         \
      llpkgc_frag_set_error_reason((PARSER), "Span callback error in " #NAME); \
    }                                                                          \
  } while(0)

enum llpkgc_frag_state {
  PFFS_START = 0,
  PFFS_UNQUOTED = 1,
  PFFS_DOUBLE_QUOTED = 2,
  PFFS_SINGLE_QUOTED = 3,
};

void llpkgc_frag_init(llpkgc_frag_t* parser,
    const llpkgc_frag_settings_t* settings) {
  llpkgc_frag__internal_init(parser);
  parser->llpkgc_frag__settings = (void*) settings;
}

void llpkgc_frag_reset(llpkgc_frag_t* parser) {
  llpkgc_frag_settings_t* settings = parser->llpkgc_frag__settings;
  void* data = parser->data;
  llpkgc_frag__internal_init(parser);
  parser->llpkgc_frag__settings = settings;
  parser->data = data;
}

void llpkgc_frag_settings_init(llpkgc_frag_settings_t* settings) {
  memset(settings, 0, sizeof(*settings));
}

llpkgc_frag_errno_t llpkgc_frag_execute(llpkgc_frag_t* parser, const char* data,
    size_t len) {
  return llpkgc_frag__internal_execute(parser, data, data + len);
}

llpkgc_frag_errno_t llpkgc_frag_finish(llpkgc_frag_t* parser) {
  int err = PFFE_OK;

  if(parser->error == PFFE_LOOKAHEAD) {
    if(parser->error_pos == NULL) {
      parser->error = PFFE_INTERNAL;
      parser->reason = "Missing lookahead error position";
      return parser->error;
    }

    parser->llpkgc_frag__eof = 1;
    llpkgc_frag_resume(parser);
    err = llpkgc_frag_execute(parser, parser->error_pos, 1);
    parser->llpkgc_frag__eof = 0;

    if(err != PFFE_OK) {
      return err;
    }

    parser->llpkgc_frag__lookahead = 0;
  } else if(parser->error != 0) {
    return parser->error;
  }

  switch(parser->llpkgc_frag__state) {
    case PFFS_UNQUOTED:
      CALLBACK_MAYBE(parser, on_frag_complete);
      if(err != PFFE_OK) {
        parser->error = err;
        return err;
      }
      break;

    case PFFS_DOUBLE_QUOTED:
    case PFFS_SINGLE_QUOTED:
      parser->reason = "Unterminated quote at end of input";
      parser->error = PFFE_UNFINISHED;
      return PFFE_UNFINISHED;

    case PFFS_START:
      break;
  }

  CALLBACK_MAYBE(parser, on_fraglist_complete);
  if(err != PFFE_OK) {
    parser->error = err;
    return err;
  }

  return PFFE_OK;
}

void llpkgc_frag_pause(llpkgc_frag_t* parser) {
  if(parser->error != PFFE_OK) {
    return;
  }
  parser->error = PFFE_PAUSED;
  parser->reason = "Paused";
}

void llpkgc_frag_resume(llpkgc_frag_t* parser) {
  if(parser->error != PFFE_PAUSED && parser->error != PFFE_LOOKAHEAD) {
    return;
  }
  parser->error = 0;
}

llpkgc_frag_errno_t llpkgc_frag_get_errno(const llpkgc_frag_t* parser) {
  return parser->error;
}

const char* llpkgc_frag_get_error_reason(const llpkgc_frag_t* parser) {
  return parser->reason;
}

void llpkgc_frag_set_error_reason(llpkgc_frag_t* parser, const char* reason) {
  parser->reason = reason;
}

const char* llpkgc_frag_get_error_pos(const llpkgc_frag_t* parser) {
  return parser->error_pos;
}

const char* llpkgc_frag_errno_name(llpkgc_frag_errno_t err) {
  switch(err) {
    case PFFE_OK:
      return "PFFE_OK";
    case PFFE_INTERNAL:
      return "PFFE_INTERNAL";
    case PFFE_PAUSED:
      return "PFFE_PAUSED";
    case PFFE_USER:
      return "PFFE_USER";
    case PFFE_UNFINISHED:
      return "PFFE_UNFINISHED";
    case PFFE_LOOKAHEAD:
      return "PFFE_LOOKAHEAD";
  }
  return "INVALID_ERRNO";
}

int llpkgc_frag__lookahead_dq_backslash(llpkgc_frag_t* s, const char* p,
    const char* endp) {
  if(p == endp) {
    llpkgc_frag_set_error_reason(s, "Invalid lookahead state");
    return PFFE_INTERNAL;
  }

  if(p + 1 == endp) {
    if(s->llpkgc_frag__eof != 0) {
      s->llpkgc_frag__lookahead = 0;
      return 1;
    }
    s->llpkgc_frag__lookahead = (uint8_t) *p;
    return PFFE_LOOKAHEAD;
  }

  s->llpkgc_frag__lookahead = 0;

  if(*p != '\\') {
    llpkgc_frag_set_error_reason(s, "Invalid lookahead state");
    return PFFE_INTERNAL;
  }

  switch(p[1]) {
    case '$':
    case '`':
    case '"':
    case '\\':
      return 0;
    default:
      return 1;
  }
}

int llpkgc_frag__fragment_text(llpkgc_frag_t* s, const char* p,
    const char* endp) {
  int err;
  SPAN_CALLBACK_MAYBE(s, on_fragment_text, p, endp - p);
  return err;
}

int llpkgc_frag__frag_complete(llpkgc_frag_t* s, const char* p,
    const char* endp) {
  int err;
  CALLBACK_MAYBE(s, on_frag_complete);
  return err;
}
