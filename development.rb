dep 'development' do
  requires  'homebrew', 
            'ruby',
            'fonts'
end            
            
dep 'fonts' do
  requires 'bitstream-vera.font'
end

dep 'bitstream-vera.font' do
  source 'http://ftp.gnome.org/pub/GNOME/sources/ttf-bitstream-vera/1.10/ttf-bitstream-vera-1.10.tar.gz'
  provides %w{Vera VeraBI VeraBd VeraIt VeraMoBI VeraMoBd VeraMoIt VeraMono VeraSe VeraSeBd}
end