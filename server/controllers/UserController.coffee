co = require 'co'
User = require '../models/User'
jwt = require 'jsonwebtoken'
_ = require 'lodash'

module.exports = class UserController

  index: co.wrap (req, res) ->
    try
      @users = _.map (yield User.findAll attributes: ['username']), (e) -> e.dataValues
    catch error
      console.log error
    'users/index'

  new: co.wrap (req, res) ->
    @user = User.build()
    'users/new'

  create: co.wrap (req, res) ->
    yield User.create
      username: req.body.username
      password: req.body.password
    res.redirect '/users'

  update: co.wrap (req, res) ->
    @user = yield User.findOne where: username: @req.user.username
    valid = yield User.verify @user.get('username'), req.body.actual
    if valid and req.body.nueva == req.body.confirmacion
      @user.password = req.body.nueva
      yield @user.save()
    res.redirect '/'

  login: co.wrap (req, res) ->
    valid = yield User.verify req.body.username, req.body.password
    if valid
      token = jwt.sign username: req.body.username, 'martin'
      res.cookie 'logged', token
    else
      res.clearCookie 'logged'
    res.redirect '/'

  logout: ->
    @res.clearCookie 'logged'
    @res.redirect '/'
