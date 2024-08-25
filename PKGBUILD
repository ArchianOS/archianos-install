# Maintainer: Ondřej Šmehlík <ondra.smehlik@gmail.com>
pkgname=archianinstall
pkgver=1.0
pkgrel=1
pkgdesc="Install script for ArchianOS."
arch=('any')
url="http://archianos.org"
license=('GPL-3.0')
source=('archianinstall.sh')
md5sums=('SKIP')

package() {
    install -Dm755 "$srcdir/archianinstall.sh" "$pkgdir/usr/bin/archianinstall"
}
