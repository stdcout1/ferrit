module Web.View.Posts.Show where
import Web.View.Prelude
import qualified Text.MMark as MMark

data ShowView = ShowView { post :: Post, allPosts :: [Post] }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}

        <div class="card shadow-sm my-4">
            <div class="card-body">
                <h1 class="card-title fw-bold">{post.title}</h1>

                <div class="d-flex justify-content-between text-muted mb-3">
                    <span>{post.createdAt |> timeAgo }</span>
                </div>
                <div class="card-text">
                    {post.body |> renderMarkdown}
                </div>
            </div>

            <div class="card-footer d-flex justify-content-end gap-3">
            {renderButtons}
            <a href={newPostPath} class="btn btn-md btn-secondary">Comment</a>

            </div>
        </div>
        {forEach (filter (\p -> p.parentId == Just post.id ) allPosts) (renderCommentTree allPosts)}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Posts" PostsAction
                , breadcrumbText "Show Post"
                ]
            newPostPath = pathTo NewPostAction <> "?parentId=" <> tshow post.id 
            renderButtons = 
                if (case currentUserOrNothing of 
                        Just curUser -> curUser.id == post.userId 
                        Nothing -> False
                    ) then
                        [hsx|
                            <a href={EditPostAction post.id} class="btn btn-sm btn-outline-secondary">Edit</a>
                            <a href={DeletePostAction post.id} class="btn btn-sm btn-outline-danger js-delete">Delete</a>
                        |]
                    else 
                        [hsx||]


renderCommentTree :: [Post] -> Post -> Html
renderCommentTree allPosts post = [hsx|
    <div class="card mb-3 border-0 shadow-sm bg-light">
        <div class="card-body">
            <div class="d-flex justify-content-between mb-2">
                <h6 class="text-muted mb-0">
                </h6>
                <small class="text-secondary">{timeAgo post.createdAt}</small>
            </div>
            <div class="card-text mb-2">
                {post.body |> renderMarkdown}
            </div>
            <a href={newPostPath} class="btn btn-sm btn-outline-secondary">
                Reply
            </a>
            <div class="ms-4 mt-3">
                {forEach (children post) (renderCommentTree allPosts)}
            </div>
        </div>
    </div>
|]
    where
        children p = filter (\child -> child.parentId == Just p.id) allPosts
        newPostPath = pathTo NewPostAction <> "?parentId=" <> tshow post.id 


renderMarkdown text =
    case text |> MMark.parse "" of
        Left _error   -> [hsx|<p class="text-danger">Could not render markdown</p>|]
        Right markdown -> MMark.render markdown |> tshow |> preEscapedToHtml

