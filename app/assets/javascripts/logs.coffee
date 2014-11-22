# 表示件数の変更処理

$ ($) ->
  timer = null
  interval_msec = 20 * 1000  # 20 秒

  logs_setup = ->
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
      console.log "set cookie:tailNum " + tailNum
      @

    $("#refresh").change ->
      if $(this).is(":checked")
        startTimer()
      else
        stopTimer()
      @

  setup_timer = ->
    if $("#refresh").is(":checked")
      startTimer()
    else
      stopTimer()

  startTimer = ->
    console.log "start timer ..."
    timer = setInterval (->
      console.log "reload ..."
      location.href = ('' + window.location).replace('?refresh=1', '') + '?refresh=1'
      return
    ), interval_msec

  stopTimer = ->
    console.log "stop timer ..."
    clearInterval(timer)

  $(document).on 'page:fetch', ->
    $('body').spin('large', 'red')
    @

  $(document).on 'page:receive', ->
    $('body').spin(false)
    logs_setup()
    setup_timer()
    @

  $(document).on 'page:change', ->
    $('body').spin(false)
    logs_setup()
    setup_timer()
    @

  logs_setup()
