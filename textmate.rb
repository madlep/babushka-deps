dep 'textmate' do
  requires 'TextMate.app', 'textmate helper', 'AckMate.tmplugin', 'erlang.tmbundle', "CoffeeScript.tmbundle", "html5.tmb"
end

dep 'textmate helper' do
  requires 'TextMate.app'
  met? { which 'mate' }
  meet { shell "ln -sf /Applications/TextMate.app/Contents/SharedSupport/Support/bin/mate /usr/local/bin/mate" }
end

dep 'TextMate.app' do
  source 'http://dl.macromates.com/TextMate_1.5.10_r1631.zip'  
end

dep 'AckMate.tmplugin' do  
  source 'http://github.com/downloads/protocool/AckMate/AckMate.1.1.2.zip'
end

dep 'erlang.tmbundle' do
  source 'https://github.com/textmate/erlang.tmbundle'
end

dep "CoffeeScript.tmbundle" do
  source "https://github.com/jashkenas/coffee-script-tmbundle"
end

dep "html5.tmbundle" do
  source "https://github.com/johnmuhl/html5.tmbundle.git"
end