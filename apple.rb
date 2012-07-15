require 'json'
require 'net/http'

class Apple 
  def initialize(ip, port=8080)
    @ip, @port = ip, port
  end

  def run(method, params={})
    unless defined? @conn
      @conn = Net::HTTP.new @ip, @port
      @conn.set_debug_output $stderr if defined?(DEBUG)&&DEBUG
    end

    if method.instance_of? String
      req = { jsonrpc: "2.0",
              method: method,
              params: params,
              id: 42 }.to_json
    elsif method.instance_of? Array
      req = method.each_with_index.map do |m,i|
        { jsonrpc: "2.0",
          method: m[0],
          params: m[1],
          id: 100+i }
      end
      req = req.to_json
    end
    resp = @conn.post '/jsonrpc', req

    JSON.parse resp.body
  end

  def slideshow(path)
    run "Player.Open", item: { path:path }
  end

  def stop
    0.upto 2 do |n|
      run "Player.Stop", playerid:n
    end
  end

  def playclips(clips, shuffle=false, repeat=true)
    clips.shuffle! if shuffle

    commands = Array.new
    commands << ["Playlist.Clear", playlistid: 1]
    commands << ["Player.Stop", playerid: 1]
    commands = commands + clips.each_with_index.map do |clip,i| 
      ["Playlist.Insert", { playlistid: 1,
                            position: i+1,
                            item:{file:clip}
                            }]
    end
    commands << ["Player.Open", item:{playlistid:1}]
    commands << ["Player.Repeat", playerid:1, 
      state: repeat ? "all" : "off" ]
    run commands
  end

end
