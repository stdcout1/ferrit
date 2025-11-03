module Web.View.Comments.Edit where
import Web.View.Prelude

data EditView = EditView { comment :: Post }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Comment</h1>
        {renderForm comment}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Comments" CommentsAction
                , breadcrumbText "Edit Comment"
                ]

renderForm :: Post -> Html
renderForm comment = formFor comment [hsx|
    
    {submitButton}

|]
