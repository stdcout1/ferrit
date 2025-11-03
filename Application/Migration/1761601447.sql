ALTER TABLE posts ADD COLUMN comment_of UUID DEFAULT null;
ALTER TABLE posts ADD CONSTRAINT posts_ref_comment_of FOREIGN KEY (comment_of) REFERENCES posts (id) ON DELETE NO ACTION;
