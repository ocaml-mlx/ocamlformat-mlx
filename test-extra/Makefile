######################################################################
#                                                                    #
#                            OCamlFormat                             #
#                                                                    #
#  Copyright (c) 2017-present, Facebook, Inc.  All rights reserved.  #
#                                                                    #
#  This source code is licensed under the MIT license found in the   #
#  LICENSE file in the root directory of this source tree.           #
#                                                                    #
######################################################################

# To test all source files below a directory
#       make DIRS=<directory> test
# By default, test projects used as regression tests
DIRS= \
	code/ocamlformat code/js_of_ocaml code/dune code/irmin \
	code/dune-release code/mirage code/ppxlib code/base

# Extra test directories, for which looser checking is done
XDIRS=code/ocaml code/infer

# Directories to ignore (given to find, compared literally)
PRUNE_DIRS= \
	code/ocamlformat/test code/ocamlformat/vendor/parser-recovery \
	code/ocaml/experimental code/ocaml/testsuite/tests/parse-errors \
	code/dune/test code/dune/vendor code/dune/otherlibs code/dune/example \
	code/infer/sledge/vendor/llvm-dune code/mirage/test

ALL_DIRS=$(DIRS) $(XDIRS)

# To test using the dev or release executable
#       make MODE=<mode>
MODE?=default

code/%:
	@test -d code || mkdir code
	@test -d "$@" || git -C code clone "$(URI)"

code/ocamlformat: URI = ../../../ocamlformat
code/infer: URI = https://github.com/facebook/infer.git
code/js_of_ocaml: URI = https://github.com/ocsigen/js_of_ocaml.git
code/ocaml: URI = https://github.com/ocaml/ocaml.git
code/dune: URI = https://github.com/ocaml/dune.git
code/irmin: URI = https://github.com/mirage/irmin
code/mirage: URI = https://github.com/mirage/mirage
code/dune-release: URI = https://github.com/ocamllabs/dune-release
code/ppxlib: URI = https://github.com/ocaml-ppx/ppxlib
code/base: URI = https://github.com/janestreet/base.git

.PHONY: test_setup
test_setup: $(ALL_DIRS)

.PHONY: test
test: test_setup
	@echo "Running $(OCAMLFORMAT_EXE) with options '$(OCAMLFORMAT)'"
	@$(MAKE) test_inplace
	@-$(MAKE) test_extra

.PHONY: test_status
test_status:
	@for dir in $(ALL_DIRS); do \
	  echo ; echo $$dir; \
	  git -C $$dir status; \
	done

.PHONY: test_diff
test_diff:
	@for dir in $(ALL_DIRS); do \
	  git -C $$dir diff --no-ext-diff; \
	done

.PHONY: test_stage
test_stage:
	@for dir in $(ALL_DIRS); do \
	  git -C $$dir add .; \
	done

.PHONY: test_unstage
test_unstage:
	@for dir in $(ALL_DIRS); do \
	  git -C $$dir reset --quiet HEAD .; \
	done

.PHONY: test_clean
test_clean:
	@for dir in $(ALL_DIRS); do \
	  git -C $$dir checkout --quiet -- .; \
	  git -C $$dir clean --quiet -f; \
	done 2>/dev/null

.PHONY: test_pull
test_pull:
	@for dir in $(ALL_DIRS); do \
	  git -C $$dir pull --quiet; \
	done

FIND_ARGS= \
	-name _build -not -prune -or \
	$(patsubst %,-path % -not -prune -or,$(PRUNE_DIRS)) \
	-name '*.ml' -and -not -name '*.pp.ml' -or \
	-name '*.mli' -and -not -name '*.pp.mli'

.PHONY: test_inplace
test_inplace:
	@find $(DIRS) $(FIND_ARGS) | parallel "$(OCAMLFORMAT_EXE)" --no-version-check --enable-outside-detected-project --quiet -i

.PHONY: test_extra
test_extra:
	@-find $(XDIRS) $(FIND_ARGS) | parallel "$(OCAMLFORMAT_EXE)" --no-version-check --enable-outside-detected-project --quiet -i

.PHONY: test_margins
test_margins:
	@for i in {100..40}; do echo $$i; OCAMLFORMAT_MARGIN=$$i $(MAKE) test || break; done

.PHONY: apply_ocp
apply_ocp:
	@echo "Running ocp-indent with options '$(OCP_INDENT_CONFIG)'"
	@-find $(ALL_DIRS) $(FIND_ARGS) | parallel ocp-indent --config "$(OCP_INDENT_CONFIG)" --inplace

# Number of addition and deletion in each files in a parsable format
.PHONY: test_numstat
test_numstat:
	@for dir in $(ALL_DIRS); do git -C $$dir diff --numstat; done | { \
	tadd=0; tdel=0; \
	while read add del _; do tadd=$$((tadd + add)); tdel=$$((tdel + del)); done; \
	echo "Total: +$$tadd -$$tdel"; }
