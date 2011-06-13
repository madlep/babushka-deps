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
  
  done = false
  met?{done}
  meet{ 
    shell "chown -R #{current_user}:#{current_user_group} /usr/local", :sudo => true
    done = true
  }
end

dep 'usr local Cellar exists' do
  met?{ File.exists? "/usr/local/Cellar" }
  meet{ FileUtils.mkdir "/usr/local/Cellar" }
end

dep 'wget.managed'