PRAGMA foreign_keys = ON;
DROP TABLE question_follows;
DROP TABLE question_likes;
DROP TABLE replies;
DROP TABLE questions; 
DROP TABLE users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL
);

CREATE TABLE question_follows (
    user_id INTEGER NOT NULL,
    questions_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (questions_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    subject_question INTEGER NOT NULL,
    parent_reply INTEGER,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (subject_question) REFERENCES questions(id),
    FOREIGN KEY (parent_reply) REFERENCES replies(id),
    FOREIGN KEY (author_id) REFERENCES users(id)

);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    subject_question INTEGER NOT NULL, 
    liker_id INTEGER NOT NULL,

    FOREIGN KEY (subject_question) REFERENCES questions(id),
    FOREIGN KEY (liker_id) REFERENCES users(id)
);


INSERT INTO users (fname, lname)
VALUES ('Steve', 'Paalz'),
    ('Charles', 'Cruse');

INSERT INTO questions (title, body, author_id)
VALUES ('I''m confused', 'how do we do this?', (SELECT id FROM users WHERE fname = 'Steve')),
    ('I''m also confused', 'whats going on?', (SELECT id FROM users WHERE fname = 'Charles')),
    ('Still need help', 'Why am I lost?', (SELECT id FROM users WHERE fname = 'Charles'));

INSERT INTO question_follows (user_id, questions_id)
VALUES ((SELECT id FROM users WHERE id IN (SELECT author_id FROM questions LIMIT 1)), (SELECT id FROM questions LIMIT 1)),
    ((SELECT id FROM users WHERE id IN (SELECT author_id FROM questions LIMIT 1 OFFSET 1)), (SELECT id FROM questions LIMIT 1 OFFSET 1)),
    ((SELECT id FROM users WHERE id IN (SELECT author_id FROM questions LIMIT 1 OFFSET 2)), (SELECT id FROM questions LIMIT 1 OFFSET 2));

INSERT INTO replies (subject_question, parent_reply, author_id, body)
VALUES (1, NULL, 2, 'I don''t know'),
    (1, 1, 1, 'Why not?');

INSERT INTO question_likes (subject_question, liker_id)
VALUES (2, 1);