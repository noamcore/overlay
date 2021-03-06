# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="sqlite"

inherit python-single-r1 xdg

DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="https://apps.ankiweb.net"
LICENSE="AGPL-3+"
DOCS=( README.md README.development README.contributing README.md
	LICENSE LICENSE.logo )

SRC_URI="https://apps.ankiweb.net/downloads/current/${P}-source.tgz -> ${P}.tgz"
SLOT="0"
KEYWORDS="amd64"
IUSE="latex +recording +sound test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="${PYTHON_DEPS}
	>=dev-python/PyQt5-5.9[gui,svg,webengine,widgets,${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.7.4[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/pyaudio[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/send2trash[${PYTHON_USEDEP}]
	recording? ( media-sound/lame )
	sound? ( media-video/mpv )
	latex? (
		app-text/texlive
		app-text/dvipng
	)
"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"
PATCHES=( "${FILESDIR}"/anki-web-folder.patch )

src_prepare() {
	default
	sed -i -e "s/updates=True/updates=False/" \
		aqt/profiles.py || die
}

src_compile() {
	:
}

src_test() {
	sed -e "s:nosetests:${EPYTHON} ${EROOT}usr/bin/nosetests:" \
		-i tools/tests.sh || die
	./tools/tests.sh || die
}

src_install() {
	doicon ${PN}.png ${PN}.xpm
	domenu ${PN}.desktop
	doman ${PN}.1
	einstalldocs

	python_newscript runanki anki
	python_domodule aqt anki
	python_moduleinto anki
	python_domodule locale

	insinto /usr/share/anki
	doins -r web
}
