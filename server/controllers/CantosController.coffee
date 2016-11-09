co = require 'co'
Sitio = require '../models/User'
Cantos = require '../models/Canto'
CantoSitio = require '../models/CantoSitio'

module.exports = class CantosController

  index: co.wrap ->
    @user = yield Sitio.findOne where: username: @req.user.username
    @cantos = yield Cantos.getCantosDeSitio(@user.get('id'))
    'cantos/index'

  nuevo: -> 'cantos/nuevo'

  agregar: co.wrap ->
    @user = yield Sitio.findOne where: username: @req.user.username
    @cantos = yield Cantos.getCantosNoEnSitio @user.get 'id'
    'cantos/agregar'

  add: co.wrap ->
    canto = @req.params.id
    @user = yield Sitio.findOne where: username: @req.user.username
    try
      @nuevo = yield Sitio.agregarCanto @user.get('id'), canto
    catch error
      console.log error
    @res.send success: true

  destacar: co.wrap ->
    user = yield Sitio.findOne where: username: @req.user.username
    userId = user.get('id')
    cantoId = @req.params.id
    ref = yield CantoSitio.findOne where: {userId, cantoId}
    if ref
      ref.destacado = (ref.get('destacado') + 1) % 2
      yield ref.save()
    else
      console.log 'Error'
    @res.send success: true

  remove: co.wrap ->
    try
      canto = parseInt @req.params.id, 10
      @user = yield Sitio.findOne where: username: @req.user.username
      try
        console.log 'hola'
        yield Cantos.eliminar @user.get('id'), canto
      catch error
        console.log error
      @res.send success: true
    catch error
      console.log error

  create: co.wrap ->
    @user = yield Sitio.findOne where: username: @req.user.username
    try
      yield Cantos.agregar user: @user, nombre: @req.body.nombre, contenido: @req.body.contenido
    catch error
      console.log error
    @res.redirect '/cantos'

  edit: co.wrap ->
    @canto = yield Cantos.findById @req.params.id
    'cantos/edit'

  update: co.wrap ->
    @canto = yield Cantos.findById @req.params.id
    @canto.nombre = @req.body.nombre
    @canto.contenido = @req.body.contenido
    yield @canto.save()
    @res.redirect "/cantos/#{@req.params.id}"

  stream: co.wrap ->
    @canto = yield Cantos.findById @req.params.id
    if @canto
      @canto = @canto.toJSON()
      @letra = @canto.contenido.split('\r\n\r\n')
      @formatear = (estrofa) -> estrofa.split('\r\n')
      'cantos/stream'
    else
      @res.redirect '/cantos'
