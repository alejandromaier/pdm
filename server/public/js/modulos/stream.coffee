if document.getElementById('stream')
  new Vue
    el: '#stream'
    data: selected: 0, cantidad: 0, canto: undefined
    methods:
      isSelected: (index) ->
        @cantidad = Math.max @cantidad, index
        if index == @selected then 'card-outline-primary' else ''
      seleccionar: (index) ->
        prev = @selected
        @selected = index
        @enviar() if prev != @selected
      enviar: ->
        headers = new Headers()
        headers.append 'Content-Type', 'application/json'
        fetch '/api/stream',
          method: 'POST'
          credentials: 'same-origin'
          headers: headers
          body: JSON.stringify
            canto: @canto
            estrofa: @selected
    mounted: ->
      @canto = parseInt @$el.getAttribute('data-canto'), 10
      document.addEventListener 'keyup', (e) =>
        prev = @selected
        switch e.which
          when 39
            @selected = Math.min @selected+1, @cantidad
          when 37
            @selected = Math.max @selected-1, 0
        @enviar() if prev != @selected
      @enviar()
