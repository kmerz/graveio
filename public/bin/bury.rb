#!/usr/bin/env ruby
# bury.rb - a script for easy pasting/posting of content to graveio
#
# Example Configuration file (~/.buryrc):
# default:
#   :host: 172.30.200.153
#   :port: 3000
#
# VIM Mapping for easy pasting/posting of content:
# map <F2> :w !bury -t %<CR>

require 'net/http'
require 'uri'
require 'optparse'
require 'logger'
require 'yaml'

# Logger
$log = Logger.new(STDOUT)
$log.level = Logger::WARN

class Bury
  def self.run()
    parseopts

    if @@cfg[:postid]
      restext, path, cookie = get("/p/#{@@cfg[:postid]}.text")
      puts restext
      exit 0
    end

    # GET the form
    reshtml, path, cookie = get("/p/new")

    # Extract the authenticity_token
    match = reshtml.match('"authenticity_token" type="hidden" value="(.{43}=)"')
    unless $1
      warn "Authtoken extraction failed"
      exit 1
    end
    authtoken = $1
    $log.debug "TOKEN: #{authtoken.inspect}\nCOOKIE: #{cookie.inspect}\n"
    data = URI.encode_www_form([
      ["utf8", "%E2%9C%93"],
      ["authenticity_token", authtoken],
      ["post[title]", @@cfg[:title]],
      ["post[author]", @@cfg[:author]],
      ["post[content]", @@cfg[:content]],
      ["commit", "Create Post"]
    ])

    # POST the Content
    reshtml, path, cookie = post("/p" , cookie, data)

    if reshtml.match('Post was successfully created')
      $log.info "Post was successfully created"
      puts "http://#{@@cfg[:host]}:#{@@cfg[:port]}#{path}"
      exit 0
    else
      warn "POST FAILED"
      $log.debug reshtml
      exit 1
    end
  end

  def self.parseopts()
    # Settings
    # Reading the default config file at ~/.buryrc
    configf = {}
    f = File.expand_path("~/.buryrc")
    if File.exist?(f)
      begin
        $log.debug "Loading configuration #{f}"
        configf = YAML.load(File.read(f))
      rescue
        $log.warn "Error loading config file #{f}. Using default configuration"
        $log.info e
        exit 1
      end
    end

    # Parse the commandline-options
    attrs = {}
    options = OptionParser.new do |opts|
      opts.banner = "Usage: #{$0} [OPTION]... [FILE]..."
      opts.separator "A script for posting and getting of content to graveio"
      opts.separator "Options:"
      opts.on("-t [TITLE]", "--title [TITLE]",
        "Specify the title of the post") do |title|
        attrs[:title] = title
      end
      opts.on("-c [CONTENT]", "--content [CONTENT]",
        "Specify the content source",
        "alternatively STDIN will be used") do |content|
        attrs[:content] = content
      end
      opts.on("-a [AUTHOR]", "--author [AUTHOR]",
        "Specify the author for this posted",
        "Without this option, the value in config will be used") do |author|
        attrs[:author] = author
      end

      opts.on("-s [HOST]", "--server [HOST]", "Specify the grave server",
        "Without this flag, the value in config will be used") do |host|
        attrs[:host] = host
      end
      opts.on("-p [PORT]", "--port [PORT]", "Specify the grave server port",
        "Without this flag, the value in config will be used") do |port|
        attrs[:port] = port
      end
      opts.on("-d", "--debug", "Enable debug output") do
        $log.level = Logger::DEBUG
      end
      opts.on("-v", "--verbose", "Enable verbose output") do
        $log.level = Logger::INFO
      end
      opts.on("-g [POSTID]", "--get [POSTID]", "Retrieve post as text") do |pid|
        attrs[:postid] = pid
      end
      opts.on("-h", "--help", "Show this help") do
        puts options
        exit 0
      end
    end
    options.parse!

    # make sure configf["default"] exists
    configf["default"] ||= {}
    @@cfg = configf["default"].merge(attrs)

    # Default configuration
    # Host and port fall-back currently disabled
    #@@cfg[:host] = "172.30.200.153" unless @@cfg[:host]
    @@cfg[:port] = "80" unless @@cfg[:port]
    @@cfg[:agent] = "User-Agent: bury" unless @@cfg[:agent]

    unless @@cfg[:postid]
      # Determine Title
      unless @@cfg[:title]
        @@cfg[:title] = ARGF.filename unless ARGF.filename == "-"
      end

      # Determine Content
      unless @@cfg[:content]
        if !ARGF.eof?
          @@cfg[:content] = ARGF.read
        else
          puts options unless @@cfg[:content]
          exit 1
        end
      end
    end
  end

  def self.get(path = "/", cookie = "")
    # Start HTTP "session"
    http = Net::HTTP.new(@@cfg[:host], @@cfg[:port])
    # Prepare the GET
    $log.info "GETting http://#{@@cfg[:host]}:#{@@cfg[:port]}#{path}"
    $log.debug "With Cookie: #{cookie.inspect}"
    headers = {
      'User-Agent' => @@cfg[:agent],
      'Cookie' => cookie
    }
    # Send the request and process cookie
    begin
      response = http.get(path, headers)
    rescue
      warn "Couldn't connect to server #{@@cfg[:host]}:#{@@cfg[:port]}"
      exit 1
    end
    $log.debug "RESPONSE: #{response}\nDATA:\n#{response.body}\n"
    cookie = response['set-cookie'].split('; ')[0] if response['set-cookie']
    # Handle requested redirect
    case response
      when Net::HTTPSuccess     then [response.body, path, cookie]
      when Net::HTTPRedirection then 
        get(URI.parse(response['location']).path, cookie)
    else
      warn "Received unexpected response #{response}"
      exit 1
    end
  end

  def self.post(path, cookie, postdata)
    # Start HTTP "session"
    http = Net::HTTP.new(@@cfg[:host], @@cfg[:port])
    # Prepare the POST
    $log.info "POSTing to http://#{@@cfg[:host]}:#{@@cfg[:port]}#{path}"
    $log.debug "With Cookie: #{cookie.inspect}"
    headers = {
      'User-Agent' => @@cfg[:agent],
      'Referer' => "http://#{@@cfg[:host]}#{path}",
      'Cookie' => cookie,
      'Content-Type' => 'application/x-www-form-urlencoded'
    }
    # Send the request and process cookie
    begin
      response, data = http.post2(path, postdata, headers)
    rescue
      warn "Couldn't connect to server #{@@cfg[:host]}:#{@@cfg[:port]}"
    end
    $log.debug "RESPONSE: #{response}\nDATA:\n#{data}\n"
    cookie = response['set-cookie'].split('; ')[0] if response['set-cookie']
    # Handle requested redirect
    case response
      when Net::HTTPSuccess     then [data, path, cookie]
      when Net::HTTPRedirection then
        get(URI.parse(response['location']).path, cookie)
    else
      warn "Received unexpected response #{response}"
      exit 1
    end
  end
end

Bury.run
