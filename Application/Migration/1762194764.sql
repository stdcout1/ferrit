CREATE TABLE upvotes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    user_id UUID NOT NULL,
    post_id UUID NOT NULL,
    UNIQUE (user_id, post_id)
);
CREATE INDEX upvotes_user_id_index ON upvotes (user_id);
CREATE INDEX upvotes_post_id_index ON upvotes (post_id);
ALTER TABLE upvotes ADD CONSTRAINT upvotes_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE NO ACTION;
ALTER TABLE upvotes ADD CONSTRAINT upvotes_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
