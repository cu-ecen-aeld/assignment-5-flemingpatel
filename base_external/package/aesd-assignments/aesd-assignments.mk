
##############################################################
#
# AESD-ASSIGNMENTS
#
##############################################################


AESD_ASSIGNMENTS_VERSION = c16de0c
AESD_ASSIGNMENTS_SITE = "git@github.com:cu-ecen-aeld/assignments-3-and-later-flemingpatel.git"
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_GIT_SUBMODULES = YES

define AESD_ASSIGNMENTS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/finder-app all
	$(MAKE) CC="$(TARGET_CC)" -C $(@D)/server all
endef


define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	$(INSTALL) -d 0755 $(@D)/conf/ $(TARGET_DIR)/etc/finder-app/conf/
	$(INSTALL) -m 0755 $(@D)/conf/* $(TARGET_DIR)/etc/finder-app/conf/
	$(INSTALL) -m 0755 $(@D)/assignment-autotest/test/assignment4/* $(TARGET_DIR)/bin
	$(INSTALL) -D -m 755 $(@D)/finder-app/finder.sh $(TARGET_DIR)/usr/bin/finder.sh
	$(INSTALL) -D -m 755 $(@D)/finder-app/finder-test.sh $(TARGET_DIR)/usr/bin/finder-test.sh
	$(INSTALL) -D -m 755 $(@D)/finder-app/writer $(TARGET_DIR)/usr/bin/writer
	$(INSTALL) -D -m 755 $(@D)/server/aesdsocket $(TARGET_DIR)/usr/bin/aesdsocket
	$(INSTALL) -D -m 755 $(@D)/server/aesdsocket-start-stop $(TARGET_DIR)/etc/init.d/S99aesdsocket

	# modifying scripts
	sed -i 's|conf/username.txt|/etc/finder-app/conf/username.txt|g' $(TARGET_DIR)/usr/bin/finder-test.sh
	sed -i 's|\.\./conf/assignment.txt|/etc/finder-app/conf/assignment.txt|g' $(TARGET_DIR)/usr/bin/finder-test.sh
	sed -i 's|\./writer|/usr/bin/writer|g' $(TARGET_DIR)/usr/bin/finder-test.sh
	sed -i 's|\./finder.sh|/usr/bin/finder.sh|g' $(TARGET_DIR)/usr/bin/finder-test.sh
	sed -i 's|bash|sh|g' $(TARGET_DIR)/usr/bin/finder.sh
	sed -i '/OUTPUTSTRING=$(/usr/bin/finder.sh "$$WRITEDIR" "$$WRITESTR")/a echo "\$${OUTPUTSTRING}" > /tmp/assignment4-result.txt' $(TARGET_DIR)/usr/bin/finder-test.sh
	sed -i 's|bash|sh|g' $(TARGET_DIR)/etc/init.d/S99aesdsocket
endef

$(eval $(generic-package))

