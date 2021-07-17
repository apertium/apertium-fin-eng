## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, version 3 of the License.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

$(PREFIX1).rlx.bin: $(AP_SRC1)/$(LANG1).rlx.bin
	cp -v $< $@

$(PREFIX2).rlx.bin: $(AP_SRC2)/$(LANG2).rlx.bin
	cp -v $< $@


## Lexical selection rules

$(PREFIX1).autolex.bin: $(BASENAME).$(PREFIX1).lrx
	lrx-comp $< $@

$(PREFIX2).autolex.bin: $(BASENAME).$(PREFIX2).lrx
	lrx-comp $< $@

## Structural transfer rules

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t2x.bin: $(BASENAME).$(PREFIX1).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t3x.bin: $(BASENAME).$(PREFIX1).t3x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t2x.bin: $(BASENAME).$(PREFIX2).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t3x.bin: $(BASENAME).$(PREFIX2).t3x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@


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
		   $(BASENAME).$(PREFIX1).dix \
		   $(BASENAME).$(PREFIX1).t1x \
		   $(BASENAME).$(PREFIX1).t2x \
		   $(BASENAME).$(PREFIX1).t3x \
		   $(BASENAME).$(PREFIX2).t1x \
		   $(BASENAME).$(PREFIX2).t2x \
		   $(BASENAME).$(PREFIX2).t3x \
		   $(BASENAME).$(PREFIX1).lrx \
		   $(BASENAME).$(PREFIX2).lrx \
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


## apevis gh-pages
if CAN_SAXON
LANG1HTML=Finnish
LANG2HTML=English

bidix2html-split.xslt:
	wget https://raw.githubusercontent.com/flammie/apevis-xslt/master/$@

bidix2html.xslt:
	wget https://raw.githubusercontent.com/flammie/apevis-xslt/master/$@

tix2html.xslt:
	wget https://raw.githubusercontent.com/flammie/apevis-xslt/master/$@

dix2stats.xslt:
	wget https://raw.githubusercontent.com/flammie/apevis-xslt/master/$@

docs/$(BASENAME).$(PREFIX1).dix.html: $(BASENAME).$(PREFIX1).dix bidix2html.xslt
	$(SAXON) -s:$< bidix2html.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) > $@

docs/$(BASENAME).$(PREFIX1).dix-a.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=a  > $@

docs/$(BASENAME).$(PREFIX1).dix-b.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=b  > $@

docs/$(BASENAME).$(PREFIX1).dix-c.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=c  > $@

docs/$(BASENAME).$(PREFIX1).dix-d.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=d  > $@

docs/$(BASENAME).$(PREFIX1).dix-e.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=e  > $@

docs/$(BASENAME).$(PREFIX1).dix-f.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=f  > $@

docs/$(BASENAME).$(PREFIX1).dix-g.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=g  > $@

docs/$(BASENAME).$(PREFIX1).dix-h.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=h  > $@

docs/$(BASENAME).$(PREFIX1).dix-i.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=i  > $@

docs/$(BASENAME).$(PREFIX1).dix-j.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=j  > $@

docs/$(BASENAME).$(PREFIX1).dix-k.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=k  > $@

docs/$(BASENAME).$(PREFIX1).dix-l.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=l  > $@

docs/$(BASENAME).$(PREFIX1).dix-m.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=m  > $@

docs/$(BASENAME).$(PREFIX1).dix-n.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=n  > $@

docs/$(BASENAME).$(PREFIX1).dix-o.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=o  > $@

docs/$(BASENAME).$(PREFIX1).dix-p.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=p  > $@

docs/$(BASENAME).$(PREFIX1).dix-q.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=q  > $@

docs/$(BASENAME).$(PREFIX1).dix-r.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=r  > $@

docs/$(BASENAME).$(PREFIX1).dix-s.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=s  > $@

docs/$(BASENAME).$(PREFIX1).dix-t.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=t  > $@

docs/$(BASENAME).$(PREFIX1).dix-u.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=u  > $@

docs/$(BASENAME).$(PREFIX1).dix-v.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=v  > $@

docs/$(BASENAME).$(PREFIX1).dix-w.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=w  > $@

