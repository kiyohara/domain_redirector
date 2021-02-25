require 'sinatra'

set :port, ENV['PORT'] || 4567

helpers do
  def proto
    @proto ||= (ENV['REDIRECT_PROTO'] || 'https')
  end

  def host
    @host ||= ENV['REDIRECT_HOST'].to_s
  end

  def port
    @port ||= ENV['REDIRECT_PORT'].to_i
  end

  def host?
    !host.empty?
  end

  def redirect_path(request)
    "#{proto}://#{host}#{port == 0 ? '' : ":#{port}"}#{request.path_info}"
  end
end

get '*' do
  raise 'REDIRECT_HOST environment required' unless host?

  redirect redirect_path(request), 303
rescue => e
  haml :error, locals: { message: e }
end

__END__

@@ layout
%html
  = yield

@@ error
%div ERROR: #{message}

