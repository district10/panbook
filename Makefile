PUBDIR:=publish
STATICSDIR:=statics

INDEX_YAML:=index.yaml
INDEX_TEMPLATE:=index.template
INDEX_PAGE:=$(PUBDIR)/index.html

SRCMD:=$(wildcard *.md */*.md */*/*.md */*/*/*.md */*/*/*/*.md)
SRCMD:=$(filter-out $(PUBDIR)/%, $(SRCMD))
DSTMD:=$(addprefix $(PUBDIR)/, $(SRCMD))
HTMLS:=$(DSTMD:%.md=%.html)
HTMLS:=$(filter-out $(INDEX_PAGE), $(HTMLS))
STATICS:=$(wildcard $(STATICSDIR)/*.js $(STATICSDIR)/*.css)
PUBSTATICS:=$(addprefix $(PUBDIR)/, $(STATICS))

all: $(DSTMD) $(HTMLS) $(PUBSTATICS) $(INDEX_PAGE)
clean:
	rm -rf $(PUBDIR)/*

$(PUBDIR)/%.md: %.md
	@mkdir -p $(@D)
	cp $< $@
$(PUBDIR)/%.html: $(PUBDIR)/%.md
	pandoc $< -o $@

$(PUBDIR)/$(STATICSDIR)/%.js: $(STATICSDIR)/%.js
	@mkdir -p $(@D)
	cp $< $@
$(PUBDIR)/$(STATICSDIR)/%.css: $(STATICSDIR)/%.css
	@mkdir -p $(@D)
	cp $< $@

$(INDEX_PAGE): $(INDEX_TEMPLATE) $(INDEX_YAML)
	@mkdir -p $(@D)
	pandoc --template $(INDEX_TEMPLATE) $(INDEX_YAML) -o $(INDEX_PAGE)
