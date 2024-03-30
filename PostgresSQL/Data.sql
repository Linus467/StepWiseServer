-- Test data for User table
INSERT INTO "User" (user_id, firstname, lastname, email, creator, password_hash)
VALUES 
    ('123e4567-e89b-12d3-a456-426614174000'::uuid, 'John', 'Doe', 'john@example.com', true, 'password123'),
    ('223e4567-e89b-12d3-a456-426614174001'::uuid, 'Jane', 'Smith', 'jane@example.com', false, 'password456');

-- Test data for Tutorials table
INSERT INTO Tutorials (tutorial_id, title, tutorial_kind, user_id, time, difficulty, complete, description, preview_picture_link, preview_type, views, steps)
VALUES 
    ('123e4567-e89b-12d3-a456-426614174002'::uuid, 'Tutorial 1', 'Programming', '123e4567-e89b-12d3-a456-426614174000'::uuid, 60, 3, true, 'Description for Tutorial 1', 'http://example.com/image1.jpg', 'jpg', 100, 5),
    ('223e4567-e89b-12d3-a456-426614174003'::uuid, 'Tutorial 2', 'Cooking', '223e4567-e89b-12d3-a456-426614174001'::uuid, 45, 2, false, 'Description for Tutorial 2', 'http://example.com/image2.jpg', 'jpg', 50, 4);

-- Test data for Steps table
INSERT INTO Steps (step_id, tutorial_id, title)
VALUES 
    ('323e4567-e89b-12d3-a456-426614174008'::uuid, '123e4567-e89b-12d3-a456-426614174002'::uuid, 'Step 1 for Tutorial 1'),
    ('423e4567-e89b-12d3-a456-426614174009'::uuid, '123e4567-e89b-12d3-a456-426614174002'::uuid, 'Step 2 for Tutorial 1'),
    ('523e4567-e89b-12d3-a456-426614174010'::uuid, '223e4567-e89b-12d3-a456-426614174003'::uuid, 'Step 1 for Tutorial 2'),
    ('623e4567-e89b-12d3-a456-426614174011'::uuid, '223e4567-e89b-12d3-a456-426614174003'::uuid, 'Step 2 for Tutorial 2');

-- Test data for PictureContent table
INSERT INTO PictureContent (id, content_picture_link)
VALUES 
    ('f23e4567-e89b-12d3-a456-426614174020'::uuid, 'http://example.com/picture1.jpg'),
    ('g23e4567-e89b-12d3-a456-426614174021'::uuid, 'http://example.com/picture2.jpg'),
    ('h23e4567-e89b-12d3-a456-426614174022'::uuid, 'http://example.com/picture3.jpg'),
    ('i23e4567-e89b-12d3-a456-426614174023'::uuid, 'http://example.com/picture4.jpg');

-- Test data for TextContent table
INSERT INTO TextContent (id, content_text)
VALUES 
    ('b23e4567-e89b-12d3-a456-426614174016'::uuid, 'Text content for SubStep 1 of Tutorial 1'),
    ('c23e4567-e89b-12d3-a456-426614174017'::uuid, 'Text content for SubStep 2 of Tutorial 1'),
    ('d23e4567-e89b-12d3-a456-426614174018'::uuid, 'Text content for SubStep 1 of Tutorial 2'),
    ('e23e4567-e89b-12d3-a456-426614174019'::uuid, 'Text content for SubStep 2 of Tutorial 2');

-- Test data for VideoContent table
INSERT INTO VideoContent (id, content_video_link)
VALUES 
    ('j23e4567-e89b-12d3-a456-426614174024'::uuid, 'http://example.com/video1.mp4'),
    ('k23e4567-e89b-12d3-a456-426614174025'::uuid, 'http://example.com/video2.mp4'),
    ('l23e4567-e89b-12d3-a456-426614174026'::uuid, 'http://example.com/video3.mp4'),
    ('m23e4567-e89b-12d3-a456-426614174027'::uuid, 'http://example.com/video4.mp4');

-- Test data for SubSteps table
INSERT INTO SubSteps (sub_step_id, content_type, content_id)
VALUES 
    ('723e4567-e89b-12d3-a456-426614174012'::uuid, 1, 'b23e4567-e89b-12d3-a456-426614174016'::uuid),
    ('823e4567-e89b-12d3-a456-426614174013'::uuid, 2, 'c23e4567-e89b-12d3-a456-426614174017'::uuid),
    ('923e4567-e89b-12d3-a456-426614174014'::uuid, 1, 'd23e4567-e89b-12d3-a456-426614174018'::uuid),
    ('a23e4567-e89b-12d3-a456-426614174015'::uuid, 2, 'e23e4567-e89b-12d3-a456-426614174019'::uuid);

-- Test data for SubStepsList table
INSERT INTO SubStepsList (sub_step_list_id, sub_step_id, step_id)
VALUES 
    ('n23e4567-e89b-12d3-a456-426614174028'::uuid, '723e4567-e89b-12d3-a456-426614174012'::uuid, '323e4567-e89b-12d3-a456-426614174008'::uuid),
    ('o23e4567-e89b-12d3-a456-426614174029'::uuid, '823e4567-e89b-12d3-a456-426614174013'::uuid, '323e4567-e89b-12d3-a456-426614174008'::uuid),
    ('p23e4567-e89b-12d3-a456-426614174030'::uuid, '923e4567-e89b-12d3-a456-426614174014'::uuid, '423e4567-e89b-12d3-a456-426614174009'::uuid),
    ('q23e4567-e89b-12d3-a456-426614174031'::uuid, 'a23e4567-e89b-12d3-a456-426614174015'::uuid, '523e4567-e89b-12d3-a456-426614174010'::uuid);
