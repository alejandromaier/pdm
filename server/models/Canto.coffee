Sequelize = require 'sequelize'
sequelize = require '../config/db'
co = require 'co'

attributes =
  nombre:
    type: Sequelize.STRING
  contenido:
    type: Sequelize.TEXT

Canto = sequelize.define 'canto', attributes

module.exports = Canto

CantoSitio = require './CantoSitio'

Canto.hasMany CantoSitio, as: 'sitios'

Canto.sync()

Canto.agregar = co.wrap ({user, nombre, contenido}) ->
  nuevo = yield Canto.create {nombre, contenido}
  yield CantoSitio.create userId: user.get('id'), cantoId: nuevo.get('id'), destacado: 0
  nuevo

Canto.eliminar = co.wrap (userId, cantoId) ->
  yield CantoSitio.destroy where: {userId, cantoId}
  referenciasAlCanto = yield CantoSitio.count where: {cantoId}
  if referenciasAlCanto is 0
    yield Canto.destroy where: id: cantoId

# Canto.getCantosDeSitio = (user) ->
#   lista = yield user.getCantos()
#   Promise.all lista.map (r) -> r.getCanto()

Canto.getCantosDeSitio = (user) -> co ->
  query = "SELECT * FROM cantos JOIN canto_sitios ON cantos.id = canto_sitios.cantoId WHERE canto_sitios.userId = #{user} ORDER BY destacado DESC"
  (yield sequelize.query query)[0]

Canto.getCantosNoEnSitio = (user) -> co ->
  query = """
    SELECT *
    FROM cantos
    WHERE id NOT IN (
      SELECT cantoId
      FROM canto_sitios
      WHERE userId = #{user}
    )
  """
  yield sequelize.query query, model: Canto
