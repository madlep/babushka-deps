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
            'Steam.app'
end

dep 'TextMate.app' do
  source 'http://download-b.macromates.com/TextMate_1.5.10.dmg'
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

dep 'firefox' do
  requires 'Firefox.app', 'firefox blank homepage'
end

dep 'Firefox.app' do
  source 'http://download.mozilla.org/?product=firefox-4.0.1&os=osx&lang=en-US'
end

dep 'firefox blank homepage' do
  requires 'Firefox.app'
  
  def prefs_js_path
    Dir.glob("#{home}/Library/Application Support/Firefox/Profiles/*.default/prefs.js")[0]
  end
  
  met?{
    grep 'user_pref("browser.startup.page", 0);', prefs_js_path
  }
  
  meet {
    ensure_not_running('firefox-bin')
    cd(File.dirname(prefs_js_path)) do
      shell '#{sed} -i ''.babushka_bak'' ''/"browser\.startup\.page"/d'' #{File.basename(prefs_js_path)}' # remove the existing homepage setting if present
      append_to_file 'user_pref("browser.startup.page", 0);', File.basename(prefs_js_path)
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