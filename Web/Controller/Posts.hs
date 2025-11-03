module Web.Controller.Posts where

import Web.Controller.Prelude
import Web.View.Posts.Index
import Web.View.Posts.New
import Web.View.Posts.Edit
import Web.View.Posts.Show
import qualified Text.MMark as MMark

instance Controller PostsController where
    beforeAction = ensureIsUser
    action PostsAction = do
        posts <- query @Post 
              |> fetch 
              >>= collectionFetchRelated #userId 
              >>= collectionFetchRelated #upvotes
        render IndexView { .. }

    action NewPostAction = do
        let mParentId :: Maybe (Id Post) = paramOrNothing "parentId"
        case mParentId of
            Just pid -> do
                parentPost <- fetch pid
                let post = newRecord |> set #parentId mParentId 
                render NewView { post, parentPost = Just parentPost }
            Nothing -> do
                let post = newRecord @Post
                render NewView { post, parentPost = Nothing }

    action ShowPostAction { postId } = do
        post <- fetch postId
        allPosts <- query @Post |> fetch
        render ShowView { .. }

    action EditPostAction { postId } = do
        post <- fetch postId
        accessDeniedUnless (post.userId == currentUserId)
        render EditView { .. }

    action UpdatePostAction { postId } = do
        post <- fetch postId
        post
            |> buildPost
            |> ifValid \case
                Left post -> render EditView { .. }
                Right post -> do
                    post <- post |> updateRecord
                    setSuccessMessage "Post updated"
                    redirectTo EditPostAction { .. }

    action CreatePostAction = do
        let post = newRecord @Post
        post
            |> buildPost
            |> ifValid \case
                Left post -> do
                    parentPost <- case post.parentId of
                        Just pid -> Just <$> fetch pid
                        Nothing -> pure Nothing
                    render NewView { post, parentPost }
                Right post -> do
                    post <- post |> set #userId currentUser.id |> createRecord
                    setSuccessMessage "Post created"
                    redirectTo PostsAction

    action DeletePostAction { postId } = do
        post <- fetch postId
        deleteRecord post
        setSuccessMessage "Post deleted"
        redirectTo PostsAction

isMarkdown :: Text -> ValidatorResult
isMarkdown text =
    case MMark.parse "" text of
        Left _ -> Failure "Please provide valid Markdown"
        Right _ -> Success


buildPost post = post
    |> fill @'["title", "body", "parentId"]
    |> validateField #title nonEmpty
    |> validateField #body nonEmpty
    |> validateField #body isMarkdown

