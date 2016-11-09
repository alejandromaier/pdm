new Vue
  el: '.navbar'
  data: abierto: false, error: undefined
  methods:
    abrir: (e) ->
      e.stopPropagation()
      e.preventDefault() if !e.target.classList.contains('btn')
      @abierto = true
      fun = =>
        @abierto = false
        document.removeEventListener 'click', fun
      document.addEventListener 'click', fun
    enviar: (e) ->
      username = e.target.username.value
      password = e.target.password.value
      if username.length <= 3 or password.length <= 6
        e.preventDefault()
        @error = 'Demasiado corto'
      else
        @error = undefined
