.phony: pbindex

PUBDIR:=publish
FRAGDIR:=$(PUBDIR)/fragments
STATICSDIR:=statics
INDEX_YAML:=index.yaml
PBINDEX_YAML:=$(FRAGDIR)/pbindex.yaml
PBINDEX_PAGE:=$(FRAGDIR)/pbindex.html
INDEX_TEMPLATE:=panbook.template
INDEX_PAGE:=$(PUBDIR)/index.html
SRCMD:=$(wildcard *.md */*.md */*/*.md */*/*/*.md */*/*/*/*.md)
SRCMD:=$(filter-out $(PUBDIR)/%, $(SRCMD))
SRCMD:=$(filter-out $(STATICSDIR)/%, $(SRCMD))
DSTMD:=$(addprefix $(PUBDIR)/, $(SRCMD))
HTMLS:=$(DSTMD:%.md=%.html)
FRAGS:=$(addprefix $(FRAGDIR)/, $(SRCMD))
FRAGS:=$(FRAGS:%.md=%.html)
HTMLS:=$(filter-out $(INDEX_PAGE), $(HTMLS))
STATICS:=$(wildcard $(STATICSDIR)/*.* $(STATICSDIR)/*/*.* $(STATICSDIR)/*/*/*.* $(STATICSDIR)/*/*/*/*.*)
PUBSTATICS:=$(STATICS:$(STATICSDIR)/%=$(PUBDIR)/%)
SRCHTMLS:=$(wildcard *.html)
DSTHTMLS:=$(addprefix $(PUBDIR)/, $(SRCHTMLS))

PANDOC_OPTIONS:= --ascii -f markdown+east_asian_line_breaks+emoji+abbreviations 

all: $(DSTMD) $(HTMLS) $(DSTHTMLS) $(PUBSTATICS) $(INDEX_PAGE) $(FRAGS)
clean:
	rm -rf $(PUBDIR)
serve:
	cd publish && python -m SimpleHTTPServer
qiniu:
	qrsync conf.json

$(PUBDIR)/%.md: %.md
	@mkdir -p $(@D)
	cp $< $@
$(PUBDIR)/%.html: %.html
	@mkdir -p $(@D)
	cp $< $@
$(PUBDIR)/%.html: $(PUBDIR)/%.md
	pandoc $(PANDOC_OPTIONS) --template $(INDEX_TEMPLATE) $< -o $@
$(FRAGDIR)/%.html: $(PUBDIR)/%.md
	@mkdir -p $(@D)
	pandoc $(PANDOC_OPTIONS) $< -o $@

$(PUBDIR)/$(STATICSDIR)/%.js: $(STATICSDIR)/%.js
	@mkdir -p $(@D)
	cp $< $@
$(PUBDIR)/$(STATICSDIR)/%.css: $(STATICSDIR)/%.css
	@mkdir -p $(@D)
	cp $< $@
$(PUBDIR)/%: $(STATICSDIR)/%
	@mkdir -p $(@D)
	cp $< $@

$(INDEX_PAGE): README.md $(INDEX_TEMPLATE)
	@mkdir -p $(@D)
	pandoc $(PANDOC_OPTIONS) --template $(INDEX_TEMPLATE) $(INDEX_YAML) $< -o $(INDEX_PAGE)

index:
	chmod +x ./pbindex.sh
	./pbindex.sh > $(PBINDEX_YAML) && \
	echo "## Panbook Index" | \
	pandoc $(PANDOC_OPTIONS) --template pbindex.template $(PBINDEX_YAML) > $(PBINDEX_PAGE)

%.md: $($(subst .,/, $@):%/md=%.md)
	cp $< $@
