dep 'processes' do
  requires 'disable spotlight indexing'
end

# use quicksilver for the same thing instead
dep 'disable spotlight indexing' do
  met? {
    `mdutil -s /` =~ /Indexing disabled/
  }
  
  meet {
    sudo "mdutil -a -i off"
  }
end

def ensure_not_running(process_executable)
  unless raw_shell("ps aux | grep #{process_executable} | grep 'grep' --invert-match").stdout.empty? 
    log "#{process_executable} is running. Need to stop first"
    if confirm("Shutting down #{process_executable} brutally (close yourself if you want first to be safer)")
      shell "killall #{process_executable}"
    end
  end
end