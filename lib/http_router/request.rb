class HttpRouter
  class Request
    attr_accessor :path, :params, :rack_request, :extra_env, :continue, :passed_with, :called
    attr_reader :acceptable_methods
    alias_method :rack, :rack_request
    alias_method :called?, :called

    def initialize(path, rack_request)
      major, minor, = RUBY_VERSION.split('.')

      @rack_request = rack_request

      escaper = major.to_i > 2 || (major.to_i == 2 && minor.to_i >= 7) ? CGI : URI

      @path = escaper.unescape(path).split(/\//)
      @path.shift if @path.first == ''
      @path.push('') if path[-1] == ?/
      @extra_env = {}
      @params = []
      @acceptable_methods = Set.new
    end

    def joined_path
      @path * '/'
    end

    def to_s
      "request path, #{path.inspect}"
    end

    def path_finished?
      @path.size == 0 or @path.size == 1 && @path.first == ''
    end
  end
end
