module Web.FrontController where

import IHP.LoginSupport.Middleware
import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.Controller.Sessions
-- Controller Imports
import Web.Controller.Posts
import Web.Controller.Users
import Web.Controller.Static
import Web.View.Layout (defaultLayout)

instance FrontController WebApplication where
  controllers =
    [ startPage WelcomeAction,
      parseRoute @SessionsController
      -- Generator Marker
        , parseRoute @PostsController
        , parseRoute @UsersController
    ]

instance InitControllerContext WebApplication where
  initContext = do
    setLayout defaultLayout
    initAutoRefresh
    initAuthentication @User
