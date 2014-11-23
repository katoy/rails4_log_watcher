# 表示件数の変更処理

my_console_log = (str) -> console.log "# " + new Date() + ":" + str
timer = null
interval_msec = 20 * 1000  # 20 秒

setup_timer = ->
  my_console_log "setup timer ..."
  if $("#refresh").is(":checked")
    startTimer()
  else
    stopTimer()

startTimer = ->
  my_console_log "start timer ..."
  clearInterval(timer)
  timer = null
  timer = setInterval (->
    my_console_log "reload ..."
    # location.href = ('' + window.location).replace('?refresh=1', '') + '?refresh=1'
    # return

    # disable page scrolling to top after loading page content
    Turbolinks.enableTransitionCache(true)
    # pass current page url to visit method
    location = ('' + window.location).replace('?refresh=1', '') + '?refresh=1'
    Turbolinks.visit(location)
    # enable page scroll reset in case user clicks other link
    Turbolinks.enableTransitionCache(false)
  ), interval_msec

stopTimer = ->
  my_console_log "stop timer ..."
  clearInterval(timer)
  timer = null

$ ($) ->

  logs_setup = ->
    my_console_log "logs_setup ..."

    $('#interval_msec').text('' + interval_msec / 1000 + '秒')

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

  $(document).on 'page:fetch', ->
    my_console_log('page:fetch')
    $('body').spin('large', 'red')
    @

  $(document).on 'page:receive', ->
    my_console_log('page:receive')
    $('body').spin(false)
    @

  $(document).on 'page:change', ->
    my_console_log('page:change')
    $('body').spin(false)
    logs_setup()
    @

  logs_setup()
