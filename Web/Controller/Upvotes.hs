module Web.Controller.Upvotes where
import Web.Controller.Prelude

instance Controller UpvotesController where
    beforeAction = ensureIsUser
    action UpvotePostAction { postId } = do
        let userId = currentUser.id

        existing <- query @Upvote
            |> filterWhere (#userId, userId)
            |> filterWhere (#postId, postId)
            |> fetchOneOrNothing

        case existing of
            Just up -> do
                deleteRecord up
                setSuccessMessage "Upvote removed"
            Nothing -> do
                newRecord @Upvote
                    |> set #userId userId
                    |> set #postId postId
                    |> createRecord
                setSuccessMessage "Upvoted"

        redirectTo ShowPostAction { postId }

    action CreateUpvoteAction  = do
        let upvote = newRecord @Upvote
        upvote
            |> buildUpvote
            |> ifValid \case
                Left upvote -> redirectTo PostsAction 
                Right upvote -> do
                    let userId = currentUser.id
                    existing <- query @Upvote
                        |> filterWhere (#userId, userId)
                        |> filterWhere (#postId, upvote.postId)
                        |> fetchOneOrNothing
                    case existing of
                        Just up -> do
                            deleteRecord up
                            setSuccessMessage "Upvote removed"
                            redirectTo PostsAction
                        Nothing -> do
                            upvote <- upvote |> set #userId currentUser.id |> createRecord
                            setSuccessMessage "Upvoted"
                            redirectTo PostsAction

buildUpvote upvote = upvote
    |> fill @'["postId"]

