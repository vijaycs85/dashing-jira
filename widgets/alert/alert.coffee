class Dashing.Alert extends Dashing.Widget

  onData: (data) ->
    $(@node).removeClass("status-warning")
    $(@node).removeClass("status-danger")
    $(@node).children('.icon-warning-sign').hide()
    status = @get('status')
    if status is 'danger'
      $(@node).children('.icon-warning-sign').show()
      $(@node).addClass("status-danger")
      @set 'title', 'DANGER'
    else if status is 'warning'
      $(@node).addClass("status-warning")
      $(@node).children('.icon-warning-sign').show()
      @set 'title', 'WARNING' 
    else if status is 'ok'
      @set 'title', 'Everything is ok'
