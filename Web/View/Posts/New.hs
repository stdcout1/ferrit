module Web.View.Posts.New where
import Web.View.Prelude

data NewView = NewView { post :: Post, parentPost :: Maybe Post }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        {title}
        {renderForm post}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Posts" PostsAction
                , breadcrumbText "New Post"
                ]
            title = case parentPost of  
                        Just pid -> [hsx|<h1>New comment for <q> {pid.title} </q></h1>|] 
                        Nothing -> [hsx|<h1>New post</h1>|]

renderForm :: Post -> Html
renderForm post = formFor post [hsx|
    {(textField #parentId)}
    {(textField #title)}
    {(textareaField #body) { helpText = "You can use Markdown here"} }
    {submitButton}
|]
