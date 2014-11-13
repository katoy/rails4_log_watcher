# 表示件数の変更処理

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
    console.log "set cooloe:tailNum " + tailNum
    @

$ ($) ->
  logs_setup()

  $(document).on 'page:fetch', ->
    $('body').spin('large', 'red')
    @

  $(document).on 'page:receive', ->
    $('body').spin(false)
    logs_setup()
    @

  $(document).on 'page:change', ->
    $('body').spin(false)
    logs_setup()
    @

  timer = null
  startTimer = ->
    console.log "start timer ..."
    timer = setInterval (->
      $("#reload_btn").trigger('click');
      console.log "reload ..."
      return
    ), 2000

  stopTimer = ->
    console.log "stop timer ..."
    clearInterval(timer)

  $("#refresh").change ->
    if $(this).is(":checked")
      startTimer()
    else
      stopTimer()
    @
