co = require 'co'
jwt = require 'jsonwebtoken'

module.exports = (app) ->
  gen = (type) -> (route, method) ->
    app[type] route, (req, res) -> co ->
      obj = {req, res}
      view = yield Promise.resolve method.apply obj, [req, res]
      if typeof view == 'string'
        obj.view = view
        res.render view, obj


  get = gen 'get'
  post = gen 'post'
  put = gen 'put'
  remove = gen 'delete'

  resources = (Controller, route) ->
    get(route, Controller.index)
    post(route, Controller.create)
    get("#{route}/new", Controller.new)
    get("#{route}/edit", Controller.edit)
    get("#{route}/:id", Controller.show)
    put("#{route}/:id", Controller.update)
    remove("#{route}/:id", Controller.remove)

  insecure = (routes) ->
    app.use (req, res, next) ->
      if routes.find((e) -> e == req.path)
        next()
      else
        jwt.verify req.cookies.logged, 'martin', (e, user) ->
          if e
            res.redirect '/'
          else
            req.user = user
            next()

  return {get, post, put, remove, resources, insecure}
