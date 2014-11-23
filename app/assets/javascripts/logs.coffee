# 表示件数の変更処理

my_console_log = (str) -> console.log "# " + new Date() + ":" + str

$ ($) ->

  logs_setup = ->
    my_console_log "logs_setup ..."

    timer = null
    interval_msec = 20 * 1000  # 20 秒

    setup_timer = ->
      my_console_log "setup timer ..."
      if $("#refresh").is(":checked")
        startTimer()
      else
        stopTimer()
      $('#interval_msec').text('' + interval_msec / 1000 + '秒')

    startTimer = ->
      my_console_log "start timer ..."
      timer = setInterval (->
        my_console_log "reload ..."
        location.href = ('' + window.location).replace('?refresh=1', '') + '?refresh=1'
        return
      ), interval_msec

    stopTimer = ->
      my_console_log "stop timer ..."
      clearInterval(timer)

    $('#perPage').change  ->
      per_page = $("#perPage option:selected").text()
      $.cookie('perPage', per_page, {expires: 30, path: '/'})
      location.reload()
      @

    $(":input").bind "keyup mouseup", (event) ->
      return @ unless $("#tailNum")[0]

      text = $("#tailNum").val()
      tailNum = Number(text) || 0
      $.cookie('tailNum', tailNum, {expires: 30, path: '/'})
      my_console_log "set cookie:tailNum " + tailNum
      @

    $("#refresh").change ->
      my_console_log "refresh change ..."
      setup_timer()
      @

    setup_timer()

  $(document).on 'page:fetch', ->
    $('body').spin('large', 'red')
    @

  $(document).on 'page:receive', ->
    $('body').spin(false)
    @

  $(document).on 'page:change', ->
    $('body').spin(false)
    logs_setup()
    @
