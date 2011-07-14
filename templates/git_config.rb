meta :git_config do
  accepts_list_for :git_value

  template {
    met? {
      !`git config --global --get #{basename}`.blank?
    }
    
    meet {
      raw_shell "git config --unset-all #{basename}"
      git_value.each do |value|
        shell "git config --global --add #{basename} '#{value}'"
      end
    }
  }
end