docs/$(BASENAME).$(PREFIX1).dix-x.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=x  > $@

docs/$(BASENAME).$(PREFIX1).dix-y.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=y  > $@

docs/$(BASENAME).$(PREFIX1).dix-z.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=z  > $@

docs/$(BASENAME).$(PREFIX1).dix-ä.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=ä  > $@

docs/$(BASENAME).$(PREFIX1).dix-ö.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=ö  > $@

docs/$(BASENAME).$(PREFIX1).dix-š.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2) letter=š  > $@

docs/$(BASENAME).$(PREFIX2).dix.html: $(BASENAME).$(PREFIX1).dix bidix2html.xslt
	$(SAXON) -s:$< bidix2html.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2)  invert=true > $@

docs/$(BASENAME).$(PREFIX2).dix-a.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=a  > $@

docs/$(BASENAME).$(PREFIX2).dix-b.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=b  > $@

docs/$(BASENAME).$(PREFIX2).dix-c.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=c  > $@

docs/$(BASENAME).$(PREFIX2).dix-d.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=d  > $@

docs/$(BASENAME).$(PREFIX2).dix-e.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=e  > $@

docs/$(BASENAME).$(PREFIX2).dix-f.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=f  > $@

docs/$(BASENAME).$(PREFIX2).dix-g.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=g  > $@

docs/$(BASENAME).$(PREFIX2).dix-h.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=h  > $@

docs/$(BASENAME).$(PREFIX2).dix-i.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=i  > $@

docs/$(BASENAME).$(PREFIX2).dix-j.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=j  > $@

docs/$(BASENAME).$(PREFIX2).dix-k.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=k  > $@

docs/$(BASENAME).$(PREFIX2).dix-l.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=l  > $@

docs/$(BASENAME).$(PREFIX2).dix-m.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=m  > $@

docs/$(BASENAME).$(PREFIX2).dix-n.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=n  > $@

docs/$(BASENAME).$(PREFIX2).dix-o.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=o  > $@

docs/$(BASENAME).$(PREFIX2).dix-p.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=p  > $@

docs/$(BASENAME).$(PREFIX2).dix-q.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=q  > $@

docs/$(BASENAME).$(PREFIX2).dix-r.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=r  > $@

docs/$(BASENAME).$(PREFIX2).dix-s.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=s  > $@

docs/$(BASENAME).$(PREFIX2).dix-t.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=t  > $@

docs/$(BASENAME).$(PREFIX2).dix-u.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=u  > $@

docs/$(BASENAME).$(PREFIX2).dix-v.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=v  > $@

docs/$(BASENAME).$(PREFIX2).dix-w.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=w  > $@

docs/$(BASENAME).$(PREFIX2).dix-x.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=x  > $@

docs/$(BASENAME).$(PREFIX2).dix-y.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=y  > $@

docs/$(BASENAME).$(PREFIX2).dix-z.html: $(BASENAME).$(PREFIX1).dix bidix2html-split.xslt
	$(SAXON) -s:$< bidix2html-split.xslt from=$(LANG2HTML) to=$(LANG1HTML) pair=$(PREFIX1) antipair=$(PREFIX2) invert=true letter=z  > $@

docs/$(BASENAME).$(PREFIX1).t1x.html: $(BASENAME).$(PREFIX1).t1x tix2html.xslt
	$(SAXON) -s:$< tix2html.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2)  > $@

docs/$(BASENAME).$(PREFIX2).t1x.html: $(BASENAME).$(PREFIX2).t1x tix2html.xslt
	$(SAXON) -s:$< tix2html.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2)  > $@



docs/$(BASENAME).$(PREFIX1).t2x.html: $(BASENAME).$(PREFIX1).t2x tix2html.xslt
	$(SAXON) -s:$< tix2html.xslt from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2)  > $@

docs/$(BASENAME).$(PREFIX2).t2x.html: $(BASENAME).$(PREFIX2).t2x tix2html.xslt
	$(SAXON) -s:$< tix2html.xslt  from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2)  > $@

docs/$(BASENAME).$(PREFIX1).t3x.html: $(BASENAME).$(PREFIX1).t3x tix2html.xslt
	$(SAXON) -s:$< tix2html.xslt  from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2)  > $@

