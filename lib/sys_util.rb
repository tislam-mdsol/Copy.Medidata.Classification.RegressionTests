ENV['CODER_ROOT'] ||= File.join("c:","git","coder") 

def bg_system(cmd, args = "", stdout = nil, quiet = false)
  puts "Executing '#{cmd}'\n\twith arguments '#{args}' #{'> '+stdout if stdout}" unless quiet
  cmd = "start \"\" \"#{cmd}\" #{args}"
  cmd += " >#{stdout} 2>&1" if stdout
  pid = spawn cmd
  Process.detach(pid)
  pid
end

def start_service(svc, port)
  server = File.join(ENV['CODER_ROOT'],"features","support","CassiniDev4-console.exe")
  params = "/pm:specific /port:#{port} /path:#{File.join(ENV['CODER_ROOT'],svc)}"
  bg_system(server, params)
end

