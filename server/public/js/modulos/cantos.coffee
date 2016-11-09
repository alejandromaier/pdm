Vue.component 'vista-canto',
  props: ['nombre','canto']
  template: """
    <div class="card">
      <div class="card-block">
        <h4 class="card-title">{{nombre}}</h4>
        <div v-for="linea in canto">{{linea}}</div>
      </div>
    </div>
  """


if document.getElementsByClassName('cantos').length
  new Vue
    el: '.cantos'
    data: actual: undefined
    methods:
      eliminar: (id) ->
        fetch "/cantos/#{id}",
          method: 'DELETE'
          credentials: 'same-origin'
        .then -> location.reload()
      seleccionar: (id) ->
        fetch("/api/cantos/#{id}")
        .then (resp) -> resp.json()
        .then (canto) => @actual = canto
      agregar: (id) ->
        fetch "/cantos/agregar/#{id}",
          method: 'POST'
          credentials: 'same-origin'
        .then -> location.reload()
      destacar: (id) ->
        fetch "/cantos/destacar/#{id}",
          method: 'PUT'
          credentials: 'same-origin'
        .then -> location.reload()
    computed:
      canto: -> @actual and @actual.contenido.split('\n')
