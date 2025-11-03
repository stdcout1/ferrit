CREATE TABLE downvotes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    user_id UUID NOT NULL,
    post_id UUID NOT NULL,
    UNIQUE(user_id, post_id)
);
CREATE INDEX downvotes_user_id_index ON downvotes (user_id);
CREATE INDEX downvotes_post_id_index ON downvotes (post_id);
ALTER TABLE downvotes ADD CONSTRAINT downvotes_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE NO ACTION;
ALTER TABLE downvotes ADD CONSTRAINT downvotes_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
