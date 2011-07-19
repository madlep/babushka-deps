dep 'firefox' do
  requires 'Firefox.app', 'firefox addons'
end

dep 'Firefox.app' do
  source 'http://download.mozilla.org/?product=firefox-5.0.1&os=osx&lang=en-US'
end

dep 'firefox addons' do
  requires 'adblockplus.firefox_addon', 'firebug.firefox_addon'
end

dep 'adblockplus.firefox_addon' do
  url 'https://addons.mozilla.org/firefox/downloads/latest/1865/addon-1865-latest.xpi?src=addon-detail'
end

dep 'firebug.firefox_addon' do
  url 'https://addons.mozilla.org/en-US/firefox/downloads/latest/1843/addon-1843-latest.xpi?src=external-getfirebug'
end

def firefox_bin
  '/Applications/Firefox.app/Contents/MacOS/firefox-bin'
end

def firefox_profile_path
  @firefox_profile_path ||= Dir.glob("#{home}/Library/Application Support/Firefox/Profiles/*.default/")[0]
end