module Web.View.Posts.Show where
import Web.View.Prelude
import qualified Text.MMark as MMark

data ShowView = ShowView { post :: Post }

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
            </div>
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Posts" PostsAction
                , breadcrumbText "Show Post"
                ]
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



renderMarkdown text =
    case text |> MMark.parse "" of
        Left _error   -> [hsx|<p class="text-danger">Could not render markdown</p>|]
        Right markdown -> MMark.render markdown |> tshow |> preEscapedToHtml

