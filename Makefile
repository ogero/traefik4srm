# Version of traefik to install.
VERSION=2.10.7

package: src/package.tgz src/scripts src/WIZARD_UIFILES src/INFO src/PACKAGE_ICON.PNG src/PACKAGE_ICON_256.PNG
	echo $^ | sed 's|src/||g' | xargs tar -C src/ -cf Traefik-$(VERSION)-srm.spk
	mkdir -p dist && mv Traefik-$(VERSION)-srm.spk dist/

# The package.tgz file is used to bundle raw files as necessary. We use it
# to include the prebuilt traefik binary.
#
# For more information, see https://help.synology.com/developer-guide/synology_package/package_tgz.html
src/package.tgz:
	bin/download-traefik $(VERSION)
	mv package.tgz src/package.tgz	
