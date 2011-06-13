meta :envvar do
  accepts_value_for :env_value

  template {
    met? { 
      grep "export #{basename}=\"#{env_value}\"", bash_profile
    }
    
    meet {
      append_to_file "export #{basename}=\"#{env_value}\"", bash_profile
    }
  }
end