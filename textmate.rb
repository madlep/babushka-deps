dep 'textmate' do
  requires 'TextMate.app', 'textmate helper', 'AckMate.tmplugin'
end

dep 'textmate helper' do
  requires 'TextMate.app'
  met? { which 'mate' }
  meet { shell "ln -sf '#{app_dir('TextMate.app') / 'Contents/SharedSupport/Support/bin/mate'}' /usr/local/bin/mate" }
end

dep 'TextMate.app' do
  source 'http://download-b.macromates.com/TextMate_1.5.10.dmg'
end

dep 'AckMate.tmplugin' do  
  source 'http://github.com/downloads/protocool/AckMate/AckMate.1.1.2.zip'
end