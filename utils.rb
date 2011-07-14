dep 'utils' do
  requires  'usr local owned by current user',
            'usr local Cellar exists',
            'wget.managed'
end

dep 'usr local owned by current user' do
  def current_user
    @current_user ||= raw_shell('id').stdout.match(/uid=\d+\((.+?)\)/)[1]
  end
  
  def current_user_id
    @current_user_id ||= raw_shell('id').stdout.match(/uid=(\d+)/)[1]
  end
  
  def current_user_group
    @current_user_group ||= raw_shell('id').stdout.match(/gid=\d+\((.+?)\)/)[1]
  end
  
  met?{
    Dir.glob("/usr/local/**/*").all?{|f| 
      if f =~ /\*/ # llvm* file gives us grief
        true
      else
        stat = File.stat(f)
  
        ok = true      
        ok &= stat.readable?        
        ok &= (stat.uid.to_s == current_user_id.to_s)
      
        log "need to fix #{f}" unless ok
        ok
      end
    }
  }

  meet{ 
    shell "chown -R #{current_user}:#{current_user_group} /usr/local", :sudo => true
  }
end

dep 'usr local Cellar exists' do
  met?{ File.exists? "/usr/local/Cellar" }
  meet{ FileUtils.mkdir "/usr/local/Cellar" }
end

dep 'wget.managed'