meta :firefox_addon do  
  def addon_path(addon)
    File.join(firefox_profile_path, addon)
  end
  
  accepts_value_for :url
  
  template {
    requires 'Firefox.app'
    
    met?{
      firefox_profile_path && File.exists?(addon_path(basename))
    }
  
    meet {
      ensure_not_running('firefox-bin')
      log "installing #{basename} addon (you might need to option-tab into it and click buttons manually)"
      shell "#{firefox_bin} #{url} 1> /dev/null 2> /dev/null"

      # hack - need to wait for FF to restart
      5.times do
        break if File.exists?(addon_path(basename))
        sleep 1
      end
    }
  }
end