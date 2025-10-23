module Web.View.Posts.Index where
import Web.View.Prelude

import qualified Text.MMark as MMark

data IndexView = IndexView { posts :: [Include "userId" Post] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}


        <h1>Ferrit<a href={pathTo NewPostAction} class="btn btn-primary ms-4 my-2">+ New</a></h1>
        <div class="table-responsive">
                {forEach posts renderPost}
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Posts" PostsAction
                ]

renderPost :: (Include "userId" Post) -> Html
renderPost post = [hsx|
    <div class="card mb-3 shadow-sm">
        <div class="card-body">
            <h5 class="card-title fw-bold">{post.title}</h5>

            <div class="mb-2">
                <span class="text-muted">Author: {post.userId.email}</span><br/>
                <span class="text-muted">Created: {post.createdAt |> timeAgo}</span>
            </div>

            <p class="card-text">{post.body |> renderMarkdown}</p>

            <div class="d-flex justify-content-end gap-3">
                <a href={ShowPostAction post.id} class="btn btn-sm btn-primary">Show</a>
                {renderButtons}
            </div>
        </div>
    </div>
|]
    where 
            renderButtons = if currentUserOrNothing == Just post.userId then
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