docs/$(BASENAME).$(PREFIX2).t3x.html: $(BASENAME).$(PREFIX2).t3x tix2html.xslt
	$(SAXON) -s:$< tix2html.xslt  from=$(LANG1HTML) to=$(LANG2HTML) pair=$(PREFIX1) antipair=$(PREFIX2)  > $@

docs/stats-$(BASENAME).$(PREFIX1).dix.html: $(BASENAME).$(PREFIX1).dix dix2stats.xslt
	$(SAXON) -s:$< dix2stats.xslt > $@

docs/stats-$(BASENAME).$(PREFIX1).t1x.html: $(BASENAME).$(PREFIX1).t1x dix2stats.xslt
	$(SAXON) -s:$< dix2stats.xslt > $@

docs/stats-$(BASENAME).$(PREFIX2).t1x.html: $(BASENAME).$(PREFIX2).t1x dix2stats.xslt
	$(SAXON) -s:$< dix2stats.xslt > $@

docs/stats-$(BASENAME).$(PREFIX1).t2x.html: $(BASENAME).$(PREFIX1).t2x dix2stats.xslt
	$(SAXON) -s:$< dix2stats.xslt > $@

docs/stats-$(BASENAME).$(PREFIX2).t2x.html: $(BASENAME).$(PREFIX2).t2x dix2stats.xslt
	$(SAXON) -s:$< dix2stats.xslt > $@

docs/stats-$(BASENAME).$(PREFIX1).t3x.html: $(BASENAME).$(PREFIX1).t3x dix2stats.xslt
	$(SAXON) -s:$< dix2stats.xslt > $@

docs/stats-$(BASENAME).$(PREFIX2).t3x.html: $(BASENAME).$(PREFIX2).t3x dix2stats.xslt
	$(SAXON) -s:$< dix2stats.xslt > $@

docs/statistics.html: docs/stats-$(BASENAME).$(PREFIX1).dix.html \
				 docs/stats-$(BASENAME).$(PREFIX1).t1x.html \
				 docs/stats-$(BASENAME).$(PREFIX2).t1x.html \
				 docs/stats-$(BASENAME).$(PREFIX1).t2x.html \
				 docs/stats-$(BASENAME).$(PREFIX2).t2x.html \
				 docs/stats-$(BASENAME).$(PREFIX1).t3x.html \
				 docs/stats-$(BASENAME).$(PREFIX2).t3x.html
	$(AWK) '/DOCTYPE/,/<\/h1>/ {print;}' < \
		stats-$(BASENAME).$(PREFIX1).dix.html > $@
	$(AWK) '/<h2>/,/<\/div>/ {print;}' < \
		stats-$(BASENAME).$(PREFIX1).dix.html | fgrep -v '</div>' >> $@
	$(AWK) '/<h2>/,/<\/div>/ {print;}' < \
		stats-$(BASENAME).$(PREFIX1).t1x.html | fgrep -v '</div>' >> $@
	$(AWK) '/<h2>/,/<\/div>/ {print;}' < \
		stats-$(BASENAME).$(PREFIX1).t2x.html | fgrep -v '</div>' >> $@
	$(AWK) '/<h2>/,/<\/div>/ {print;}' < \
		stats-$(BASENAME).$(PREFIX1).t3x.html | fgrep -v '</div>' >> $@
	$(AWK) '/<h2>/,/<\/div>/ {print;}' < \
		stats-$(BASENAME).$(PREFIX2).t1x.html | fgrep -v '</div>' >> $@
	$(AWK) '/<h2>/,/<\/div>/ {print;}' < \
		stats-$(BASENAME).$(PREFIX2).t2x.html | fgrep -v '</div>' >> $@
	$(AWK) '/<h2>/,/<\/div>/ {print;}' < \
		stats-$(BASENAME).$(PREFIX2).t3x.html | fgrep -v '</div>' >> $@
	echo '</div><div class="row">' >> $@
	$(AWK) '/<div id="footer"/,/<\/html/ {print;}' < \
		stats-$(BASENAME).$(PREFIX1).dix.html | fgrep -v '</div>' >> $@

endif

test: all
	apertium-regtest test
