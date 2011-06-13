meta :font, :for => :osx do
  accepts_list_for :source
  accepts_list_for :provides

  template {
    met? { 
      provides.all?{|font| File.exists?(File.join(home, "Library", "Fonts", "#{font}.ttf"))}
    }
    
    meet {
      source.each {|uri|
        Babushka::Resource.extract uri do
          shell "cp *.ttf #{File.join(home, "Library", "Fonts")}"
        end
      }
    }
  }
end