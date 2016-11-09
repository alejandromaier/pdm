Sequelize = require 'sequelize'
sequelize = require '../config/db'
co = require 'co'
credential = require('credential')()

attributes =
  username:
    type: Sequelize.STRING
    unique: true
  hash:
    type: Sequelize.STRING
  password:
    type: Sequelize.VIRTUAL

User = sequelize.define 'user', attributes

User.beforeCreate (instance, options) -> co ->
  instance.hash = yield credential.hash instance.password
  instance.password = ''

User.beforeUpdate (instance, options) -> co ->
  instance.hash = yield credential.hash instance.password
  instance.password = ''

User.verify = (username, password) ->
  user = yield User.findOne where: {username}
  if (user)
    yield credential.verify user.hash, password
  else
    false

module.exports = User

CantoSitio = require './CantoSitio'

User.hasMany CantoSitio, as: 'cantos'

User.agregarCanto = (userId, cantoId) -> co ->
  yaExiste = yield CantoSitio.findOne where: {userId, cantoId}
  if yaExiste
    throw new Error 'El canto ya pertenece al sitio'
  else
    yield CantoSitio.create {userId, cantoId, destacado: 0}

User.sync()
