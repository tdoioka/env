pkg-bdeps := general
pkg-rdeps :=
$(eval $(call pkg-rule-task))

$(pkg-preup):
	$(log-pre)
	$(call pkg-schedule,			\
		language-pack-ja-base		\
		language-pack-ja		\
		locales				\
	)
	$(log-post)

$(pkg-update):
	$(log-pre)
#	sudo locale-gen en_US.UTF-8
	sudo update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
	sudo ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
# 	echo -e 'ZONE="Asia/Tokyo"\nUTC=false' | \
		sudo tee /etc/sysconfig/clock 2>&1 >/dev/null
	$(log-post)

$(pkg-all):
	$(log-pre)
	$(MAKE) $(SHRC)/locale.rc.sh
	$(log-post)
