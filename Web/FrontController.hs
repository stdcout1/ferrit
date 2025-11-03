module Web.FrontController where

import IHP.LoginSupport.Middleware
import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.Controller.Sessions
import Web.Controller.Upvotes
import Web.Controller.Downvotes
-- Controller Imports
import Web.Controller.Comments
import Web.Controller.Posts
import Web.Controller.Users
import Web.Controller.Static
import Web.View.Layout (defaultLayout)

instance FrontController WebApplication where
  controllers =
    [ startPage PostsAction,
      parseRoute @SessionsController
      -- Generator Marker
        , parseRoute @CommentsController
        , parseRoute @PostsController
        , parseRoute @UsersController
        , parseRoute @UpvotesController
        , parseRoute @DownvotesController
    ]

instance InitControllerContext WebApplication where
  initContext = do
    setLayout defaultLayout
    initAutoRefresh
    initAuthentication @User
