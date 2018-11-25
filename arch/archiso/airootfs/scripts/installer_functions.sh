#!/bin/bash

function baseline_install {
	echo "Baseline install beginning..."
	pushd /tmp
	mkdir install
	cd install
	git clone https://github.com/ZahFox/linux-toolbox.git
	BASELINE=/tmp/install/linux-toolbox/arch/install/baseline.sh
	chmod +x $BASELINE
	$BASELINE
	rm -rf linux-toolbox
	popd
	echo "Baseline install complete!"
}

function finish_install {
	echo "Rebooting System..."
	systemctl reboot
}
