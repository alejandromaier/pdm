express = require 'express'
co = require 'co'
app = express()
Cantos = require './models/Canto'
Sitios = require './models/User'
jwt = require 'jsonwebtoken'
socketIO = require 'socket.io'

app.get '/:sitio/cantos', co.wrap (req, res) ->
  try
    cantos = yield Cantos.getCantosDeSitio parseInt req.params.sitio, 10
    cantos = cantos.map (e) -> id: e.cantoId, nombre: e.nombre, updatedAt: e.updatedAt, destacado: e.destacado
  catch error
    console.log error
  res.send cantos

app.get '/cantos/:id', co.wrap (req, res) ->
  try
    canto = (yield Cantos.findById parseInt req.params.id, 10).toJSON()
  catch error
    console.log error
  res.send id: canto.id, nombre: canto.nombre, contenido: canto.contenido

app.post '/crear-sitio', co.wrap (req, res) ->
  {username, password, llave} = req.body
  if llave = 'martin'
    nuevo = yield Sitios.create {username, password}
    res.send nuevo
  else
    res.send error: 'Llave incorrecta'

init = (http) ->
  streams = {}
  io = socketIO(http)
  console.log 'Escuchando en WebSocket'
  io.on 'connection', (socket) ->
    socket.on 'sitio', (sitio) ->
      socket.join sitio
      ahora = Math.floor Date.now()/1000
      antes = streams[sitio] and streas[sitio].time
      if antes and (ahora - antes) < 60
        socket.emit 'estrofa', streams[sitio]

  app.post '/stream', co.wrap (req, res) ->
    {username} = jwt.decode req.cookies.logged
    {canto, estrofa} = req.body
    streams[username] =
      canto: canto
      estrofa: estrofa
      time: Math.floor Date.now()/1000
    io.to(username).emit 'estrofa', streams[username]
    res.send streams[username]

  app.get '/stream', co.wrap (req, res) ->
    {sitio} = req.query
    ahora = Math.floor Date.now()/1000
    antes = streams[sitio] and streams[sitio].time
    if antes and (ahora - antes) < 60
      res.send streaming: streams[sitio]
    else
      res.send streaming: false

module.exports =
  app: app
  init: init
