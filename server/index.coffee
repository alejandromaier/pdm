express = require 'express'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
cors = require 'cors'
co = require 'co'

require './config/config'

app = express()
http = require('http').Server(app)

app.use(cors())
app.use(express.static('public'))
app.use(bodyParser.urlencoded({ extended: false }))
app.use(cookieParser('martin'))
app.set('view engine', 'pug')
app.use(bodyParser.json())

api = require './api'
app.use('/api', api.app)
app.use('/', require('./config/routes'))
api.init http

http.listen 3000, -> console.log 'Escuchando en el puerto 3000'
