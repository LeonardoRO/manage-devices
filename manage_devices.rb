#!/usr/bin/env ruby

#Install ios-deploy and mobiledevice before running this script:
#brew install ios-deploy
#brew install mobiledevice

#iOS devices

def list_ios_devices
  STDOUT.sync = true
  devices = ""
  while devices == "" do
    devices = `mobiledevice list_devices`
  end
  devices.split(/\n/)
end

def clean_install_ios_devices bundle_id, path
  list_ios_devices.each do |device|
    puts 'Uninstalling app device id: ' + device.to_s
    uninstall_ios_app device, bundle_id
    puts 'Installing app device id: ' + device.to_s
    install_ios_app device, path
  end
end

def install_specific_game path
  clean_install_ios_devices 'com.bundleid.game', path
end

def install_ios_app device_id, path
  `ios-deploy -i #{device_id} --debug --bundle #{path}`
end

def uninstall_ios_app device_id, bundle_id
  `mobiledevice uninstall_app -u #{device_id} '#{bundle_id}'`
end

#Android devices

def list_android_devices
  devices = `adb devices | grep -v List | cut -f 1`
  devices.split(/\n/)
end

def clean_install_android_devices bundle_id, path
  list_android_devices.each do |device|
    puts 'Uninstalling app device id: ' + device.to_s
    uninstall_android_app device, bundle_id
    puts 'Installing app device id: ' + device.to_s
    install_android_app device, path
  end
end

def install_android_app device_id, path
  `adb -s #{device_id} install #{path}`
end

def uninstall_android_app device_id, bundle_id
  `adb -s #{device_id} uninstall #{bundle_id}`
end

#puts "Path to .app or .ipa file: "
#path = $stdin.gets.chomp
#@run = install_paradise_bay path