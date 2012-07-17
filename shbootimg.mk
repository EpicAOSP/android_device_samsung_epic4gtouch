#
# Copyright (C) 2012 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

# copy modules
MODULES := dhd.ko \
	j4fs.ko \
	cyasswitch.ko \
	scsi_wait_scan.ko

MOD_CP := $(PRODUCT_OUT)/root/lib/modules/$(MODULES)
$(MOD_CP): $(LOCAL_INSTALLED_MODULE)
	@echo "Copy: $@ -> $(MODULES)"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) cp -f /system/lib/modules/$(MODULES) $@

$(INSTALLED_RAMDISK_TARGET): $(MODULES)

INSTALLED_BOOTIMAGE_TARGET := $(PRODUCT_OUT)/boot.img
$(INSTALLED_BOOTIMAGE_TARGET): $(INSTALLED_KERNEL_TARGET) $(recovery_ramdisk) $(INSTALLED_RAMDISK_TARGET) $(PRODUCT_OUT)/utilities/flash_image $(PRODUCT_OUT)/utilities/busybox
	$(call pretty,"Boot image: $@")
	$(hide) ./device/samsung/epic4gtouch/mkshbootimg.py $@ $(INSTALLED_KERNEL_TARGET) $(INSTALLED_RAMDISK_TARGET) $(recovery_ramdisk)

$(INSTALLED_RECOVERYIMAGE_TARGET): $(INSTALLED_BOOTIMAGE_TARGET)
	$(ACP) $(INSTALLED_BOOTIMAGE_TARGET) $@
