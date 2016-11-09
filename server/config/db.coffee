Sequelize = require 'sequelize'

sequelize = new Sequelize 'coritariov2', 'root', 'usbw',
  host: 'localhost'
  dialect: 'mysql'

module.exports = sequelize
