PUBDIR:=publish
FRAGDIR:=$(PUBDIR)/fragments
STATICSDIR:=statics
INDEX_YAML:=index.yaml
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
	pandoc --template $(INDEX_TEMPLATE) $(INDEX_YAML) $< -o $@
$(FRAGDIR)/%.html: $(PUBDIR)/%.md
	@mkdir -p $(@D)
	pandoc $< -o $@

$(PUBDIR)/$(STATICSDIR)/%.js: $(STATICSDIR)/%.js
	@mkdir -p $(@D)
	cp $< $@
$(PUBDIR)/$(STATICSDIR)/%.css: $(STATICSDIR)/%.css
	@mkdir -p $(@D)
	cp $< $@
$(PUBDIR)/%: $(STATICSDIR)/%
	@mkdir -p $(@D)
	cp $< $@

$(INDEX_PAGE): README.md $(INDEX_TEMPLATE) $(INDEX_YAML)
	@mkdir -p $(@D)
	pandoc --template $(INDEX_TEMPLATE) $(INDEX_YAML) $< -o $(INDEX_PAGE)

%.md: $($(subst .,/, $@):%/md=%.md)
	cp $< $@
