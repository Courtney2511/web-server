require 'socket'                                    # Require socket from Ruby Standard Library (stdlib)

host = 'localhost'
port = 2000

server = TCPServer.open(host, port)                 # Socket to listen to defined host and port
puts "Server started on #{host}:#{port} ..."        # Output to stdout that server started

def success_header(content_length)
  success_header = []
  success_header << "HTTP/1.1 200 OK"
  success_header << "Content-Type: text/html" # should reflect the appropriate content type (HTML, CSS, text, etc)
  success_header << "Content-Length: #{content_length}" # should be the actual size of the response body
  success_header << "Connection: close"
  success_header.join("\r\n")
end

def error_header(content_length)
  not_found_header = []
  not_found_header << "HTTP/1.1 404 Not Found"
  not_found_header << "Content-Type: text/plain" # is always text/plain
  not_found_header << "Content-Length: #{content_length}" # should the actual size of the response body
  not_found_header << "Connection: close"
  not_found_header.join("\r\n")
end

loop do                                             # Server runs forever
  client = server.accept                            # Wait for a client to connect. Accept returns a TCPSocket

  lines = []
  while (line = client.gets) && !line.chomp.empty?  # Read the request and collect it until it's empty
    lines << line.chomp
  end
  puts lines                                        # Output the full request to stdout

  filename = lines[0].gsub(/GET \//, '').gsub(/\ HTTP.*/, '')

  filename = 'index.html' if filename == ''

  if File.exists?(filename)
    response_body = File.read(filename)
    header = success_header(response_body.length)
  else
    response_body = "File Not Found\n"
    header = error_header(response_body.length)
  end

  response = [header, response_body].join("\r\n\r\n")

  client.puts(response)                      # Output the current time to the client
  client.close                                      # Disconnect from the client
end
