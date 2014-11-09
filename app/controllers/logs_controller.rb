
require 'file-tail'

class LogsController < ActionController::Base
  MAX_READ = 1000

  include ActionController::Live
  include LogHelper

  def get_perPage
    ans = cookies[:perPage] = (cookies[:perPage] || 10).to_i
    ans = 10 if ans < 1
    cookies[:perPage] = ans
  end

  def get_tailNum
    ans = (cookies[:tailNum] || 10).to_i
    ans = 10 if ans < 1
    cookies[:tailNum] = ans
  end

  def index
    log(:OK, "enter #{params}")
    index_params
    log(:OK, "leave #{params}")
    render template: 'logs/index', layout: 'application'
  end

  def show
    log(:OK, "enter #{params}")
    begin
      show_params
      @log = params['log']
      @env = ENV['RAILS_ENV']
      @env = 'development' unless ENV['RAILS_ENV']

      case @log
      when 'rails'
        show_log_rails_static(@env)
        render template: 'logs/show_tail_static', layout: 'application'
      when 'db'
        show_log_db_static(@env)
        export_grid_if_requested
        render template: 'logs/show_db_static', layout: 'application'
      else
        render text: 'Not Found', status: 404
      end
      return
    ensure
      log(:OK, "leave #{params}")
    end
  end

  protected

  def index_params
    params.permit()
  end

  def show_params
    params.permit(:log,:utf8, :num, :commit, :authenticity_token,
                  grid: [
                    :page, :order, :order_direction, :pp, :export,
                    f: [:message,
                        :status,
                        id: [:fr, :to],
                        created_at: [:fr, :to]
                       ]
                  ])
    params.require(:log)
  end

  def show_log_rails_static(env)
    fileName = File.join('.', 'log', "#{env}.log")
    tailNum = get_tailNum

    @lines = tail(fileName, tailNum).join("\n")
    @lines = escape_ansi_color(ERB::Util.html_escape(@lines))
    @time = Time.new
    @type = :file
    @fileName = fileName
    @tailNum = tailNum
  end

  def show_log_db_static(env)
    @perPage = get_perPage
    operationallogs = Operationallog.all
    @operationallogs = initialize_grid(operationallogs,
                                       per_page: @perPage,
                                       order: 'id',
                                       order_direction: :desc,
                                       name: 'grid',
                                       enable_export_to_csv: true,
                                       csv_file_name:        'operationallogs'
                                      )
    return if export_grid_if_requested
  end

  # See http://stackoverflow.com/questions/754494/reading-the-last-n-lines-of-a-file-in-ruby
  def tail(filename, n)
    ary = []
    begin
      File.open(filename) do |file|
        buffer = 1024
        idx = (file.size - buffer).abs
        chunks = []
        lines = 0

        begin
          file.seek(idx)
          chunk = file.read(buffer)
          lines += chunk.count("\n")
          chunks.unshift chunk
          idx -= buffer
        end while lines < ( n + 1 ) && file.pos != 0 && idx > 0

        tail_of_file = chunks.join('')
        ary = tail_of_file.split(/\n/)
        ary[ary.size - n, ary.size - 1].collect {|a| a.force_encoding("utf-8")}
      end
    rescue => ex
      ary << [ex.to_s]
    end
    ary
  end

  # See http://stackoverflow.com/questions/4894434/ansi-escape-code-with-html-tags-in-ruby
  def escape_ansi_color(data)
    { 1 => :nothing,
      2 => :nothing,
      4 => :nothing,
      5 => :nothing,
      7 => :nothing,
      30 => :black,
      31 => :red,
      32 => :green,
      33 => :yellow,
      34 => :blue,
      35 => :magenta,
      36 => :cyan,
      37 => :white,
      40 => :nothing,
      41 => :nothing,
      43 => :nothing,
      44 => :nothing,
      45 => :nothing,
      46 => :nothing,
      47 => :nothing,
      }.each do |key, value|
      if value != :nothing
        data.gsub!(/\e\[#{key}m/,"<span style=\"color:#{value}\">")
      else
        data.gsub!(/\e\[#{key}m/,'<span>')
      end
    end
    data.gsub(/\e\[0m/,'</span>')
  end
end
