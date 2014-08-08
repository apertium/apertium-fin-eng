###############################################################################
## Makefile for fin-eng
###############################################################################

VERSION=0.1.0
LANG1=fin
LANG2=eng
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

TARGETS_MONOLING=$(PREFIX1).automorf.hfst $(PREFIX1).autogen.bin \
				 $(PREFIX2).automorf.bin $(PREFIX2).autogen.hfst 
TARGETS_TRANSFER=$(PREFIX2).t1x.bin $(PREFIX1).t1x.bin  \
				 $(PREFIX1).autobil.bin $(PREFIX2).autobil.bin \
				 $(PREFIX1).t2x.bin $(PREFIX1).t3x.bin \
				 $(PREFIX2).t2x.bin $(PREFIX2).t3x.bin \
				 $(PREFIX1).rlx.bin $(PREFIX2).rlx.bin \
				 $(PREFIX1).autolex.bin $(PREFIX2).autolex.bin
TARGETS_COMMON=$(TARGETS_MONOLING) $(TARGETS_TRANSFER)

# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@

###############################################################################
## fin transducer
###############################################################################

# currently we copy stuff from another dir
$(PREFIX1).automorf.hfst: $(AP_SRC1)/$(LANG1).automorf.hfst
	cp -v -f $< $@

$(PREFIX1).automorf.bin: $(AP_SRC1)/$(LANG1).automorf.bin
	cp -v -f $< $@

$(PREFIX2).autogen.bin: $(AP_SRC1)/$(LANG1).autogen.bin
	cp -v -f $< $@

$(PREFIX2).autogen.hfst: $(AP_SRC1)/$(LANG1).autogen.hfst
	cp -v -f $< $@

###############################################################################
## eng transducer
###############################################################################

$(PREFIX1).autogen.bin: $(BASENAME).$(LANG2).dix $(BASENAME).$(LANG2).acx
	apertium-validate-dictionary $<
	lt-comp rl $< $@ $(BASENAME).$(LANG2).acx

$(PREFIX2).automorf.bin: $(BASENAME).$(LANG2).dix $(BASENAME).$(LANG2).acx
	apertium-validate-dictionary $<
	lt-comp lr $< $@ $(BASENAME).$(LANG2).acx

###############################################################################
## Debugging transducers (for testvoc)
###############################################################################

.deps/$(LANG2).LR-debug.hfst: $(BASENAME).$(LANG2).lexc .deps/.d
	cat $< | grep -v 'Dir/RL' | grep -v 'Use/Circ' > .deps/$(LANG2).LR-debug.lexc
	hfst-lexc --format foma .deps/$(LANG2).LR-debug.lexc -o .deps/$(LANG2).LR-debug.lexc.hfst
	hfst-compose-intersect -1 .deps/$(LANG2).LR-debug.lexc.hfst -2 .deps/$(LANG2).twol.hfst -o $@

###############################################################################
## Bilingual dictionaries
###############################################################################

$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $< 
	lt-comp rl $< $@

###############################################################################
## Disambiguation rules 
###############################################################################

$(PREFIX1).rlx.bin: $(BASENAME).$(PREFIX1).rlx $(CGCOMP)
	$(CGCOMP) $< $@

$(PREFIX2).rlx.bin: $(BASENAME).$(PREFIX2).rlx $(CGCOMP)
	$(CGCOMP) $< $@


###############################################################################
## Lexical selection rules
###############################################################################

$(PREFIX1).autolex.bin: $(BASENAME).$(PREFIX1).lrx
	lrx-comp $< $@

$(PREFIX2).autolex.bin: $(BASENAME).$(PREFIX2).lrx
	lrx-comp $< $@

###############################################################################
## Structural transfer rules
###############################################################################

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX1).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t1x $@

$(PREFIX1).t2x.bin: $(BASENAME).$(PREFIX1).t2x
	apertium-validate-interchunk $(BASENAME).$(PREFIX1).t2x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t2x $@

$(PREFIX1).t3x.bin: $(BASENAME).$(PREFIX1).t3x
	apertium-validate-postchunk $(BASENAME).$(PREFIX1).t3x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t3x $@

$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX2).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t1x $@

$(PREFIX2).t2x.bin: $(BASENAME).$(PREFIX2).t2x
	apertium-validate-interchunk $(BASENAME).$(PREFIX2).t2x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t2x $@

$(PREFIX2).t3x.bin: $(BASENAME).$(PREFIX2).t3x
	apertium-validate-postchunk $(BASENAME).$(PREFIX2).t3x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t3x $@


###############################################################################
## Postgeneration dictionaries
###############################################################################

#$(PREFIX1).autopgen.bin: $(BASENAME).post-$(LANG1).dix
#	apertium-validate-dictionary $<
#	lt-comp lr $< $@
#
#$(PREFIX2).autopgen.bin: $(BASENAME).post-$(LANG2).dix
#	apertium-validate-dictionary $< 
#	lt-comp lr $< $@

###############################################################################
## Debug
###############################################################################

debug: .deps/$(LANG1).LR-debug.hfst .deps/$(LANG2).LR-debug.hfst

###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=$(PREFIX1).prob $(PREFIX2).prob \
		   $(BASENAME).$(PREFIX1).t1x \
		   $(BASENAME).$(PREFIX1).t2x \
		   $(BASENAME).$(PREFIX1).t3x \
		   $(BASENAME).$(PREFIX2).t1x \
		   $(BASENAME).$(PREFIX2).t2x \
		   $(BASENAME).$(PREFIX2).t3x \
		   $(BASENAME).$(LANG2).dix \
		   $(BASENAME).$(LANG2).acx \
		   modes.xml

###############################################################################
## Installation
###############################################################################

apertium_fin_engdir=$(prefix)/share/apertium/$(BASENAME)/

apertium_fin_eng_DATA=$(TARGETS_COMMON) \
                    $(PREFIX1).prob $(PREFIX2).prob \
	$(BASENAME).$(PREFIX1).t1x \
	$(BASENAME).$(PREFIX2).t1x \
	$(BASENAME).$(PREFIX1).t2x \
	$(BASENAME).$(PREFIX2).t2x \
	$(BASENAME).$(PREFIX1).t3x \
	$(BASENAME).$(PREFIX2).t3x

pkgconfigdir = $(datarootdir)/pkgconfig
pkgconfig_DATA = apertium-fin-eng.pc


# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode modes/$(PREFIX2).mode


install-data-local: install-modes

###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local: 
	-rm -rf .deps modes
