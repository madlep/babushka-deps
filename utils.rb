dep 'utils' do
  requires  'usr local owned by current user',
            'usr local Cellar exists',
            'wget.managed'
end

dep 'usr local owned by current user' do
  def current_user
    failable_shell('id').stdout.match(/uid=\d+\((.+?)\)/)[1]
  end
  
  def current_user_group
    failable_shell('id').stdout.match(/gid=\d+\((.+?)\)/)[1]
  end
  
  met?{
    Dir.glob("/usr/local/**/*").all?{|f| 
      if f =~ /\*/ # llvm* file gives us grief
        true
      else
        stat = File.stat(f)
      
        ok = true
        ok &= stat.readable?
        ok &= stat.writable?
        ok &= stat.executable?
        ok &= stat.grpowned?
        ok &= stat.world_readable?
        ok &= !stat.world_writable?
      
        log "need to fix #{f}" unless ok
        ok
      end
    }
  }

  meet{ 
    shell "chmod -R 775 /usr/local", :sudo => true
    shell "chown -R root:#{current_user_group} /usr/local", :sudo => true
  }
end

dep 'usr local Cellar exists' do
  met?{ File.exists? "/usr/local/Cellar" }
  meet{ FileUtils.mkdir "/usr/local/Cellar" }
end

dep 'wget.managed'