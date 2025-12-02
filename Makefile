# h/t to @jimhester and @yihui for this parse block:
# https://github.com/yihui/knitr/blob/dc5ead7bcfc0ebd2789fe99c527c7d91afb3de4a/Makefile#L1-L4
# Note the portability change as suggested in the manual:
# https://cran.r-project.org/doc/manuals/r-release/R-exts.html#Writing-portable-packages
PKGNAME = `sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION`
PKGVERS = `sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION`


all: check

build: install_deps
	R CMD build .

check: build
	R CMD check --no-manual $(PKGNAME)_$(PKGVERS).tar.gz

install_deps:
	Rscript \
	-e 'if (!requireNamespace("remotes")) install.packages("remotes")' \
	-e 'remotes::install_deps(dependencies = TRUE)'

install: build
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

clean:
	@rm -rf $(PKGNAME)_$(PKGVERS).tar.gz $(PKGNAME).Rcheck


VPATH = R:data_in:cache

URL_DATA=https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip

init_wd:
	-mkdir data_in temp log cache


Coursera-SwiftKey.zip:
	# $@ ...
	curl -o data_in/$(@F) $(URL_DATA)

Coursera-SwiftKey.mrk: Coursera-SwiftKey.zip
	# $@ ...
	cd data_in; unzip -j $(<F)


FNAME_TEXT=de_DE.blogs de_DE.news de_DE.twitter \
 			en_US.blogs en_US.news en_US.twitter \
			fi_FI.blogs fi_FI.news fi_FI.twitter \
			ru_RU.blogs ru_RU.news ru_RU.twitter

$(foreach fname,$(FNAME_TEXT),text.$(fname).txt): text.%.txt: %.txt \
	R/Clean_texts.R
	# $@ ...
	Rscript $(lastword $^)\
		--in=data_in/$(*).txt \
		--out=cache/$(@F)
