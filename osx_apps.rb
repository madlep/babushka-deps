require 'fileutils'

dep 'OSX apps' do
  requires  'LittleSnitch', 
            'textmate', 
            'Quicksilver.app', 
            'firefox', 
            'Adium.app', 
            'Skype.app', 
            'DbVisualizer.app', 
            'Eclipse', 
            '1Password.app', 
            'Dropbox.app',
            'Microsoft Office 2011',
            'Steam.app',
            'Growl.installer',
            'Google Chrome.app',
            'Wunderlist.app',
            'Evernote.app',
            'terminal config',
            'VLC.app'
end

dep 'Quicksilver.app' do
  source 'https://github.com/downloads/quicksilver/Quicksilver/Quicksilver-b58-3841.tar.gz'
end


dep 'LittleSnitch' do
  
  met? {
    File.exists?('/Applications/Little Snitch Configuration.app')
  }
  
  meet {
    Babushka::Resource.extract('http://www.obdev.at/downloads/littlesnitch/LittleSnitch-2.3.6.dmg') do
      shell "open 'Little Snitch Installer.app/' --wait-apps"
    end
  }
end

dep 'Adium.app' do
  source 'http://download.adium.im/Adium_1.4.1.dmg'
end

dep 'Skype.app' do
  source 'http://www.skype.com/go/getskype-macosx.dmg'
end

dep 'DbVisualizer.app' do
  source 'http://www.dbvis.com/product_download/dbvis-7.1.5/media/dbvis_macos_7_1_5.dmg'
  after {
    shell "open '/Applications/DbVisualizer Installer.app' --wait-apps"
    FileUtils.rm_rf('/Applications/DbVisualizer Installer.app')
  }
end

dep 'Eclipse' do
  
  met? {
    File.exists?('/Applications/eclipse/Eclipse.app')
  }
  
  meet {
    Babushka::Resource.extract('http://mirror.aarnet.edu.au/pub/eclipse/technology/epp/downloads/release/helios/SR2/eclipse-jee-helios-SR2-macosx-cocoa-x86_64.tar.gz') do
      FileUtils.mv("eclipse", "/Applications")
    end
  }
end

dep '1Password.app' do
  source 'http://aws.cachefly.net/dist/1P/mac/1Password-3.5.9.zip'
end

dep 'Dropbox.app' do
  source 'http://cdn.dropbox.com/Dropbox%201.1.35.dmg'
end

dep 'Microsoft Office 2011' do
  met? {
    File.exists?('/Applications/Microsoft Office 2011/')
  }
  
  meet {
    Babushka::Resource.extract('http://msft.digitalrivercontent.net/01/436488234-10287693--SPR//mac/X17-45975.dmg') do
      log "Running Office Installer - this might take a while. You need to stick around and drive it though"
      shell "open 'Office Installer.mpkg/' --wait-apps"
    end
  }
    
end

dep 'Steam.app' do
  source 'http://cdn.store.steampowered.com/public/client/installer/steam.dmg'
end

dep 'Growl.installer' do
  source 'http://growl.cachefly.net/Growl-1.2.2.dmg'
  
  provides 'growlnotify'
end

dep 'Google Chrome.app' do
  source 'http://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg'
end

dep 'Wunderlist.app' do
  source 'http://www.6wunderkinder.com/downloads/wunderlist-1.2.1-osx.zip'
end

dep 'Evernote.app' do
  source 'http://evernote.s3.amazonaws.com/mac/release/Evernote_154267.dmg'
end

dep 'terminal config' do
  met? {
    script = <<-AS
      tell application "Terminal"
        return name of default settings
      end tell
    AS
    `osascript -e '#{script}'` =~ /madlep/
  }
  
  meet {
    script = <<-AS
      tell application "Terminal"
        open "#{File.join(File.dirname(__FILE__), "data", "madlep.terminal")}"
        close first window
        set default settings to settings set "madlep"
        repeat with w in every window
          set current settings of w to settings set "madlep"
        end repeat
      end tell
    AS
    `osascript -e '#{script}'`
  }
end

dep 'VLC.app' do
  source 'http://sourceforge.net/projects/vlc/files/1.1.10.1/macosx/vlc-1.1.10.1-intel64.dmg/download'
end