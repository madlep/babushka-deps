dep 'environment' do
  requires  'git-prompt', 
            'ssh-keys',
            'GIT_EDITOR.envvar',
            'SVN_EDITOR.envvar',
            'EDITOR.envvar',
            'bash.managed',
            'bash-completion.managed'
end

def home
  ENV["HOME"]
end

def bash_profile
  File.join(home, ".bash_profile")
end

def username
  ENV["USER"]
end

dep 'git-prompt' do
  def git_prompt_path
    File.join(home, ".git-prompt")
  end
  
  met? {
    File.exists?(git_prompt_path)
  }
  
  meet {
    log ("cloning git://github.com/lvv/git-prompt.git into #{git_prompt_path}")
    
    FileUtils.rm_rf git_prompt_path
    shell "git clone git://github.com/lvv/git-prompt.git #{git_prompt_path}", :spinner => true
    command = "[[ \\$- == *i* ]]   &&   . #{git_prompt_path}/git-prompt.sh"
    append_to_file(command, bash_profile)
  }
end

dep 'ssh-keys' do
  met? {
    File.exists?(File.join(home, ".ssh", "id_rsa"))
  }
  
  meet {
    passphrase = prompt_for_value("passphrase (or just hit enter if you suck at security)", :default => '')
    shell "ssh-keygen -f #{home}/.ssh/id_rsa -N '#{passphrase}'"
  }
end

['GIT_EDITOR.envvar', 'SVN_EDITOR.envvar', 'EDITOR.envvar'].each do |var|
  dep var do
    env_value 'mate -w'
  end
end

dep 'bash.managed' do
  met? {
    ENV["SHELL"] =~ /\/usr\/local\/bin\/bash/ || @bash_done
  }
  
  after {
    if `grep "/usr/local/bin/bash" /etc/shells`.empty?
      append_to_file("/usr/local/bin/bash", "/etc/shells", :sudo => true)
    end
    `chsh -s /usr/local/bin/bash`
    @bash_done = true
  }
end

dep 'bash-completion.managed' do
  met? {
    File.exists?("/usr/local/etc/bash_completion")
  } 
  
  after {
    command = <<-EOS
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi
    EOS
    append_to_file(command, bash_profile)
    
    `ln -s "/usr/local/Library/Contributions/brew_bash_completion.sh" "/usr/local/etc/bash_completion.d"`
  }
end