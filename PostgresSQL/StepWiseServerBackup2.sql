toc.dat                                                                                             0000600 0004000 0002000 00000055073 14606452272 0014461 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP   &    /    
            |           StepWiseServer    16.2    16.1 G    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         �           1262    16398    StepWiseServer    DATABASE     r   CREATE DATABASE "StepWiseServer" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';
     DROP DATABASE "StepWiseServer";
                postgres    false         �            1259    16463    User    TABLE     �   CREATE TABLE public."User" (
    user_id uuid NOT NULL,
    firstname character varying(25),
    lastname character varying(25),
    email character varying(255),
    creator boolean,
    password_hash text,
    session_key character varying(255)
);
    DROP TABLE public."User";
       public         heap    postgres    false         �            1259    16612    favouritelist    TABLE     �   CREATE TABLE public.favouritelist (
    fav_id uuid NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    date_time timestamp with time zone
);
 !   DROP TABLE public.favouritelist;
       public         heap    postgres    false         �            1259    16482    material    TABLE     �   CREATE TABLE public.material (
    material_id uuid NOT NULL,
    tutorial_id uuid,
    mat_title character varying(50),
    mat_amount integer,
    mat_price double precision,
    link character varying(300)
);
    DROP TABLE public.material;
       public         heap    postgres    false         �            1259    16549    picturecontent    TABLE     �   CREATE TABLE public.picturecontent (
    id uuid NOT NULL,
    content_picture_link character varying(500),
    content_id uuid
);
 "   DROP TABLE public.picturecontent;
       public         heap    postgres    false         �            1259    16627    search_history    TABLE        CREATE TABLE public.search_history (
    search_id uuid NOT NULL,
    user_id uuid,
    searched_text character varying(40)
);
 "   DROP TABLE public.search_history;
       public         heap    postgres    false         �            1259    16517    steps    TABLE     p   CREATE TABLE public.steps (
    step_id uuid NOT NULL,
    tutorial_id uuid,
    title character varying(30)
);
    DROP TABLE public.steps;
       public         heap    postgres    false         �            1259    16502    substeps    TABLE     p   CREATE TABLE public.substeps (
    sub_step_id uuid NOT NULL,
    content_type smallint,
    content_id uuid
);
    DROP TABLE public.substeps;
       public         heap    postgres    false         �            1259    16527    substepslist    TABLE     q   CREATE TABLE public.substepslist (
    sub_step_list_id uuid NOT NULL,
    sub_step_id uuid,
    step_id uuid
);
     DROP TABLE public.substepslist;
       public         heap    postgres    false         �            1259    16542    textcontent    TABLE     y   CREATE TABLE public.textcontent (
    id uuid NOT NULL,
    content_text character varying(2042),
    content_id uuid
);
    DROP TABLE public.textcontent;
       public         heap    postgres    false         �            1259    16492    tools    TABLE     �   CREATE TABLE public.tools (
    tool_id uuid NOT NULL,
    tutorial_id uuid,
    tool_title character varying(50),
    tool_amount integer,
    link character varying(300),
    tool_price double precision
);
    DROP TABLE public.tools;
       public         heap    postgres    false         �            1259    16595    tutorialrating    TABLE     �   CREATE TABLE public.tutorialrating (
    rating_id uuid NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    text character varying(2042),
    rating smallint
);
 "   DROP TABLE public.tutorialrating;
       public         heap    postgres    false         �            1259    16470 	   tutorials    TABLE     �  CREATE TABLE public.tutorials (
    tutorial_id uuid NOT NULL,
    title character varying(30),
    tutorial_kind character varying(30),
    user_id uuid,
    "time" smallint,
    difficulty smallint,
    complete boolean,
    description character varying(2042),
    preview_picture_link character varying(500),
    preview_type character varying(20),
    views smallint,
    steps smallint
);
    DROP TABLE public.tutorials;
       public         heap    postgres    false         �            1259    16507    tutorialsearchlinks    TABLE     �   CREATE TABLE public.tutorialsearchlinks (
    search_link_id uuid NOT NULL,
    tutorial_id uuid,
    name_link character varying(30)
);
 '   DROP TABLE public.tutorialsearchlinks;
       public         heap    postgres    false         �            1259    16563    usercomments    TABLE     �   CREATE TABLE public.usercomments (
    comment_id uuid NOT NULL,
    step_id uuid,
    user_id uuid,
    text character varying(2042)
);
     DROP TABLE public.usercomments;
       public         heap    postgres    false         �            1259    16556    videocontent    TABLE        CREATE TABLE public.videocontent (
    id uuid NOT NULL,
    content_video_link character varying(500),
    content_id uuid
);
     DROP TABLE public.videocontent;
       public         heap    postgres    false         �            1259    16580    watch_history    TABLE     �   CREATE TABLE public.watch_history (
    history_id uuid NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    last_watched_time timestamp with time zone,
    completed_steps smallint
);
 !   DROP TABLE public.watch_history;
       public         heap    postgres    false         p          0    16463    User 
   TABLE DATA           j   COPY public."User" (user_id, firstname, lastname, email, creator, password_hash, session_key) FROM stdin;
    public          postgres    false    215       3696.dat ~          0    16612    favouritelist 
   TABLE DATA           P   COPY public.favouritelist (fav_id, tutorial_id, user_id, date_time) FROM stdin;
    public          postgres    false    229       3710.dat r          0    16482    material 
   TABLE DATA           d   COPY public.material (material_id, tutorial_id, mat_title, mat_amount, mat_price, link) FROM stdin;
    public          postgres    false    217       3698.dat y          0    16549    picturecontent 
   TABLE DATA           N   COPY public.picturecontent (id, content_picture_link, content_id) FROM stdin;
    public          postgres    false    224       3705.dat           0    16627    search_history 
   TABLE DATA           K   COPY public.search_history (search_id, user_id, searched_text) FROM stdin;
    public          postgres    false    230       3711.dat v          0    16517    steps 
   TABLE DATA           <   COPY public.steps (step_id, tutorial_id, title) FROM stdin;
    public          postgres    false    221       3702.dat t          0    16502    substeps 
   TABLE DATA           I   COPY public.substeps (sub_step_id, content_type, content_id) FROM stdin;
    public          postgres    false    219       3700.dat w          0    16527    substepslist 
   TABLE DATA           N   COPY public.substepslist (sub_step_list_id, sub_step_id, step_id) FROM stdin;
    public          postgres    false    222       3703.dat x          0    16542    textcontent 
   TABLE DATA           C   COPY public.textcontent (id, content_text, content_id) FROM stdin;
    public          postgres    false    223       3704.dat s          0    16492    tools 
   TABLE DATA           `   COPY public.tools (tool_id, tutorial_id, tool_title, tool_amount, link, tool_price) FROM stdin;
    public          postgres    false    218       3699.dat }          0    16595    tutorialrating 
   TABLE DATA           W   COPY public.tutorialrating (rating_id, tutorial_id, user_id, text, rating) FROM stdin;
    public          postgres    false    228       3709.dat q          0    16470 	   tutorials 
   TABLE DATA           �   COPY public.tutorials (tutorial_id, title, tutorial_kind, user_id, "time", difficulty, complete, description, preview_picture_link, preview_type, views, steps) FROM stdin;
    public          postgres    false    216       3697.dat u          0    16507    tutorialsearchlinks 
   TABLE DATA           U   COPY public.tutorialsearchlinks (search_link_id, tutorial_id, name_link) FROM stdin;
    public          postgres    false    220       3701.dat {          0    16563    usercomments 
   TABLE DATA           J   COPY public.usercomments (comment_id, step_id, user_id, text) FROM stdin;
    public          postgres    false    226       3707.dat z          0    16556    videocontent 
   TABLE DATA           J   COPY public.videocontent (id, content_video_link, content_id) FROM stdin;
    public          postgres    false    225       3706.dat |          0    16580    watch_history 
   TABLE DATA           m   COPY public.watch_history (history_id, tutorial_id, user_id, last_watched_time, completed_steps) FROM stdin;
    public          postgres    false    227       3708.dat �           2606    16469    User User_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (user_id);
 <   ALTER TABLE ONLY public."User" DROP CONSTRAINT "User_pkey";
       public            postgres    false    215         �           2606    16616     favouritelist favouritelist_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_pkey PRIMARY KEY (fav_id);
 J   ALTER TABLE ONLY public.favouritelist DROP CONSTRAINT favouritelist_pkey;
       public            postgres    false    229         �           2606    16486    material material_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_pkey PRIMARY KEY (material_id);
 @   ALTER TABLE ONLY public.material DROP CONSTRAINT material_pkey;
       public            postgres    false    217         �           2606    16555 "   picturecontent picturecontent_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.picturecontent
    ADD CONSTRAINT picturecontent_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.picturecontent DROP CONSTRAINT picturecontent_pkey;
       public            postgres    false    224         �           2606    16631 "   search_history search_history_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.search_history
    ADD CONSTRAINT search_history_pkey PRIMARY KEY (search_id);
 L   ALTER TABLE ONLY public.search_history DROP CONSTRAINT search_history_pkey;
       public            postgres    false    230         �           2606    16521    steps steps_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_pkey PRIMARY KEY (step_id);
 :   ALTER TABLE ONLY public.steps DROP CONSTRAINT steps_pkey;
       public            postgres    false    221         �           2606    16506    substeps substeps_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.substeps
    ADD CONSTRAINT substeps_pkey PRIMARY KEY (sub_step_id);
 @   ALTER TABLE ONLY public.substeps DROP CONSTRAINT substeps_pkey;
       public            postgres    false    219         �           2606    16531    substepslist substepslist_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_pkey PRIMARY KEY (sub_step_list_id);
 H   ALTER TABLE ONLY public.substepslist DROP CONSTRAINT substepslist_pkey;
       public            postgres    false    222         �           2606    16548    textcontent textcontent_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.textcontent
    ADD CONSTRAINT textcontent_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.textcontent DROP CONSTRAINT textcontent_pkey;
       public            postgres    false    223         �           2606    16496    tools tools_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (tool_id);
 :   ALTER TABLE ONLY public.tools DROP CONSTRAINT tools_pkey;
       public            postgres    false    218         �           2606    16601 "   tutorialrating tutorialrating_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_pkey PRIMARY KEY (rating_id);
 L   ALTER TABLE ONLY public.tutorialrating DROP CONSTRAINT tutorialrating_pkey;
       public            postgres    false    228         �           2606    16476    tutorials tutorials_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.tutorials
    ADD CONSTRAINT tutorials_pkey PRIMARY KEY (tutorial_id);
 B   ALTER TABLE ONLY public.tutorials DROP CONSTRAINT tutorials_pkey;
       public            postgres    false    216         �           2606    16511 ,   tutorialsearchlinks tutorialsearchlinks_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.tutorialsearchlinks
    ADD CONSTRAINT tutorialsearchlinks_pkey PRIMARY KEY (search_link_id);
 V   ALTER TABLE ONLY public.tutorialsearchlinks DROP CONSTRAINT tutorialsearchlinks_pkey;
       public            postgres    false    220         �           2606    16569    usercomments usercomments_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_pkey PRIMARY KEY (comment_id);
 H   ALTER TABLE ONLY public.usercomments DROP CONSTRAINT usercomments_pkey;
       public            postgres    false    226         �           2606    16562    videocontent videocontent_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.videocontent
    ADD CONSTRAINT videocontent_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.videocontent DROP CONSTRAINT videocontent_pkey;
       public            postgres    false    225         �           2606    16584     watch_history watch_history_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_pkey PRIMARY KEY (history_id);
 J   ALTER TABLE ONLY public.watch_history DROP CONSTRAINT watch_history_pkey;
       public            postgres    false    227         �           2606    16617 ,   favouritelist favouritelist_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 V   ALTER TABLE ONLY public.favouritelist DROP CONSTRAINT favouritelist_tutorial_id_fkey;
       public          postgres    false    216    3505    229         �           2606    16622 (   favouritelist favouritelist_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 R   ALTER TABLE ONLY public.favouritelist DROP CONSTRAINT favouritelist_user_id_fkey;
       public          postgres    false    215    3503    229         �           2606    16487 "   material material_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 L   ALTER TABLE ONLY public.material DROP CONSTRAINT material_tutorial_id_fkey;
       public          postgres    false    216    217    3505         �           2606    16652 -   picturecontent picturecontent_content_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.picturecontent
    ADD CONSTRAINT picturecontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.picturecontent DROP CONSTRAINT picturecontent_content_id_fkey;
       public          postgres    false    3511    224    219         �           2606    16632 *   search_history search_history_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.search_history
    ADD CONSTRAINT search_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 T   ALTER TABLE ONLY public.search_history DROP CONSTRAINT search_history_user_id_fkey;
       public          postgres    false    230    215    3503         �           2606    16522    steps steps_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 F   ALTER TABLE ONLY public.steps DROP CONSTRAINT steps_tutorial_id_fkey;
       public          postgres    false    221    216    3505         �           2606    16537 &   substepslist substepslist_step_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_step_id_fkey FOREIGN KEY (step_id) REFERENCES public.steps(step_id);
 P   ALTER TABLE ONLY public.substepslist DROP CONSTRAINT substepslist_step_id_fkey;
       public          postgres    false    222    3515    221         �           2606    16532 *   substepslist substepslist_sub_step_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_sub_step_id_fkey FOREIGN KEY (sub_step_id) REFERENCES public.substeps(sub_step_id);
 T   ALTER TABLE ONLY public.substepslist DROP CONSTRAINT substepslist_sub_step_id_fkey;
       public          postgres    false    3511    222    219         �           2606    16657 '   textcontent textcontent_content_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.textcontent
    ADD CONSTRAINT textcontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.textcontent DROP CONSTRAINT textcontent_content_id_fkey;
       public          postgres    false    223    219    3511         �           2606    16497    tools tools_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 F   ALTER TABLE ONLY public.tools DROP CONSTRAINT tools_tutorial_id_fkey;
       public          postgres    false    218    216    3505         �           2606    16602 .   tutorialrating tutorialrating_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 X   ALTER TABLE ONLY public.tutorialrating DROP CONSTRAINT tutorialrating_tutorial_id_fkey;
       public          postgres    false    228    3505    216         �           2606    16607 *   tutorialrating tutorialrating_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 T   ALTER TABLE ONLY public.tutorialrating DROP CONSTRAINT tutorialrating_user_id_fkey;
       public          postgres    false    3503    228    215         �           2606    16477     tutorials tutorials_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tutorials
    ADD CONSTRAINT tutorials_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 J   ALTER TABLE ONLY public.tutorials DROP CONSTRAINT tutorials_user_id_fkey;
       public          postgres    false    216    215    3503         �           2606    16512 8   tutorialsearchlinks tutorialsearchlinks_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tutorialsearchlinks
    ADD CONSTRAINT tutorialsearchlinks_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 b   ALTER TABLE ONLY public.tutorialsearchlinks DROP CONSTRAINT tutorialsearchlinks_tutorial_id_fkey;
       public          postgres    false    216    220    3505         �           2606    16570 &   usercomments usercomments_step_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_step_id_fkey FOREIGN KEY (step_id) REFERENCES public.steps(step_id);
 P   ALTER TABLE ONLY public.usercomments DROP CONSTRAINT usercomments_step_id_fkey;
       public          postgres    false    226    3515    221         �           2606    16575 &   usercomments usercomments_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 P   ALTER TABLE ONLY public.usercomments DROP CONSTRAINT usercomments_user_id_fkey;
       public          postgres    false    3503    215    226         �           2606    16662 )   videocontent videocontent_content_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.videocontent
    ADD CONSTRAINT videocontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.videocontent DROP CONSTRAINT videocontent_content_id_fkey;
       public          postgres    false    3511    219    225         �           2606    16585 ,   watch_history watch_history_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 V   ALTER TABLE ONLY public.watch_history DROP CONSTRAINT watch_history_tutorial_id_fkey;
       public          postgres    false    216    227    3505         �           2606    16590 (   watch_history watch_history_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 R   ALTER TABLE ONLY public.watch_history DROP CONSTRAINT watch_history_user_id_fkey;
       public          postgres    false    215    227    3503                                                                                                                                                                                                                                                                                                                                                                                                                                                                             3696.dat                                                                                            0000600 0004000 0002000 00000001170 14606452272 0014270 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        123e4567-e89b-12d3-a456-426614174000	John	Doe	john@example.com	t	password123	\N
223e4567-e89b-12d3-a456-426614174001	Jane	Smith	jane@example.com	f	password456	\N
03275be5-9481-4895-ae9b-d1b7927d4812	New	User	newuser@example.com	f	scrypt:32768:8:1$H5mGnheIH8mDxxyq$96cc6f1333aa6cf2da419a3c2dc88f7f7c602a9be1d51aada2cb8ce87b71430d14b65d5013941355266b166a190cd8694d9bc70bd76cdb5ff493301cf062ffac	\N
6fb660c3-c310-45c4-bf4a-b9532d917b1d	New	User	test@example.com	f	scrypt:32768:8:1$NpZJpXbKThmB62td$76983a754be5ed50b8de17498afafcc5e0eca9d8a070bb931d4ad69e788b1e9efa7b8052dfdb7f8e6506b2816a3d453953c73d3675b215ccad579972a4b0b4e0	\N
\.


                                                                                                                                                                                                                                                                                                                                                                                                        3710.dat                                                                                            0000600 0004000 0002000 00000000437 14606452272 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        ac53f437-c714-40c3-b084-96aee87d9b77	123e4567-e89b-12d3-a456-426614174002	123e4567-e89b-12d3-a456-426614174000	2024-03-30 14:51:39.474617+01
0865fdd1-e760-459f-b4c5-4404f1d6ef49	223e4567-e89b-12d3-a456-426614174003	223e4567-e89b-12d3-a456-426614174001	2024-03-30 14:51:39.474617+01
\.


                                                                                                                                                                                                                                 3698.dat                                                                                            0000600 0004000 0002000 00000000571 14606452272 0014276 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        9b880c0e-aa0d-4943-81b1-96a1beedf80a	123e4567-e89b-12d3-a456-426614174002	Material 1 for	2	10.99	http://example.com/material1
2eb0c9b4-bcb2-41e0-9d2f-0a2f80e78dd3	123e4567-e89b-12d3-a456-426614174002	Material 2 for	1	5.99	http://example.com/material2
e1f25cfd-55a9-4eeb-bf48-d22547d0288e	223e4567-e89b-12d3-a456-426614174003	Material 1	3	7.99	http://example.com/material3
\.


                                                                                                                                       3705.dat                                                                                            0000600 0004000 0002000 00000000665 14606452272 0014267 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        f23e4567-e89b-12d3-a456-426614174020	http://example.com/picture1.jpg	\N
82828722-b160-4f07-ae3e-703d2a890a8e	http://example.com/picture2.jpg	\N
4027d432-3022-4ab3-8d28-366eddd5b67e	http://example.com/picture3.jpg	\N
e7f60e25-8c5e-4c76-8935-3bed7fcd5b40	http://example.com/picture4.jpg	\N
f23e4567-e89b-12d3-a456-426614174036	http://example.com/picture5.jpg	\N
f23e4567-e89b-12d3-a456-426614174037	http://example.com/picture6.jpg	\N
\.


                                                                           3711.dat                                                                                            0000600 0004000 0002000 00000000250 14606452272 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        a7be93ee-1fc5-41fc-a97e-0d79ff0e654e	123e4567-e89b-12d3-a456-426614174000	Python
a0b86591-6e02-4657-961f-8300187a15bc	223e4567-e89b-12d3-a456-426614174001	Cooking
\.


                                                                                                                                                                                                                                                                                                                                                        3702.dat                                                                                            0000600 0004000 0002000 00000001105 14606452272 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        323e4567-e89b-12d3-a456-426614174008	123e4567-e89b-12d3-a456-426614174002	Step 1 for Tutorial 1
423e4567-e89b-12d3-a456-426614174009	123e4567-e89b-12d3-a456-426614174002	Step 2 for Tutorial 1
523e4567-e89b-12d3-a456-426614174010	223e4567-e89b-12d3-a456-426614174003	Step 1 for Tutorial 2
623e4567-e89b-12d3-a456-426614174011	223e4567-e89b-12d3-a456-426614174003	Step 2 for Tutorial 2
823e4567-e89b-12d3-a456-426614174032	123e4567-e89b-12d3-a456-426614174002	Step 3 for Tutorial 1
923e4567-e89b-12d3-a456-426614174033	123e4567-e89b-12d3-a456-426614174002	Step 4 for Tutorial 1
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                           3700.dat                                                                                            0000600 0004000 0002000 00000001145 14606452272 0014254 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        723e4567-e89b-12d3-a456-426614174012	1	b23e4567-e89b-12d3-a456-426614174016
923e4567-e89b-12d3-a456-426614174014	1	d23e4567-e89b-12d3-a456-426614174018
823e4567-e89b-12d3-a456-426614174013	1	c23e4567-e89b-12d3-a456-426614174017
a23e4567-e89b-12d3-a456-426614174015	1	e23e4567-e89b-12d3-a456-426614174019
b23e4567-e89b-12d3-a456-426614174038	1	d23e4567-e89b-12d3-a456-426614174034
b23e4567-e89b-12d3-a456-426614174039	2	f23e4567-e89b-12d3-a456-426614174036
c23e4567-e89b-12d3-a456-426614174040	1	d23e4567-e89b-12d3-a456-426614174035
c23e4567-e89b-12d3-a456-426614174041	2	f23e4567-e89b-12d3-a456-426614174037
\.


                                                                                                                                                                                                                                                                                                                                                                                                                           3703.dat                                                                                            0000600 0004000 0002000 00000001575 14606452272 0014266 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        34179cb4-71c6-4398-af9d-3baea7871748	723e4567-e89b-12d3-a456-426614174012	323e4567-e89b-12d3-a456-426614174008
8f2a2345-68ff-44cc-815d-228e5235b664	823e4567-e89b-12d3-a456-426614174013	323e4567-e89b-12d3-a456-426614174008
d2a8a81e-70f3-4f51-ba24-e211f4f59fb5	923e4567-e89b-12d3-a456-426614174014	423e4567-e89b-12d3-a456-426614174009
ddcc6d19-3b07-4401-9483-aa748159a0e9	a23e4567-e89b-12d3-a456-426614174015	523e4567-e89b-12d3-a456-426614174010
9a0f4f41-312b-41d6-95ee-4868726a245a	b23e4567-e89b-12d3-a456-426614174038	823e4567-e89b-12d3-a456-426614174032
43823a3d-c1c8-4ebd-81ba-248a72ee3da5	b23e4567-e89b-12d3-a456-426614174039	823e4567-e89b-12d3-a456-426614174032
a09f6f3c-a230-4dca-9427-44d7f44e962b	c23e4567-e89b-12d3-a456-426614174040	923e4567-e89b-12d3-a456-426614174033
64e2d967-913b-43a1-90b2-2560c180736b	c23e4567-e89b-12d3-a456-426614174041	923e4567-e89b-12d3-a456-426614174033
\.


                                                                                                                                   3704.dat                                                                                            0000600 0004000 0002000 00000001001 14606452272 0014247 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        b23e4567-e89b-12d3-a456-426614174016	Text content for SubStep 1 of Tutorial 1	\N
c23e4567-e89b-12d3-a456-426614174017	Text content for SubStep 2 of Tutorial 1	\N
d23e4567-e89b-12d3-a456-426614174018	Text content for SubStep 1 of Tutorial 2	\N
e23e4567-e89b-12d3-a456-426614174019	Text content for SubStep 2 of Tutorial 2	\N
d23e4567-e89b-12d3-a456-426614174034	Text content for SubStep 1 of Step 3 for Tutorial 1	\N
d23e4567-e89b-12d3-a456-426614174035	Text content for SubStep 1 of Step 4 for Tutorial 1	\N
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               3699.dat                                                                                            0000600 0004000 0002000 00000000577 14606452272 0014305 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1e5f16d3-45b1-4096-9263-06de1e88cf59	123e4567-e89b-12d3-a456-426614174002	Tool 1 for Tutorial 1	1	http://example.com/tool1	\N
570dbca3-08a9-45ef-9e5d-9cf62273910b	123e4567-e89b-12d3-a456-426614174002	Tool 2 for Tutorial 1	2	http://example.com/tool2	\N
1e2f7257-5d46-47ee-80de-514d6a1b78c1	223e4567-e89b-12d3-a456-426614174003	Tool 1 for Tutorial 2	1	http://example.com/tool3	\N
\.


                                                                                                                                 3709.dat                                                                                            0000600 0004000 0002000 00000000427 14606452272 0014267 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        f1ffddcf-86f3-4d8d-a88e-4463693dabff	123e4567-e89b-12d3-a456-426614174002	123e4567-e89b-12d3-a456-426614174000	Rating 5 for Tutorial 1	5
7293aef2-5930-478b-9857-7f42cbab93b9	223e4567-e89b-12d3-a456-426614174003	223e4567-e89b-12d3-a456-426614174001	Rating 4 for Tutorial 2	4
\.


                                                                                                                                                                                                                                         3697.dat                                                                                            0000600 0004000 0002000 00000000532 14606452272 0014272 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        123e4567-e89b-12d3-a456-426614174002	Tutorial 1	Programming	123e4567-e89b-12d3-a456-426614174000	60	3	t	Description for Tutorial 1	http://example.com/image1.jpg	Image	100	5
223e4567-e89b-12d3-a456-426614174003	Tutorial 2	Cooking	223e4567-e89b-12d3-a456-426614174001	45	2	f	Description for Tutorial 2	http://example.com/image2.jpg	Image	50	4
\.


                                                                                                                                                                      3701.dat                                                                                            0000600 0004000 0002000 00000000005 14606452272 0014247 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3707.dat                                                                                            0000600 0004000 0002000 00000001115 14606452272 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1ce2849f-01c5-4725-b2c2-99d4eeb9c196	323e4567-e89b-12d3-a456-426614174008	123e4567-e89b-12d3-a456-426614174000	Comment 1 for Step 1 of Tutorial 1
f0a504ae-9e2b-45d2-98d4-26a0222a01dc	323e4567-e89b-12d3-a456-426614174008	223e4567-e89b-12d3-a456-426614174001	Comment 2 for Step 1 of Tutorial 1
0625df14-7da5-4e4f-b722-8dc23526f89b	423e4567-e89b-12d3-a456-426614174009	123e4567-e89b-12d3-a456-426614174000	Comment 1 for Step 2 of Tutorial 1
c6eaa1f8-bbc5-4260-81e4-45dc1be8fd51	523e4567-e89b-12d3-a456-426614174010	223e4567-e89b-12d3-a456-426614174001	Comment 1 for Step 1 of Tutorial 2
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                   3706.dat                                                                                            0000600 0004000 0002000 00000000435 14606452272 0014263 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        c1d30dc0-a582-49d2-ae3d-5b66730b96bd	http://example.com/video1.mp4	\N
dcaeafbe-e393-4dc0-987c-8ba25c22f598	http://example.com/video2.mp4	\N
e4aec842-c2e6-4346-baa3-5d04def87dd2	http://example.com/video3.mp4	\N
a8f2e976-6ac4-4cf7-96ab-f8bcd6f7c5fb	http://example.com/video4.mp4	\N
\.


                                                                                                                                                                                                                                   3708.dat                                                                                            0000600 0004000 0002000 00000000443 14606452272 0014264 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1f03e07d-1011-4c6d-b52a-f4fd74a6bfb8	123e4567-e89b-12d3-a456-426614174002	123e4567-e89b-12d3-a456-426614174000	2024-03-30 14:51:39.474617+01	5
5e0b92f7-b144-4d60-af4d-36391b4b2a08	223e4567-e89b-12d3-a456-426614174003	223e4567-e89b-12d3-a456-426614174001	2024-03-30 14:51:39.474617+01	3
\.


                                                                                                                                                                                                                             restore.sql                                                                                         0000600 0004000 0002000 00000044360 14606452272 0015403 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE "StepWiseServer";
--
-- Name: StepWiseServer; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "StepWiseServer" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';


ALTER DATABASE "StepWiseServer" OWNER TO postgres;

\connect "StepWiseServer"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    user_id uuid NOT NULL,
    firstname character varying(25),
    lastname character varying(25),
    email character varying(255),
    creator boolean,
    password_hash text,
    session_key character varying(255)
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: favouritelist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.favouritelist (
    fav_id uuid NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    date_time timestamp with time zone
);


ALTER TABLE public.favouritelist OWNER TO postgres;

--
-- Name: material; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.material (
    material_id uuid NOT NULL,
    tutorial_id uuid,
    mat_title character varying(50),
    mat_amount integer,
    mat_price double precision,
    link character varying(300)
);


ALTER TABLE public.material OWNER TO postgres;

--
-- Name: picturecontent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.picturecontent (
    id uuid NOT NULL,
    content_picture_link character varying(500),
    content_id uuid
);


ALTER TABLE public.picturecontent OWNER TO postgres;

--
-- Name: search_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.search_history (
    search_id uuid NOT NULL,
    user_id uuid,
    searched_text character varying(40)
);


ALTER TABLE public.search_history OWNER TO postgres;

--
-- Name: steps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.steps (
    step_id uuid NOT NULL,
    tutorial_id uuid,
    title character varying(30)
);


ALTER TABLE public.steps OWNER TO postgres;

--
-- Name: substeps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.substeps (
    sub_step_id uuid NOT NULL,
    content_type smallint,
    content_id uuid
);


ALTER TABLE public.substeps OWNER TO postgres;

--
-- Name: substepslist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.substepslist (
    sub_step_list_id uuid NOT NULL,
    sub_step_id uuid,
    step_id uuid
);


ALTER TABLE public.substepslist OWNER TO postgres;

--
-- Name: textcontent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.textcontent (
    id uuid NOT NULL,
    content_text character varying(2042),
    content_id uuid
);


ALTER TABLE public.textcontent OWNER TO postgres;

--
-- Name: tools; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tools (
    tool_id uuid NOT NULL,
    tutorial_id uuid,
    tool_title character varying(50),
    tool_amount integer,
    link character varying(300),
    tool_price double precision
);


ALTER TABLE public.tools OWNER TO postgres;

--
-- Name: tutorialrating; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tutorialrating (
    rating_id uuid NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    text character varying(2042),
    rating smallint
);


ALTER TABLE public.tutorialrating OWNER TO postgres;

--
-- Name: tutorials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tutorials (
    tutorial_id uuid NOT NULL,
    title character varying(30),
    tutorial_kind character varying(30),
    user_id uuid,
    "time" smallint,
    difficulty smallint,
    complete boolean,
    description character varying(2042),
    preview_picture_link character varying(500),
    preview_type character varying(20),
    views smallint,
    steps smallint
);


ALTER TABLE public.tutorials OWNER TO postgres;

--
-- Name: tutorialsearchlinks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tutorialsearchlinks (
    search_link_id uuid NOT NULL,
    tutorial_id uuid,
    name_link character varying(30)
);


ALTER TABLE public.tutorialsearchlinks OWNER TO postgres;

--
-- Name: usercomments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usercomments (
    comment_id uuid NOT NULL,
    step_id uuid,
    user_id uuid,
    text character varying(2042)
);


ALTER TABLE public.usercomments OWNER TO postgres;

--
-- Name: videocontent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.videocontent (
    id uuid NOT NULL,
    content_video_link character varying(500),
    content_id uuid
);


ALTER TABLE public.videocontent OWNER TO postgres;

--
-- Name: watch_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.watch_history (
    history_id uuid NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    last_watched_time timestamp with time zone,
    completed_steps smallint
);


ALTER TABLE public.watch_history OWNER TO postgres;

--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (user_id, firstname, lastname, email, creator, password_hash, session_key) FROM stdin;
\.
COPY public."User" (user_id, firstname, lastname, email, creator, password_hash, session_key) FROM '$$PATH$$/3696.dat';

--
-- Data for Name: favouritelist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favouritelist (fav_id, tutorial_id, user_id, date_time) FROM stdin;
\.
COPY public.favouritelist (fav_id, tutorial_id, user_id, date_time) FROM '$$PATH$$/3710.dat';

--
-- Data for Name: material; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.material (material_id, tutorial_id, mat_title, mat_amount, mat_price, link) FROM stdin;
\.
COPY public.material (material_id, tutorial_id, mat_title, mat_amount, mat_price, link) FROM '$$PATH$$/3698.dat';

--
-- Data for Name: picturecontent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.picturecontent (id, content_picture_link, content_id) FROM stdin;
\.
COPY public.picturecontent (id, content_picture_link, content_id) FROM '$$PATH$$/3705.dat';

--
-- Data for Name: search_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.search_history (search_id, user_id, searched_text) FROM stdin;
\.
COPY public.search_history (search_id, user_id, searched_text) FROM '$$PATH$$/3711.dat';

--
-- Data for Name: steps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.steps (step_id, tutorial_id, title) FROM stdin;
\.
COPY public.steps (step_id, tutorial_id, title) FROM '$$PATH$$/3702.dat';

--
-- Data for Name: substeps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.substeps (sub_step_id, content_type, content_id) FROM stdin;
\.
COPY public.substeps (sub_step_id, content_type, content_id) FROM '$$PATH$$/3700.dat';

--
-- Data for Name: substepslist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.substepslist (sub_step_list_id, sub_step_id, step_id) FROM stdin;
\.
COPY public.substepslist (sub_step_list_id, sub_step_id, step_id) FROM '$$PATH$$/3703.dat';

--
-- Data for Name: textcontent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.textcontent (id, content_text, content_id) FROM stdin;
\.
COPY public.textcontent (id, content_text, content_id) FROM '$$PATH$$/3704.dat';

--
-- Data for Name: tools; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tools (tool_id, tutorial_id, tool_title, tool_amount, link, tool_price) FROM stdin;
\.
COPY public.tools (tool_id, tutorial_id, tool_title, tool_amount, link, tool_price) FROM '$$PATH$$/3699.dat';

--
-- Data for Name: tutorialrating; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tutorialrating (rating_id, tutorial_id, user_id, text, rating) FROM stdin;
\.
COPY public.tutorialrating (rating_id, tutorial_id, user_id, text, rating) FROM '$$PATH$$/3709.dat';

--
-- Data for Name: tutorials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tutorials (tutorial_id, title, tutorial_kind, user_id, "time", difficulty, complete, description, preview_picture_link, preview_type, views, steps) FROM stdin;
\.
COPY public.tutorials (tutorial_id, title, tutorial_kind, user_id, "time", difficulty, complete, description, preview_picture_link, preview_type, views, steps) FROM '$$PATH$$/3697.dat';

--
-- Data for Name: tutorialsearchlinks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tutorialsearchlinks (search_link_id, tutorial_id, name_link) FROM stdin;
\.
COPY public.tutorialsearchlinks (search_link_id, tutorial_id, name_link) FROM '$$PATH$$/3701.dat';

--
-- Data for Name: usercomments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usercomments (comment_id, step_id, user_id, text) FROM stdin;
\.
COPY public.usercomments (comment_id, step_id, user_id, text) FROM '$$PATH$$/3707.dat';

--
-- Data for Name: videocontent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.videocontent (id, content_video_link, content_id) FROM stdin;
\.
COPY public.videocontent (id, content_video_link, content_id) FROM '$$PATH$$/3706.dat';

--
-- Data for Name: watch_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.watch_history (history_id, tutorial_id, user_id, last_watched_time, completed_steps) FROM stdin;
\.
COPY public.watch_history (history_id, tutorial_id, user_id, last_watched_time, completed_steps) FROM '$$PATH$$/3708.dat';

--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (user_id);


--
-- Name: favouritelist favouritelist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_pkey PRIMARY KEY (fav_id);


--
-- Name: material material_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_pkey PRIMARY KEY (material_id);


--
-- Name: picturecontent picturecontent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.picturecontent
    ADD CONSTRAINT picturecontent_pkey PRIMARY KEY (id);


--
-- Name: search_history search_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.search_history
    ADD CONSTRAINT search_history_pkey PRIMARY KEY (search_id);


--
-- Name: steps steps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_pkey PRIMARY KEY (step_id);


--
-- Name: substeps substeps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.substeps
    ADD CONSTRAINT substeps_pkey PRIMARY KEY (sub_step_id);


--
-- Name: substepslist substepslist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_pkey PRIMARY KEY (sub_step_list_id);


--
-- Name: textcontent textcontent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.textcontent
    ADD CONSTRAINT textcontent_pkey PRIMARY KEY (id);


--
-- Name: tools tools_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (tool_id);


--
-- Name: tutorialrating tutorialrating_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_pkey PRIMARY KEY (rating_id);


--
-- Name: tutorials tutorials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorials
    ADD CONSTRAINT tutorials_pkey PRIMARY KEY (tutorial_id);


--
-- Name: tutorialsearchlinks tutorialsearchlinks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorialsearchlinks
    ADD CONSTRAINT tutorialsearchlinks_pkey PRIMARY KEY (search_link_id);


--
-- Name: usercomments usercomments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_pkey PRIMARY KEY (comment_id);


--
-- Name: videocontent videocontent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.videocontent
    ADD CONSTRAINT videocontent_pkey PRIMARY KEY (id);


--
-- Name: watch_history watch_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_pkey PRIMARY KEY (history_id);


--
-- Name: favouritelist favouritelist_tutorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);


--
-- Name: favouritelist favouritelist_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- Name: material material_tutorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);


--
-- Name: picturecontent picturecontent_content_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.picturecontent
    ADD CONSTRAINT picturecontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;


--
-- Name: search_history search_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.search_history
    ADD CONSTRAINT search_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- Name: steps steps_tutorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);


--
-- Name: substepslist substepslist_step_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_step_id_fkey FOREIGN KEY (step_id) REFERENCES public.steps(step_id);


--
-- Name: substepslist substepslist_sub_step_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_sub_step_id_fkey FOREIGN KEY (sub_step_id) REFERENCES public.substeps(sub_step_id);


--
-- Name: textcontent textcontent_content_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.textcontent
    ADD CONSTRAINT textcontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;


--
-- Name: tools tools_tutorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);


--
-- Name: tutorialrating tutorialrating_tutorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);


--
-- Name: tutorialrating tutorialrating_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- Name: tutorials tutorials_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorials
    ADD CONSTRAINT tutorials_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- Name: tutorialsearchlinks tutorialsearchlinks_tutorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorialsearchlinks
    ADD CONSTRAINT tutorialsearchlinks_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);


--
-- Name: usercomments usercomments_step_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_step_id_fkey FOREIGN KEY (step_id) REFERENCES public.steps(step_id);


--
-- Name: usercomments usercomments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- Name: videocontent videocontent_content_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.videocontent
    ADD CONSTRAINT videocontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;


--
-- Name: watch_history watch_history_tutorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);


--
-- Name: watch_history watch_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                