express = require 'express'
app = express()
{get, post, put, remove, resources, insecure} = require('./methods')(app)
HomeController = new (require('../controllers/HomeController'))()
UserController = new (require('../controllers/UserController'))()
CantosController = new (require('../controllers/CantosController'))()

insecure [
  '/',
  '/login',
  '/logout',
  '/registrarse'
]

get '/', HomeController.index

# get '/users', UserController.index
# get '/registrarse', UserController.new
# post '/registrarse', UserController.create
post '/login', UserController.login
get '/logout', UserController.logout
post '/cambiar', UserController.update

get '/cantos', CantosController.index
post '/cantos', CantosController.create
get '/cantos/nuevo', CantosController.nuevo
get '/cantos/agregar', CantosController.agregar
post '/cantos/agregar/:id', CantosController.add
put '/cantos/destacar/:id', CantosController.destacar
get '/cantos/:id', CantosController.edit
post '/cantos/:id', CantosController.update
remove '/cantos/:id', CantosController.remove
get '/cantos/:id/stream', CantosController.stream

module.exports = app
