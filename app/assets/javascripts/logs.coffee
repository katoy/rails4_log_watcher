# 表示件数の変更処理
$('#per-page').change ->
  per_page = $("#per-page option:selected").text()
  $.cookie('per_page', per_page, {expires: 30, path: '/'})
  location.reload()
  @

$("#num").bind "keyup change click", (event) ->
  text = $("#num").val()
  num = Number(text) || 0
  $.cookie('num', num, {expires: 30, path: '/'})
  @
