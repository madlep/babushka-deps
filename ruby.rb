dep 'ruby' do
  requires  'rvm',
            'rvm default gems',
            '1.9.3 installed.rvm',
            '1.9.3 default.rvm'
end

meta :rvm do
  def rvm args
    shell("export PATH=~/bin:$PATH; rvm #{args}", :log => args['install'], :spinner => true)
  end
  
  template {
    requires 'rvm default gems'
  }
end

dep '1.9.3 installed.rvm' do
  requires 'rvm'
  met? { rvm('list')['ruby-1.9.3'] }
  meet { log("rvm install 1.9.3") { rvm 'install 1.9.3'} }
end

dep '1.9.2 default.rvm' do
  requires '1.9.2 installed.rvm'
  met? { login_shell('ruby --version')['ruby 1.9.3'] }
  meet { rvm('use 1.9.3 --default') }
end

dep 'rvm' do
  met? { File.exists?(File.join(home, '.rvm')) }
  meet {
    shell 'bash -c "`curl https://rvm.beginrescueend.com/install/rvm`"'
    
    rvm_session_init = %{[[ -s "#{home}/.rvm/scripts/rvm" ]] && source "#{home}/.rvm/scripts/rvm"  # This loads RVM into a shell session.}
    append_to_file(rvm_session_init, bash_profile)
    shell rvm_session_init
  }
end

meta :rvm_default_gem do
  template {
    def default_gems_file
      File.join(home, ".rvm", "gemsets", "default.gems")
    end
  
    met? { grep basename, default_gems_file }
    meet { append_to_file basename, default_gems_file }
  }
end

$rvm_default_gems = []
["bundler", "awesome_print"].each do |gem_name|
  dep "#{gem_name}.rvm_default_gem"
  $rvm_default_gems << gem_name
end

dep "rvm default gems" do
  requires $rvm_default_gems.map{|gem_name| "#{gem_name}.rvm_default_gem"}
end
