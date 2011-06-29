include Babushka::PromptHelpers

dep 'development' do
  requires  'homebrew', 
            'ruby',
            'fonts',
            'git config',
            'erlang.managed'
end            
            
dep 'fonts' do
  requires 'bitstream-vera.font'
end

dep 'bitstream-vera.font' do
  source 'http://ftp.gnome.org/pub/GNOME/sources/ttf-bitstream-vera/1.10/ttf-bitstream-vera-1.10.tar.gz'
  provides %w{Vera VeraBI VeraBd VeraIt VeraMoBI VeraMoBd VeraMoIt VeraMono VeraSe VeraSeBd}
end

git_config_vars = {
  'alias.br'                => 'branch -a',
  'alias.co'                => 'commit -v',
  'alias.st'                => 'status',
  'apply.ignorewhitespace'  => 'change',
  'color.branch'            => 'auto',
  'color.grep'              => 'auto',
  'color.diff'              => 'auto',
  'color.interactive'       => 'auto',
  'color.status'            => 'auto',
  'core.editor'             => 'mate -w',
  'core.whitespace'         => 'tab-in-indent,tabwidth=2',
  'user.email'              => lambda{prompt_for_value 'Git email'},  
  'user.name'               => lambda{prompt_for_value 'Git username', :default => username},
  'github.user'             => lambda{prompt_for_value 'Github username', :default => username}
}.each{|var, value|
  dep "#{var}.git_config"  do
    git_value value
  end
}

dep 'git config' do
  requires git_config_vars.map{|key, value| "#{key}.git_config"}
end

dep 'erlang.managed' do
  provides 'erl'
end