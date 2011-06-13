dep 'environment' do
  requires  'git-prompt', 
            'ssh-keys',
            'GIT_EDITOR.envvar'
end

def home
  ENV["HOME"]
end

def bash_profile
  File.join(home, ".bash_profile")
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

dep 'GIT_EDITOR.envvar' do
  env_value 'mate -w'
end