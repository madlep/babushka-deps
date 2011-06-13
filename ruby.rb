dep 'ruby' do
  requires  'rvm', 
            '1.9.2 installed.rvm',
            '1.8.7 installed.rvm',
            '1.9.2 default.rvm', 
            'jruby 1.6.2 installed.rvm'
end

meta :rvm do
  def rvm args
    shell("export PATH=~/bin:$PATH; rvm #{args}", :log => args['install'], :spinner => true)
  end
end

dep '1.8.7 installed.rvm' do
  requires 'rvm'
  met? { rvm('list')['ruby-1.8.7'] }
  meet { log("rvm install 1.8.7") { rvm 'install 1.8.7'} }
end

dep '1.9.2 installed.rvm' do
  requires 'rvm'
  met? { rvm('list')['ruby-1.9.2'] }
  meet { log("rvm install 1.9.2") { rvm 'install 1.9.2'} }
end

dep 'jruby 1.6.2 installed.rvm' do
  requires 'rvm'
  met? { rvm('list')['jruby-1.6.2'] }
  meet { log("rvm install jruby 1.6.2") { rvm 'install jruby 1.6.2'} }  
end

dep '1.9.2 default.rvm' do
  requires '1.9.2 installed.rvm'
  met? { login_shell('ruby --version')['ruby 1.9.2'] }
  meet { rvm('use 1.9.2 --default') }
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
