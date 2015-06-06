## Process this file with automake to produce Makefile.in

## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

VERSION=$(PACKAGE_VERSION)
LANG1=fin
LANG2=eng
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=$(PACKAGE_NAME)

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

# currently we copy stuff from another dir
$(PREFIX1).automorf.hfst: $(AP_SRC1)/$(LANG1).automorf.hfst
	cp -v -f $< $@

$(PREFIX1).automorf.bin: $(AP_SRC1)/$(LANG1).automorf.bin
	cp -v -f $< $@

$(PREFIX2).autogen.bin: $(AP_SRC1)/$(LANG1).autogen.bin
	cp -v -f $< $@

$(PREFIX2).autogen.hfst: $(AP_SRC1)/$(LANG1).autogen.hfst
	cp -v -f $< $@

$(PREFIX2).automorf.bin: $(AP_SRC2)/$(LANG2).automorf.bin
	cp -v -f $< $@

$(PREFIX1).autogen.bin: $(AP_SRC2)/$(LANG2).autogen.bin
	cp -v -f $< $@


## Debugging transducers (for testvoc)

.deps/$(LANG2).LR-debug.hfst: $(BASENAME).$(LANG2).lexc .deps/.d
	cat $< | grep -v 'Dir/RL' | grep -v 'Use/Circ' > .deps/$(LANG2).LR-debug.lexc
	hfst-lexc --format foma .deps/$(LANG2).LR-debug.lexc -o .deps/$(LANG2).LR-debug.lexc.hfst
	hfst-compose-intersect -1 .deps/$(LANG2).LR-debug.lexc.hfst -2 .deps/$(LANG2).twol.hfst -o $@

## Bilingual dictionaries

$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $< 
	lt-comp rl $< $@

## Disambiguation rules 

$(PREFIX1).rlx.bin: $(BASENAME).$(PREFIX1).rlx $(CGCOMP)
	$(CGCOMP) $< $@

$(PREFIX2).rlx.bin: $(BASENAME).$(PREFIX2).rlx $(CGCOMP)
	$(CGCOMP) $< $@


## Lexical selection rules

$(PREFIX1).autolex.bin: $(BASENAME).$(PREFIX1).lrx
	lrx-comp $< $@

$(PREFIX2).autolex.bin: $(BASENAME).$(PREFIX2).lrx
	lrx-comp $< $@

## Structural transfer rules

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


## Postgeneration dictionaries

#$(PREFIX1).autopgen.bin: $(BASENAME).post-$(LANG1).dix
#	apertium-validate-dictionary $<
#	lt-comp lr $< $@
#
#$(PREFIX2).autopgen.bin: $(BASENAME).post-$(LANG2).dix
#	apertium-validate-dictionary $< 
#	lt-comp lr $< $@

## Debug

debug: .deps/$(LANG1).LR-debug.hfst .deps/$(LANG2).LR-debug.hfst

## Distribution

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

## Installation

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


# All modes are created by the same goal,
# listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode modes/$(PREFIX2).mode


install-data-local: install-modes

## Testing

%.eng.translated: %.fin.text
	apertium -d . fin-eng < $< > $@

%.fin.translated: %.eng.text
	apertium -d . eng-fin < $< > $@

%.eng.text.src.sgml: %.eng.text
	$(WRAP_XML) src en fi $< | grep -v "<seg id[^>]*></seg>" > $@

%.fin.text.src.sgml: %.fin.text
	$(WRAP_XML) src fi en $< | grep -v "<seg id[^>]*></seg>" > $@

%.fin.text.ref.sgml: %.fin.text
	$(WRAP_XML) ref en fi $< | grep -v "<seg id[^>]*></seg>" > $@

%.eng.text.ref.sgml: %.eng.text
	$(WRAP_XML) ref fi en $< | grep -v "<seg id[^>]*></seg>" > $@

%.fin.translated.test.sgml: %.fin.translated
	tr -d '#@*' < $< | $(WRAP_XML) tst en fi | grep -v "<seg id[^>]*></seg>" > $@

%.eng.translated.test.sgml: %.fin.translated
	tr -d '#@*' < $< | $(WRAP_XML) tst fi en | grep -v "<seg id[^>]*></seg>" > $@

%.fin-eng.nistbleu: %.eng.translated.test.sgml %.fin.text.src.sgml %.eng.text.ref.sgml
	$(NIST_BLEU13A) -s $*.fin.text.src.sgml -r $*.eng.text.ref.sgml -t $*.eng.translated.test.sgml > $@

%.eng-fin.nistbleu: %.fin.translated.test.sgml %.eng.text.src.sgml %.fin.text.ref.sgml
	$(NIST_BLEU13A) -s $*.eng.text.src.sgml -r $*.fin.text.ref.sgml -t $*.fin.translated.test.sgml > $@

## Cleanup

CLEANFILES = $(TARGETS_COMMON)
clean-local: 
	-rm -rf .deps modes
