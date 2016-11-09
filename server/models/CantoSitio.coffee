Sequelize = require 'sequelize'
sequelize = require '../config/db'
co = require 'co'

attributes =
  destacado:
    type: Sequelize.INTEGER

CantoSitio = sequelize.define 'canto_sitio', attributes

module.exports = CantoSitio

Canto = require './Canto'
User = require './User'

CantoSitio.belongsTo Canto
CantoSitio.belongsTo User

CantoSitio.sync()
