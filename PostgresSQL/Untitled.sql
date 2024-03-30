-- Create the database
--DROP DATABASE IF EXISTS "StepWiseServer";

/*CREATE DATABASE "StepWiseServer"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    CONNECTION LIMIT = -1
    TEMPLATE = template0;*/
-- Create the User table

CREATE TABLE "User" (
    user_id UUID PRIMARY KEY,
    firstname VARCHAR(25),
    lastname VARCHAR(25),
    email VARCHAR(255),
    creator BOOLEAN,
    password_hash TEXT
);

-- Create the Tutorials table
CREATE TABLE Tutorials (
    tutorial_id UUID PRIMARY KEY,
    title VARCHAR(30),
    tutorial_kind VARCHAR(30),
    user_id UUID REFERENCES "User"(user_id),
    time SMALLINT,
    difficulty SMALLINT,
    complete BOOLEAN,
    description VARCHAR(2042),
    preview_picture_link VARCHAR(500),
    preview_type VARCHAR(20),
    views SMALLINT,
    steps SMALLINT
);

-- Create the Material table
CREATE TABLE Material (
    material_id UUID PRIMARY KEY,
    tutorial_id UUID REFERENCES Tutorials(tutorial_id),
    mat_title VARCHAR(20),
    mat_amount INTEGER,
    mat_price FLOAT,
    link VARCHAR(300)
);

-- Create the Tools table
CREATE TABLE Tools (
    tool_id UUID PRIMARY KEY,
    tutorial_id UUID REFERENCES Tutorials(tutorial_id),
    tool_title VARCHAR(20),
    tool_amount INTEGER,
    link VARCHAR(300)
);

-- Create the SubSteps table
CREATE TABLE SubSteps (
    sub_step_id UUID PRIMARY KEY,
    content_type SMALLINT,
    content_id UUID
);

-- Create the TutorialSearchLinks table
CREATE TABLE TutorialSearchLinks (
    search_link_id UUID PRIMARY KEY,
    tutorial_id UUID REFERENCES Tutorials(tutorial_id),
    name_link VARCHAR(30)
);

-- Create the Steps table
CREATE TABLE Steps (
    step_id UUID PRIMARY KEY,
    tutorial_id UUID REFERENCES Tutorials(tutorial_id),
    title VARCHAR(30)
);

-- Create the SubStepsList table
CREATE TABLE SubStepsList (
    sub_step_list_id UUID PRIMARY KEY,
    sub_step_id UUID REFERENCES SubSteps(sub_step_id),
    step_id UUID REFERENCES Steps(step_id)
);

-- Create the TextContent table
CREATE TABLE TextContent (
    id UUID PRIMARY KEY,
    content_text VARCHAR(2042)
);

-- Create the PictureContent table
CREATE TABLE PictureContent (
    id UUID PRIMARY KEY,
    content_picture_link VARCHAR(500)
);

-- Create the VideoContent table
CREATE TABLE VideoContent (
    id UUID PRIMARY KEY,
    content_video_link VARCHAR(500)
);

-- Create the UserComments table
CREATE TABLE UserComments (
    comment_id UUID PRIMARY KEY,
    step_id UUID REFERENCES Steps(step_id),
    user_id UUID REFERENCES "User"(user_id),
    text VARCHAR(2042)
);

-- Create the Watch_History table
CREATE TABLE Watch_History (
    history_id UUID PRIMARY KEY,
    tutorial_id UUID REFERENCES Tutorials(tutorial_id),
    user_id UUID REFERENCES "User"(user_id),
    last_watched_time TIMESTAMPTZ,
    completed_steps SMALLINT
);

-- Create the TutorialRating table
CREATE TABLE TutorialRating (
    rating_id UUID PRIMARY KEY,
    tutorial_id UUID REFERENCES Tutorials(tutorial_id),
    user_id UUID REFERENCES "User"(user_id),
    text VARCHAR(2042),
    rating SMALLINT
);

-- Create the FavouriteList table
CREATE TABLE FavouriteList (
    fav_id UUID PRIMARY KEY,
    tutorial_id UUID REFERENCES Tutorials(tutorial_id),
    user_id UUID REFERENCES "User"(user_id),
    date_time TIMESTAMPTZ
);

-- Create the Search_History table
CREATE TABLE Search_History (
    search_id UUID PRIMARY KEY,
    user_id UUID REFERENCES "User"(user_id),
    searched_text VARCHAR(40)
);
