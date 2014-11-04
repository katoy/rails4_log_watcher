
require 'file-tail'

class LogsController < ActionController::Base
  MAX_READ = 1000

  include ActionController::Live
  include LogHelper

  def get_perPage
    (cookies[:per_page] || 10).to_i
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
     @log = show_params
      @num = 0
      @num = params['num'].to_i if params['num']
      @num = cookies[:num].to_i if (@num == 0) && cookies[:num]
      @num = 20 if @num < 1
      cookies[:num] = @num

      @log = show_params
      case @log
      when 'rails'
        show_log_rails_static(@num)
        render template: 'logs/show_tail_static', layout: 'application'
      when 'db'
        show_log_db_static
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

  def show_log_rails_static(num)
    env = ENV['RAILS_ENV']
    env = 'development' unless ENV['RAILS_ENV']
    filename = File.join('.', 'log', "#{env}.log")

    @lines = tail(filename, num)
    @time = Time.new
    @type = :file
  end

  def show_log_db_static
    operationallogs = Operationallog.all
    @operationallogs = initialize_grid(operationallogs,
                                       per_page: get_perPage,
                                       order: 'id',
                                       order_direction: :desc,
                                       name: 'grid',
                                       enable_export_to_csv: true,
                                       csv_file_name:        'operationallogs'
                                      )
    # return if export_grid_if_requested
  end

  # See http://stackoverflow.com/questions/754494/reading-the-last-n-lines-of-a-file-in-ruby
  def tail(filename, n)
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
      end while lines < ( n + 1 ) && file.pos != 0

      tail_of_file = chunks.join('')
      ary = tail_of_file.split(/\n/)
      ary[ ary.size - n, ary.size - 1 ].collect {|a| a.force_encoding("utf-8")}
    end
  end
end
