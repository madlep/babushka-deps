meta :tmplugin, :for => :osx do
  accepts_list_for :source

  def path
    '~/Library/Application Support/TextMate/Plugins' / name
  end

  template {
    requires 'TextMate.app' #, 'textmate not running'
    met? { path.dir? }
    before { shell "mkdir -p #{path.parent}" }
    meet {
      source.each {|uri|
        Babushka::Resource.extract uri
        shell "open ~/.babushka/build/AckMate.1.1.2/#{name}"
        sleep 1
      }
    }
  }
end