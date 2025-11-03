module Web.Controller.Downvotes where
import Web.Controller.Prelude

instance Controller DownvotesController where
    beforeAction = ensureIsUser
    action DownvotePostAction { postId } = do
        let userId = currentUser.id

        existing <- query @Downvote
            |> filterWhere (#userId, userId)
            |> filterWhere (#postId, postId)
            |> fetchOneOrNothing

        case existing of
            Just up -> do
                deleteRecord up
                setSuccessMessage "Downvote removed"
            Nothing -> do
                newRecord @Downvote
                    |> set #userId userId
                    |> set #postId postId
                    |> createRecord
                setSuccessMessage "Downvoted"

        redirectTo ShowPostAction { postId }

    action CreateDownvoteAction  = do
        let downvote = newRecord @Downvote
        downvote
            |> buildDownvote
            |> ifValid \case
                Left downvote -> redirectTo PostsAction 
                Right downvote -> do
                    let userId = currentUser.id
                    existing <- query @Downvote
                        |> filterWhere (#userId, userId)
                        |> filterWhere (#postId, downvote.postId)
                        |> fetchOneOrNothing
                    case existing of
                        Just up -> do
                            deleteRecord up
                            setSuccessMessage "Downvote removed"
                            redirectTo PostsAction
                        Nothing -> do
                            downvote <- downvote |> set #userId currentUser.id |> createRecord
                            setSuccessMessage "Downvoted"
                            redirectTo PostsAction

buildDownvote downvote = downvote
    |> fill @'["postId"]


