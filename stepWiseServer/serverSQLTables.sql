CREATE TABLE "User" (
    user_id uuid PRIMARY KEY,
    firstname varchar(25),
    lastname varchar(25),
    email varchar(255),
    creator boolean,
    password_hash text
);

CREATE TABLE Material (
    material_id uuid PRIMARY KEY,
    tutorial_id uuid REFERENCES Tutorials(tutorial_id),
    mat_title varchar(20),
    mat_amount integer,
    mat_price float,
    link varchar(300)
);

CREATE TABLE Tools (
    tool_id uuid PRIMARY KEY,
    tutorial_id uuid REFERENCES Tutorials(tutorial_id),
    tool_title varchar(20),
    tool_amount integer,
    link varchar(300)
);

CREATE TABLE Tutorials (
    tutorial_id uuid PRIMARY KEY,
    title varchar(30),
    tutorial_kind varchar(30),
    user_id uuid REFERENCES "User"(user_id),
    time smallint,
    difficulty smallint,
    complete boolean,
    description varchar(2042),
    preview_picture_link varchar(500),
    preview_type varchar(20),
    views smallint,
    steps smallint
);

CREATE TABLE TutorialSearchLinks (
    search_link_id uuid PRIMARY KEY,
    tutorial_id uuid REFERENCES Tutorials(tutorial_id),
    name_link varchar(30)
);

CREATE TABLE Steps (
    step_id uuid PRIMARY KEY,
    tutorial_id uuid REFERENCES Tutorials(tutorial_id),
    title varchar(30)
);

CREATE TABLE SubStepsList (
    sub_step_list_id uuid PRIMARY KEY,
    sub_step_id uuid REFERENCES SubSteps(sub_step_id),
    step_id uuid REFERENCES Steps(step_id)
);

CREATE TABLE SubSteps (
    sub_step_id uuid PRIMARY KEY,
    content_type smallint,
    content_id uuid
);

CREATE TABLE TextContent (
    id uuid PRIMARY KEY,
    content_text varchar(2042)
);

CREATE TABLE PictureContent (
    id uuid PRIMARY KEY,
    content_picture_link varchar(500)
);

CREATE TABLE VideoContent (
    id uuid PRIMARY KEY,
    content_video_link varchar(500)
);

CREATE TABLE UserComments (
    comment_id uuid PRIMARY KEY,
    step_id uuid REFERENCES Steps(step_id),
    user_id uuid REFERENCES "User"(user_id),
    text varchar(2042)
);

CREATE TABLE Watch_History (
    history_id uuid PRIMARY KEY,
    tutorial_id uuid REFERENCES Tutorials(tutorial_id),
    user_id uuid REFERENCES "User"(user_id),
    last_watched_time timestamptz,
    completed_steps smallint
);

CREATE TABLE TutorialRating (
    rating_id uuid PRIMARY KEY,
    tutorial_id uuid REFERENCES Tutorials(tutorial_id),
    user_id uuid REFERENCES "User"(user_id),
    text varchar(2042),
    rating smallint
);

CREATE TABLE FavouriteList (
    fav_id uuid PRIMARY KEY,
    tutorial_id uuid REFERENCES Tutorials(tutorial_id),
    user_id uuid REFERENCES "User"(user_id),
    date_time timestamptz
);

CREATE TABLE Search_History (
    search_id uuid PRIMARY KEY,
    user_id uuid REFERENCES "User"(user_id),
    searched_text varchar(40)
);
