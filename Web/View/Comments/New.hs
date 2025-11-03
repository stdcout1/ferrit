module Web.View.Comments.New where
import Web.View.Prelude

data NewView = NewView { comment :: Post }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Comment</h1>
        {renderForm comment}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Comments" CommentsAction
                , breadcrumbText "New Comment"
                ]

renderForm :: Post -> Html
renderForm comment = formFor comment [hsx|
    
    {submitButton}

|]
