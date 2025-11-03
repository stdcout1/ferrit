ALTER TABLE posts RENAME COLUMN comment_of TO parent_id;
ALTER TABLE posts DROP CONSTRAINT posts_ref_comment_of;
ALTER TABLE posts ADD CONSTRAINT posts_ref_parent_id FOREIGN KEY (parent_id) REFERENCES posts (id) ON DELETE NO ACTION;
