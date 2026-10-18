/* Distributed under the OSI-approved BSD 3-Clause License.
   See accompanying file LICENSE.rst for details.  */

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "llpkgc_dep.h"

#define CALLBACK_MAYBE(PARSER, NAME)                                           \
  do {                                                                         \
    const llpkgc_dep_settings_t* settings;                                     \
    settings =                                                                 \
        (const llpkgc_dep_settings_t*) (PARSER)->llpkgc_dep__settings;         \
    if(settings == NULL || settings->NAME == NULL) {                             \
      err = 0;                                                                 \
      break;                                                                   \
    }                                                                          \
    err = settings->NAME((PARSER));                                            \
  } while(0)

#define SPAN_CALLBACK_MAYBE(PARSER, NAME, START, LEN)                          \
  do {                                                                         \
    const llpkgc_dep_settings_t* settings;                                     \
    settings =                                                                 \
        (const llpkgc_dep_settings_t*) (PARSER)->llpkgc_dep__settings;         \
    if(settings == NULL || settings->NAME == NULL) {                             \
      err = 0;                                                                 \
      break;                                                                   \
    }                                                                          \
    err = settings->NAME((PARSER), (START), (LEN));                            \
    if(err == -1) {                                                            \
      err = PDEP_USER;                                                         \
      llpkgc_dep_set_error_reason((PARSER), "Span callback error in " #NAME);  \
    }                                                                          \
  } while(0)

enum llpkgc_dep_state {
  PDEP_START = 0,
  PDEP_DEP_NAME = 1,
  PDEP_DEP_OP = 2,
  PDEP_AFTER_OP = 3,
  PDEP_DEP_VERSION = 4,
};

void llpkgc_dep_init(llpkgc_dep_t* parser,
    const llpkgc_dep_settings_t* settings) {
  llpkgc_dep__internal_init(parser);
  parser->llpkgc_dep__settings = (void*) settings;
}

void llpkgc_dep_reset(llpkgc_dep_t* parser) {
  llpkgc_dep_settings_t* settings = parser->llpkgc_dep__settings;
  void* data = parser->data;
  llpkgc_dep__internal_init(parser);
  parser->llpkgc_dep__settings = settings;
  parser->data = data;
}

void llpkgc_dep_settings_init(llpkgc_dep_settings_t* settings) {
  memset(settings, 0, sizeof(*settings));
}

llpkgc_dep_errno_t llpkgc_dep_execute(llpkgc_dep_t* parser, const char* data,
    size_t len) {
  return llpkgc_dep__internal_execute(parser, data, data + len);
}

llpkgc_dep_errno_t llpkgc_dep_finish(llpkgc_dep_t* parser) {
  int err = PDEP_OK;

  if(parser->error != 0) {
    return parser->error;
  }

  switch(parser->llpkgc_dep__state) {
    case PDEP_DEP_NAME:
      CALLBACK_MAYBE(parser, on_dep_complete);
      if(err != PDEP_OK) {
        parser->error = err;
        return err;
      }
      break;

    case PDEP_DEP_OP:
    case PDEP_AFTER_OP:
    case PDEP_DEP_VERSION:
      CALLBACK_MAYBE(parser, on_dep_complete);
      if(err != PDEP_OK) {
        parser->error = err;
        return err;
      }
      break;

    case PDEP_START:
      break;
  }

  CALLBACK_MAYBE(parser, on_dep_list_complete);
  if(err != PDEP_OK) {
    parser->error = err;
    return err;
  }

  return PDEP_OK;
}

void llpkgc_dep_pause(llpkgc_dep_t* parser) {
  if(parser->error != PDEP_OK) {
    return;
  }
  parser->error = PDEP_PAUSED;
  parser->reason = "Paused";
}

void llpkgc_dep_resume(llpkgc_dep_t* parser) {
  if(parser->error != PDEP_PAUSED) {
    return;
  }
  parser->error = 0;
}

llpkgc_dep_errno_t llpkgc_dep_get_errno(const llpkgc_dep_t* parser) {
  return parser->error;
}

const char* llpkgc_dep_get_error_reason(const llpkgc_dep_t* parser) {
  return parser->reason;
}

void llpkgc_dep_set_error_reason(llpkgc_dep_t* parser, const char* reason) {
  parser->reason = reason;
}

const char* llpkgc_dep_get_error_pos(const llpkgc_dep_t* parser) {
  return parser->error_pos;
}

const char* llpkgc_dep_errno_name(llpkgc_dep_errno_t err) {
  switch(err) {
    case PDEP_OK:
      return "PDEP_OK";
    case PDEP_INTERNAL:
      return "PDEP_INTERNAL";
    case PDEP_PAUSED:
      return "PDEP_PAUSED";
    case PDEP_USER:
      return "PDEP_USER";
    case PDEP_UNFINISHED:
      return "PDEP_UNFINISHED";
  }
  return "INVALID_ERRNO";
}

int llpkgc_dep__dep_name(llpkgc_dep_t* s, const char* p,
    const char* endp) {
  int err;
  SPAN_CALLBACK_MAYBE(s, on_dep_name, p, endp - p);
  return err;
}

int llpkgc_dep__dep_op(llpkgc_dep_t* s, const char* p,
    const char* endp) {
  int err;
  SPAN_CALLBACK_MAYBE(s, on_dep_op, p, endp - p);
  return err;
}

int llpkgc_dep__dep_version(llpkgc_dep_t* s, const char* p,
    const char* endp) {
  int err;
  SPAN_CALLBACK_MAYBE(s, on_dep_version, p, endp - p);
  return err;
}

int llpkgc_dep__dep_complete(llpkgc_dep_t* s, const char* p,
    const char* endp) {
  int err;
  CALLBACK_MAYBE(s, on_dep_complete);
  return err;
}
