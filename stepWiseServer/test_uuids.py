import re
import uuid

text = """
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
    ('82828722-b160-4f07-ae3e-703d2a890a8e'::uuid, 'http://example.com/picture2.jpg'),
    ('4027d432-3022-4ab3-8d28-366eddd5b67e'::uuid, 'http://example.com/picture3.jpg'),
    ('e7f60e25-8c5e-4c76-8935-3bed7fcd5b40'::uuid, 'http://example.com/picture4.jpg');

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
    ('c1d30dc0-a582-49d2-ae3d-5b66730b96bd'::uuid, 'http://example.com/video1.mp4'),
    ('dcaeafbe-e393-4dc0-987c-8ba25c22f598'::uuid, 'http://example.com/video2.mp4'),
    ('e4aec842-c2e6-4346-baa3-5d04def87dd2'::uuid, 'http://example.com/video3.mp4'),
    ('a8f2e976-6ac4-4cf7-96ab-f8bcd6f7c5fb'::uuid, 'http://example.com/video4.mp4');

-- Test data for SubSteps table
INSERT INTO SubSteps (sub_step_id, content_type, content_id)
VALUES 
    ('723e4567-e89b-12d3-a456-426614174012'::uuid, 1, 'b23e4567-e89b-12d3-a456-426614174016'::uuid),
    ('823e4567-e89b-12d3-a456-426614174013'::uuid, 1, 'c23e4567-e89b-12d3-a456-426614174017'::uuid),
    ('923e4567-e89b-12d3-a456-426614174014'::uuid, 1, 'd23e4567-e89b-12d3-a456-426614174018'::uuid),
    ('a23e4567-e89b-12d3-a456-426614174015'::uuid, 1, 'e23e4567-e89b-12d3-a456-426614174019'::uuid);

-- Test data for SubStepsList table
INSERT INTO SubStepsList (sub_step_list_id, sub_step_id, step_id)
VALUES 
    ('34179cb4-71c6-4398-af9d-3baea7871748'::uuid, '723e4567-e89b-12d3-a456-426614174012'::uuid, '323e4567-e89b-12d3-a456-426614174008'::uuid),
    ('8f2a2345-68ff-44cc-815d-228e5235b664'::uuid, '823e4567-e89b-12d3-a456-426614174013'::uuid, '323e4567-e89b-12d3-a456-426614174008'::uuid),
    ('d2a8a81e-70f3-4f51-ba24-e211f4f59fb5'::uuid, '923e4567-e89b-12d3-a456-426614174014'::uuid, '423e4567-e89b-12d3-a456-426614174009'::uuid),
    ('ddcc6d19-3b07-4401-9483-aa748159a0e9'::uuid, 'a23e4567-e89b-12d3-a456-426614174015'::uuid, '523e4567-e89b-12d3-a456-426614174010'::uuid);
--------------------------
-- Test data for UserComments table
INSERT INTO UserComments (comment_id, step_id, user_id, text)
VALUES 
    ('1ce2849f-01c5-4725-b2c2-99d4eeb9c196'::uuid, '323e4567-e89b-12d3-a456-426614174008'::uuid, '123e4567-e89b-12d3-a456-426614174000'::uuid, 'Comment 1 for Step 1 of Tutorial 1'),
    ('f0a504ae-9e2b-45d2-98d4-26a0222a01dc'::uuid, '323e4567-e89b-12d3-a456-426614174008'::uuid, '223e4567-e89b-12d3-a456-426614174001'::uuid, 'Comment 2 for Step 1 of Tutorial 1'),
    ('0625df14-7da5-4e4f-b722-8dc23526f89b'::uuid, '423e4567-e89b-12d3-a456-426614174009'::uuid, '123e4567-e89b-12d3-a456-426614174000'::uuid, 'Comment 1 for Step 2 of Tutorial 1'),
    ('c6eaa1f8-bbc5-4260-81e4-45dc1be8fd51'::uuid, '523e4567-e89b-12d3-a456-426614174010'::uuid, '223e4567-e89b-12d3-a456-426614174001'::uuid, 'Comment 1 for Step 1 of Tutorial 2');

-- Test data for Watch_History table
INSERT INTO Watch_History (history_id, tutorial_id, user_id, last_watched_time, completed_steps)
VALUES 
    ('1f03e07d-1011-4c6d-b52a-f4fd74a6bfb8'::uuid, '123e4567-e89b-12d3-a456-426614174002'::uuid, '123e4567-e89b-12d3-a456-426614174000'::uuid, NOW(), 5),
    ('5e0b92f7-b144-4d60-af4d-36391b4b2a08'::uuid, '223e4567-e89b-12d3-a456-426614174003'::uuid, '223e4567-e89b-12d3-a456-426614174001'::uuid, NOW(), 3);

-- Test data for TutorialRating table
INSERT INTO TutorialRating (rating_id, tutorial_id, user_id, text, rating)
VALUES 
    ('f1ffddcf-86f3-4d8d-a88e-4463693dabff'::uuid, '123e4567-e89b-12d3-a456-426614174002'::uuid, '123e4567-e89b-12d3-a456-426614174000'::uuid, 'Rating 5 for Tutorial 1', 5),
    ('7293aef2-5930-478b-9857-7f42cbab93b9'::uuid, '223e4567-e89b-12d3-a456-426614174003'::uuid, '223e4567-e89b-12d3-a456-426614174001'::uuid, 'Rating 4 for Tutorial 2', 4);

-- Test data for FavouriteList table
INSERT INTO FavouriteList (fav_id, tutorial_id, user_id, date_time)
VALUES 
    ('ac53f437-c714-40c3-b084-96aee87d9b77'::uuid, '123e4567-e89b-12d3-a456-426614174002'::uuid, '123e4567-e89b-12d3-a456-426614174000'::uuid, NOW()),
    ('0865fdd1-e760-459f-b4c5-4404f1d6ef49'::uuid, '223e4567-e89b-12d3-a456-426614174003'::uuid, '223e4567-e89b-12d3-a456-426614174001'::uuid, NOW());

-- Test data for Search_History table
INSERT INTO Search_History (search_id, user_id, searched_text)
VALUES 
    ('a7be93ee-1fc5-41fc-a97e-0d79ff0e654e'::uuid, '123e4567-e89b-12d3-a456-426614174000'::uuid, 'Python'),
    ('a0b86591-6e02-4657-961f-8300187a15bc'::uuid, '223e4567-e89b-12d3-a456-426614174001'::uuid, 'Cooking');
-- Test data for Material table
INSERT INTO Material (material_id, tutorial_id, mat_title, mat_amount, mat_price, link)
VALUES 
    ('9b880c0e-aa0d-4943-81b1-96a1beedf80a'::uuid, '123e4567-e89b-12d3-a456-426614174002'::uuid, 'Material 1 for', 2, 10.99, 'http://example.com/material1'),
    ('2eb0c9b4-bcb2-41e0-9d2f-0a2f80e78dd3'::uuid, '123e4567-e89b-12d3-a456-426614174002'::uuid, 'Material 2 for', 1, 5.99, 'http://example.com/material2'),
    ('e1f25cfd-55a9-4eeb-bf48-d22547d0288e'::uuid, '223e4567-e89b-12d3-a456-426614174003'::uuid, 'Material 1', 3, 7.99, 'http://example.com/material3');

-- Test data for Tools table
INSERT INTO Tools (tool_id, tutorial_id, tool_title, tool_amount, link)
VALUES 
    ('1e5f16d3-45b1-4096-9263-06de1e88cf59'::uuid, '123e4567-e89b-12d3-a456-426614174002'::uuid, 'Tool 1 for Tutorial 1', 1, 'http://example.com/tool1'),
    ('570dbca3-08a9-45ef-9e5d-9cf62273910b'::uuid, '123e4567-e89b-12d3-a456-426614174002'::uuid, 'Tool 2 for Tutorial 1', 2, 'http://example.com/tool2'),
    ('1e2f7257-5d46-47ee-80de-514d6a1b78c1'::uuid, '223e4567-e89b-12d3-a456-426614174003'::uuid, 'Tool 1 for Tutorial 2', 1, 'http://example.com/tool3');

commit;
-- -- Alter PictureContent table
-- ALTER TABLE PictureContent
--     ADD COLUMN content_id UUID REFERENCES SubSteps(sub_step_id) ON DELETE CASCADE;

-- -- Alter TextContent table
-- ALTER TABLE TextContent
--     ADD COLUMN content_id UUID REFERENCES SubSteps(sub_step_id) ON DELETE CASCADE;

-- -- Alter VideoContent table
-- ALTER TABLE VideoContent
--     ADD COLUMN content_id UUID REFERENCES SubSteps(sub_step_id) ON DELETE CASCADE;

"""

# Regular expression pattern to match UUIDs
uuid_pattern = re.compile(r"'\b([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})\b'::uuid")

# Find all UUID strings in the text
uuid_strings = uuid_pattern.findall(text)

valid_uuids = []
invalid_uuids = []

# Validate each found UUID
for u in uuid_strings:
    try:
        # Attempt to create a UUID object, which will validate the format
        val = uuid.UUID(u, version=4)
        valid_uuids.append(u)
    except ValueError:
        # If an error occurs, the UUID is invalid
        invalid_uuids.append(u)

print("Valid UUIDs:")
for v in valid_uuids:
    print(v)

if invalid_uuids:
    print("\nInvalid UUIDs:")
    for i in invalid_uuids:
        print(i)
else:
    print("\nAll found UUIDs are valid.")