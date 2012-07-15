DEBUG = true
LLOG_FILE = 'd:\\hi\\llog.log'
LOG_FILE = 'd:\\hi\\daemon.log'


require 'sinatra' 
require 'fileutils'
require 'erb'
require './apple.rb'

#DIR='d:/avi/'
DIR='/tmp/'
Sinatra_IP='192.168.1.103'
Sinatra_Port='9090'
AppleIPs=['192.168.1.143',
          '192.168.1.104',
          '192.168.1.100',
          '192.168.1.105']
SmbPATH='smb://BUFFALO/trnt/'
FileExtensions = %w(mp4 m4v avi mpeg mpg)


#class MySinatraApp < Sinatra::Base


  get '/' do
    redirect '/apple'
  end

  get '/apple' do
    @files = Dir.foreach(DIR).grep(/(#{FileExtensions.join('|')})$/)
  	erb :index
  end

  post '/apple' do
    n = params.delete "box"
    repeat = params.delete "repeat"
    shuffle = params.delete "shuffle"
    slideshow = params.delete "slideshow"
    play = params.delete "play"
    
    a=Apple.new AppleIPs[n.to_i-1]
    if slideshow
      a.slideshow SmbPATH+n
    elsif play
      a.playclips params.each_key.to_a.map{|f| SmbPATH+f}
    end

    erb :dialog
  end
# end
#
# begin
#   require 'win32/daemon'
#   include Win32
#   $stdout.reopen("thin-server.log", "w")
#   $stdout.sync = true
#   $stderr.reopen($stdout)

#   class Daemon
#     def service_main
#       #puts 'hi'
#       MySinatraApp.run! :host => 'tureyzahav.sytes.net', :port => Sinatra_Port, :server => 'webrick'
#       #puts 'bye'
#       while running?
#         sleep 10
#         File.open(LOG_FILE, "a"){ |f| f.puts "Service is running #{Time.now}" }
#       end
#     end

#     def service_stop
#       File.open(LOG_FILE, "a"){ |f| f.puts "***Service stopped #{Time.now}" }
#       exit!
#     end
#   end

#   Daemon.mainloop

# rescue Exception => err
#   File.open(LOG_FILE,'a+'){ |f| f.puts " ***Daemon failure #{Time.now} err=#{err} " }
#   raise
# end
