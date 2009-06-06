require "rubygems"
require "rake"

require "choctop"

ChocTop.new do |s|
  # Remote upload target
  s.host     = '2pii@imotifs.pearcomp.com'
  s.base_url   = "http://#{s.host}"
  s.remote_dir = '/home2/2pii/webapps/imotifs'

  # Custom DMG
  s.background_file = "Images/background.png"
  s.app_icon_position = [110, 110]
  s.applications_icon_position =  [330, 170]
  s.volume_icon = "Images/dmg128.png"
  #s.applications_icon = "icon.icns" # or "appicon.png"
end
